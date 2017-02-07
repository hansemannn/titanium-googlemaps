//
//  GMSHTTPClient.h
//  ti.googlemaps
//
//  Created by Hans Knoechel on 07.02.17.
//
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TiGMSHTTPClient : NSObject {

}

@property(nonatomic, strong, readonly, nonnull) NSString *apiKey;

- (instancetype _Nonnull )initWithApiKey:(NSString * _Nonnull)apiKey;

- (void)loadWithRequestPath:(NSString *)path andOptions:(NSDictionary *)options completionHandler:(void (^)(NSDictionary * _Nullable json, NSError * _Nullable error))completionHandler;

@end

NS_ASSUME_NONNULL_END
