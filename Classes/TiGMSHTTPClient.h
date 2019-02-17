//
//  GMSHTTPClient.h
//  ti.googlemaps
//
//  Created by Hans Knoechel on 07.02.17.
//
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Use the NSURLSession API to create a generic HTTP client that communicates with 
 the Google Maps REST API. This client currently only supports GET requests due to
 no related POST-endpoints on the API side.
*/
@interface TiGMSHTTPClient : NSObject

/**
 The initializer to create a new instance of the HTTP client.
 
 @param apiKey The Google Maps API-key.
 
 */
- (instancetype)initWithApiKey:(NSString *)apiKey;

/**
 Starts a new NSURLSessionDataTask to fetch an API resource.
 
 @param path The request path relative to the Google Maps base path.
 @param options A dictionary of options passed to the request.
 @param completionHandler The completion handler to be called when the request finished.
 
 @return An instance of the TiGMSHTTPCLient class.
 
 */
- (void)loadWithRequestPath:(NSString *)path
                 andOptions:(NSDictionary<NSString *, id> *)options
          completionHandler:(void (^)(NSDictionary<NSString *, id> *_Nullable json, NSError *_Nullable error))completionHandler;

/**
 Creates an url based on the api path and request options.
 
 @param path The request path relative to the Google Maps base path
 @param options A dictionary of options passed to the request.
 
 @return An entitled url containing url-friendy GET parameters.
 
 @see -loadWithRequestPath:andOptions:completionHandler
 */
- (NSURL *)entitledURLWithPath:(NSString *)path andOptions:(NSDictionary *_Nullable)options;

/**
 Formats a given array of waypoints to a string that can be passed to the request.
 
 @param array An array of waypoints.
 @return A formmated string to be passed to the URL.
 
 */
+ (NSString *_Nullable)formattedWaypointsFromArray:(NSArray<NSString *> *_Nullable)array;

/**
 The Google Maps API key used to communicate with the API.
 The API key can be generated at https://developers.google.com/maps/documentation/geocoding/get-api-key
 */
@property (nonatomic, strong, readonly) NSString *apiKey;

@end

NS_ASSUME_NONNULL_END
