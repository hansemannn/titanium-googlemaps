//
//  GMSHTTPClient.m
//  ti.googlemaps
//
//  Created by Hans Knoechel on 07.02.17.
//
//

#import "TiGMSHTTPClient.h"

NSString *const kTiGoogleMapsBasePath = @"https://maps.googleapis.com/maps/api";

@implementation TiGMSHTTPClient

#pragma mark Public API

- (instancetype)initWithApiKey:(NSString *)apiKey;
{
    if (self = [super init]) {
        _apiKey = apiKey;
    }
    
    return self;
}

- (void)loadWithRequestPath:(NSString *)path
                 andOptions:(NSDictionary<NSString *, id> *)options
          completionHandler:(void (^)(NSDictionary<NSString *, id> * _Nullable json, NSError * _Nullable error))completionHandler
{
    NSURLSession *mapsSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionDataTask *mapsDataTask = [mapsSession dataTaskWithURL:[self entitledURLWithPath:path andOptions:options] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary *json;
        
        if (error) {
            completionHandler(nil, error);
            return;
        }
        
        json  = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        if ([json objectForKey:@"error_message"]) {
            completionHandler(json, error);
            return;
        }
        
        completionHandler(json, nil);
    }];
    
    [mapsDataTask resume];
}

- (NSURL *)entitledURLWithPath:(NSString *)path andOptions:(NSDictionary * _Nullable)options
{
    NSURLComponents *url = [NSURLComponents componentsWithString:[NSString stringWithFormat:@"%@/%@", kTiGoogleMapsBasePath, path]];
    NSMutableArray<NSURLQueryItem *> *queryItems = [NSMutableArray arrayWithCapacity:options.count];
    
    for (NSString *option in options) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:option value:[options objectForKey:option]]];
    }
    
    [url setQueryItems:queryItems];
    
    return [NSURL URLWithString:[[[url URL] absoluteString] stringByAppendingString:[NSString stringWithFormat:@"&key=%@", _apiKey]]];
}

#pragma mark Utilities

+ (NSString * _Nullable)formattedWaypointsFromArray:(NSArray<NSString *> * _Nullable)array
{
    if (!array) {
        return nil;
    }
    
    NSString *waypoints = [NSString string];
    
    // Generate a string like "city1|city2|
    for (NSString *destination in array) {
        waypoints = [waypoints stringByAppendingString:[NSString stringWithFormat:@"%@|", destination]];
    }
    
    // Remove the last "|"
    waypoints = [waypoints substringWithRange:NSMakeRange(0, waypoints.length -1)];
    
    return waypoints;
}

@end
