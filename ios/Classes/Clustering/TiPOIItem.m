//
//  TiPOIItem.m
//  ti.googlemaps
//
//  Created by Hans Knoechel on 29/12/2016.
//
//

#import "TiPOIItem.h"

@implementation TiPOIItem

- (instancetype)initWithPosition:(CLLocationCoordinate2D)position name:(NSString *)name userData:(NSDictionary *)userData
{
    if (self = [super init]) {
        _position = position;
        _name = [name copy];
        _userData = [userData retain];
    }
    return self;
}

@end
