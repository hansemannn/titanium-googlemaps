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

- (instancetype)initWithApiKey:(NSString * _Nonnull)apiKey
{
    if (self = [super init]) {
        _apiKey = apiKey;
    }
    
    return self;
}

- (void)loadWithRequestPath:(NSString *)path andOptions:(NSDictionary *)options completionHandler:(void (^)(NSDictionary *json, NSError * _Nullable error))completionHandler
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

- (NSURL *)entitledURLWithPath:(NSString *)path andOptions:(NSDictionary *)options
{
    NSURLComponents *url = [NSURLComponents componentsWithString:[NSString stringWithFormat:@"%@/%@", kTiGoogleMapsBasePath, path]];
    NSMutableArray<NSURLQueryItem *> *queryItems = [NSMutableArray arrayWithCapacity:options.count];
    
    for (NSString *option in options) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:option value:[options objectForKey:option]]];
    }
    
    [url setQueryItems:queryItems];
    
    return [NSURL URLWithString:[[[url URL] absoluteString] stringByAppendingString:[NSString stringWithFormat:@"&key=%@", _apiKey]]];
}

@end
