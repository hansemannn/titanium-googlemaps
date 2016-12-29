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

- (instancetype)initWithPosition:(CLLocationCoordinate2D)position name:(NSString *)name;

@end

