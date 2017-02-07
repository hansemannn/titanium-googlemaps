/**
 * Ti.GoogleMaps
 * Copyright (c) 2015-Present by Hans Knoechel, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiModule.h"

@class TiGooglemapsClusterItemProxy;

@interface TiGooglemapsModule : TiModule {
    NSString *apiKey;
}

- (void)setAPIKey:(id)value;

- (NSString *)version;

- (void)reverseGeocoder:(id)args;

- (void)getDirections:(id)args;

- (TiGooglemapsClusterItemProxy *)createClusterItem:(id)args;

@end
