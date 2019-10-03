/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2017 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import <TitaniumKit/TitaniumKit.h>
#import <GoogleMaps/GoogleMaps.h>

@interface TiGooglemapsIndoorDisplayProxy : TiProxy <GMSIndoorDisplayDelegate> {
  GMSIndoorDisplay *_indoorDisplay;
}

- (id)_initWithPageContext:(id<TiEvaluator>)context andIndoorDisplay:(GMSIndoorDisplay *)indoorDisplay;

#pragma mark Public API

/**
 * The active building.
 *
 * @since 3.8.0
 */
- (id)activeBuilding;

/**
 * The active floor-level.
 *
 * @since 3.8.0
 */
- (id)activeLevel;

/**
 * Set the active floor-level.
 *
 * @param activeLevel The new active floor-level.
 * @since 3.8.0
 */
- (void)setActiveLevel:(id)activeLevel;

@end
