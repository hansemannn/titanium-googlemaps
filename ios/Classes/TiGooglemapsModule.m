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
    [GMSServices provideAPIKey:[TiUtils stringValue:value]];
}

- (NSString *)openSourceLicenseInfo
{
    return [GMSServices openSourceLicenseInfo];
}

- (NSNumber *)version
{
    return NUMINTEGER([GMSServices version]);
}

- (void)reverseGeocodeCoordinate:(id)args
{
    ENSURE_ARG_COUNT(args, 2);
    
    NSDictionary *coordinate;
    KrollCallback *callback;
    
    ENSURE_ARG_AT_INDEX(coordinate, args, 0, NSDictionary);
    ENSURE_ARG_AT_INDEX(callback, args, 1, KrollCallback);
    
    CLLocationDegrees latitude = [TiUtils doubleValue:[coordinate valueForKey:@"latitude"]];
    CLLocationDegrees longitude = [TiUtils doubleValue:[coordinate objectForKey:@"longitude"]];
    
    [[GMSGeocoder geocoder] reverseGeocodeCoordinate:CLLocationCoordinate2DMake(latitude, longitude)
                                   completionHandler:^(GMSReverseGeocodeResponse *response, NSError *error) {
                                       NSDictionary *propertiesDict = @{
                                           @"firstResult": NULL_IF_NIL([self dictionaryFromAddress:response.firstResult]),
                                           @"results": [self arrayFromAddresses:response.results] ?: @[]
                                       };
                                       NSArray *invocationArray = [[NSArray alloc] initWithObjects:&propertiesDict count:1];
                                       
                                       [callback call:invocationArray thisObject:self];
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

#pragma mark Utilities

- (NSDictionary * _Nullable)dictionaryFromAddress:(GMSAddress *)address
{
    if (!address) {
        return nil;
    }
    
    return @{
        @"coordinate": @{
            @"latitude": NUMDOUBLE(address.coordinate.latitude),
            @"longitude": NUMDOUBLE(address.coordinate.longitude)
        },
        @"thoroughfare": NULL_IF_NIL(address.thoroughfare),
        @"locality": NULL_IF_NIL(address.locality),
        @"subLocality": NULL_IF_NIL(address.subLocality),
        @"administrativeArea": NULL_IF_NIL(address.administrativeArea),
        @"postalCode": NULL_IF_NIL(address.postalCode),
        @"country": NULL_IF_NIL(address.country),
        @"lines": NULL_IF_NIL(address.lines),
    };
}

- (NSArray * _Nullable)arrayFromAddresses:(NSArray<GMSAddress *> *)addresses
{
    if (!addresses) {
        return nil;
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
