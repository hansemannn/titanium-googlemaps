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

- (id)_initWithPageContext:(id<TiEvaluator>)context andIndoorDisplay:(GMSIndoorLevel *)indoorLevel;

- (GMSIndoorLevel *)indoorLevel;

#pragma mark Public API

/**
 * The floor name (can be null).
 *
 * @return The name.
 * @since 3.8.0
 */
- (NSString *)name;

/**
 * The floor short-name (can be null).
 *
 * @return The short-name.
 * @since 3.8.0
 */
- (NSString *)shortName;

@end
