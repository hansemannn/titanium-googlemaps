/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2017 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */
#import "TiProxy.h"
#import <GoogleMaps/GoogleMaps.h>

@interface TiGooglemapsIndoorDisplayProxy : TiProxy<GMSIndoorDisplayDelegate> {
    GMSIndoorDisplay *_indoorDisplay;
}

- (id)_initWithPageContext:(id<TiEvaluator>)context andIndoorDisplay:(GMSIndoorDisplay *)indoorDisplay;

#pragma mark Public API

- (id)activeBuilding;

- (id)activeLevel;

- (id)setActiveLevel:(id)activeLevel;

@end
