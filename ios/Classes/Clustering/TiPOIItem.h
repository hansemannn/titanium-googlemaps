//
//  TiPOIItem.h
//  ti.googlemaps
//
//  Created by Hans Knoechel on 29/12/2016.
//
//

#import <Foundation/Foundation.h>
#import "GMUMarkerClustering.h"

@interface TiPOIItem : NSObject<GMUClusterItem>

@property(nonatomic, readonly) CLLocationCoordinate2D position;
@property(nonatomic, readonly) NSString *name;
@property(nonatomic, readonly) NSDictionary *userData;

- (instancetype)initWithPosition:(CLLocationCoordinate2D)position name:(NSString *)name userData:(NSDictionary *)userData;

@end

