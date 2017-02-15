/**
 * Ti.GoogleMaps
 * Copyright (c) 2015-Present by Hans Knoechel, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"
#import "TiGooglemapsModule.h"
#import "TiGooglemapsClusterItemProxy.h"
#import "TiGMSHTTPClient.h"
#import <GoogleMaps/GoogleMaps.h>

@implementation TiGooglemapsModule

#pragma mark Internal

- (id)moduleGUID
{
	return @"81fe0326-e874-4843-b902-51bbd46f9283";
}

- (NSString *)moduleId
{
	return @"ti.googlemaps";
}

#pragma mark Lifecycle

- (void)startup
{
	[super startup];

	NSLog(@"[INFO] %@ loaded",self);
}

#pragma Public APIs

- (void)setAPIKey:(id)value
{
    apiKey = [TiUtils stringValue:value];
    [GMSServices provideAPIKey:apiKey];
}

- (NSString *)openSourceLicenseInfo
{
    __block NSString *openSourceLicenseInfo;
    
    TiThreadPerformOnMainThread(^{
        openSourceLicenseInfo = [GMSServices openSourceLicenseInfo];
    }, YES);
    
    return openSourceLicenseInfo;
}

- (NSString *)version
{
    __block NSString *version;
    
    TiThreadPerformOnMainThread(^{
        version = [GMSServices SDKVersion];
    }, YES);
    
    return version;
}

- (void)reverseGeocoder:(id)args
{
    ENSURE_UI_THREAD(reverseGeocoder, args);
    ENSURE_ARG_COUNT(args, 3);
    
    KrollCallback *callback;
    NSNumber *latitude;
    NSNumber *longitude;
    
    ENSURE_ARG_AT_INDEX(latitude, args, 0, NSNumber);
    ENSURE_ARG_AT_INDEX(longitude, args, 1, NSNumber);
    ENSURE_ARG_AT_INDEX(callback, args, 2, KrollCallback);
    
    [[GMSGeocoder geocoder] reverseGeocodeCoordinate:CLLocationCoordinate2DMake(latitude.doubleValue, longitude.doubleValue)
                                   completionHandler:^(GMSReverseGeocodeResponse *response, NSError *error) {
                                       NSMutableDictionary *propertiesDict = [NSMutableDictionary dictionaryWithDictionary:@{
                                           @"firstPlace": NULL_IF_NIL([self dictionaryFromAddress:response.firstResult]),
                                           @"places": [self arrayFromAddresses:response.results]
                                       }];
                                       
                                       if (!response.results || response.results.count == 0) {
                                           [propertiesDict setValue:@"No places found" forKey:@"error"];
                                           [propertiesDict setValue:NUMINT(1) forKey:@"code"];
                                           [propertiesDict setValue:NUMBOOL(NO) forKey:@"success"];
                                       } else {
                                           [propertiesDict setValue:NUMINT(0) forKey:@"code"];
                                           [propertiesDict setValue:NUMBOOL(YES) forKey:@"success"];
                                       }
                                       
                                       NSArray *invocationArray = [[NSArray alloc] initWithObjects:&propertiesDict count:1];
                                       
                                       [callback call:invocationArray thisObject:self];
                                   }];
}

- (void)getDirections:(id)args
{
    ENSURE_SINGLE_ARG(args, NSDictionary);
    
    id successCallback = [args objectForKey:@"success"];
    id errorCallback = [args objectForKey:@"error"];
    id origin = [args objectForKey:@"origin"];
    id destination = [args objectForKey:@"destination"];
    id waypoints = [args objectForKey:@"waypoints"];
    
    ENSURE_TYPE(successCallback, KrollCallback);
    ENSURE_TYPE(errorCallback, KrollCallback);
    ENSURE_TYPE(origin, NSString);
    ENSURE_TYPE(destination, NSString);
    ENSURE_TYPE_OR_NIL(waypoints, NSArray);
    
    
    TiGMSHTTPClient *httpClient = [[TiGMSHTTPClient alloc] initWithApiKey:apiKey];

    NSMutableDictionary *options = [NSMutableDictionary dictionaryWithDictionary:@{
        @"origin": origin,
        @"destination": destination,
    }];

    if (waypoints) {
        [options setObject:[TiGMSHTTPClient formattedWaypointsFromArray:waypoints] forKey:@"waypoints"];
    }
    
    [httpClient loadWithRequestPath:@"directions/json"
                         andOptions:options
                  completionHandler:^(NSDictionary *json, NSError *error) {
                      if (error) {
                          NSDictionary *errorObject = [TiUtils dictionaryWithCode:1 message:[error localizedDescription]];
                          NSArray *invocationArray = [[NSArray alloc] initWithObjects:&errorObject count:1];
                          
                          TiThreadPerformOnMainThread(^{
                              [errorCallback call:invocationArray thisObject:self];
                          }, NO);

                          return;
                      }
                      
                      TiThreadPerformOnMainThread(^{
                          NSArray *invocationArray = [[NSArray alloc] initWithObjects:&json count:1];
                          [successCallback call:invocationArray thisObject:self];
                      }, NO);
                  }];
}

- (TiGooglemapsClusterItemProxy *)createClusterItem:(id)args
{
    ENSURE_SINGLE_ARG(args, NSDictionary);
    
    id latitude = [args objectForKey:@"latitude"];
    ENSURE_TYPE(latitude, NSNumber);
    
    id longitude = [args objectForKey:@"longitude"];
    ENSURE_TYPE(longitude, NSNumber);
    
    id title = [args objectForKey:@"title"];
    ENSURE_TYPE_OR_NIL(title, NSString);

    id subtitle = [args objectForKey:@"subtitle"];
    ENSURE_TYPE_OR_NIL(subtitle, NSString);

    id icon = [args objectForKey:@"icon"];

    id userData = [args objectForKey:@"userData"];
    ENSURE_TYPE_OR_NIL(userData, NSDictionary);
    
    return [[TiGooglemapsClusterItemProxy alloc] _initWithPageContext:[self pageContext]
                                                          andPosition:CLLocationCoordinate2DMake([TiUtils doubleValue:latitude], [TiUtils doubleValue:longitude])
                                                                title:title
                                                             subtitle:subtitle
                                                                 icon:icon
                                                             userData:userData];
}

- (id)decodePolylinePoints:(id)args
{
    ENSURE_SINGLE_ARG(args, NSString);
    
    GMSPath *path = [GMSPath pathFromEncodedPath:args];
    NSMutableArray *coordinates = [NSMutableArray arrayWithCapacity:path.count];
    
    for (NSUInteger i = 0; i < path.count; i++) {
        CLLocationCoordinate2D location = [path coordinateAtIndex:i];
        [coordinates addObject:@{@"latitude": NUMDOUBLE(location.latitude), @"longitude": NUMDOUBLE(location.longitude)}];
    }
    
    return coordinates;
}

#pragma mark Utilities

- (NSDictionary * _Nullable)dictionaryFromAddress:(GMSAddress *)address
{
    if (!address) {
        return nil;
    }
    
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    
    if (address.coordinate.latitude && address.coordinate.longitude) {
        [result setObject:NUMDOUBLE(address.coordinate.latitude) forKey:@"latitude"];
        [result setObject:NUMDOUBLE(address.coordinate.longitude) forKey:@"longitude"];
    }
    
    if (address.thoroughfare) {
        [result setObject:address.thoroughfare forKey:@"thoroughfare"];
    }
    
    if (address.locality) {
        [result setObject:address.locality forKey:@"locality"];
    }
    
    if (address.subLocality) {
        [result setObject:address.subLocality forKey:@"subLocality"];
    }
    
    if (address.administrativeArea) {
        [result setObject:address.administrativeArea forKey:@"administrativeArea"];
    }
    
    if (address.postalCode) {
        [result setObject:address.postalCode forKey:@"postalCode"];
    }
    
    if (address.country) {
        [result setObject:address.country forKey:@"country"];
    }
    
    if (address.lines) {
        [result setObject:address.lines forKey:@"lines"];
    }
    
    return result;
}

- (NSArray *)arrayFromAddresses:(NSArray<GMSAddress *> *)addresses
{
    if (!addresses) {
        return @[];
    }
    
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:[addresses count]];
    
    for (GMSAddress *address in addresses) {
        [result addObject:[self dictionaryFromAddress:address]];
    }
    
    return result;
}

#pragma mark Constants

MAKE_SYSTEM_PROP(MAP_TYPE_HYBRID, kGMSTypeHybrid);
MAKE_SYSTEM_PROP(MAP_TYPE_NONE, kGMSTypeNone);
MAKE_SYSTEM_PROP(MAP_TYPE_NORMAL, kGMSTypeNormal);
MAKE_SYSTEM_PROP(MAP_TYPE_SATELLITE, kGMSTypeSatellite);
MAKE_SYSTEM_PROP(MAP_TYPE_TERRAIN, kGMSTypeTerrain);

MAKE_SYSTEM_PROP(APPEAR_ANIMATION_NONE, kGMSMarkerAnimationNone);
MAKE_SYSTEM_PROP(APPEAR_ANIMATION_POP, kGMSMarkerAnimationPop);

@end
