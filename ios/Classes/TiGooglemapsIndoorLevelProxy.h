/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2017 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */
#import "TiProxy.h"
#import <GoogleMaps/GoogleMaps.h>

@interface TiGooglemapsIndoorLevelProxy : TiProxy {
    GMSIndoorLevel *_indoorLevel;
}

- (id _Nonnull)_initWithPageContext:(id<TiEvaluator> _Nullable)context andIndoorLevel:(GMSIndoorLevel * _Nonnull)indoorLevel;

- (GMSIndoorLevel * _Nonnull)indoorLevel;

#pragma mark Public API

/**
 * The floor name (can be null).
 *
 * @return The name.
 * @since 3.8.0
 */
- (NSString * _Nullable)name;

/**
 * The floor short-name (can be null).
 *
 * @return The short-name.
 * @since 3.8.0
 */
- (NSString * _Nullable)shortName;

@end
