/**
 * Ti.GoogleMaps
 * Copyright (c) 2009-Present by Hans Knoechel, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiGooglemapsClusterItemProxy.h"
#import "TiBlob.h"
#import "TiUtils.h"

@implementation TiGooglemapsClusterItemProxy

- (id)_initWithPageContext:(id<TiEvaluator>)context
               andPosition:(CLLocationCoordinate2D)position
                     title:(NSString *)title
                     subtitle:(NSString *)subtitle
                     icon:(id)icon
                  userData:(NSDictionary *)userData
{
    if (self = [super _initWithPageContext:context]) {
        UIImage *nativeIcon = nil;
        
        if ([icon isKindOfClass:[UIImage class]]) {
            nativeIcon = [icon retain];
        } else {
            nativeIcon = [[TiUtils toImage:icon proxy:self] retain];
        }
        
        clusterItem = [[TiPOIItem alloc] initWithPosition:position
                                                 andTitle:title
                                                 subtitle:subtitle
                                                     icon:nativeIcon
                                                 userData:userData];
        
        RELEASE_TO_NIL(nativeIcon);
    }
    
    return self;
}

- (TiPOIItem *)clusterItem
{
    return clusterItem;
}

@end
