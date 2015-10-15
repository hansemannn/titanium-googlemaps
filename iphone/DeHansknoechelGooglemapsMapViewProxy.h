/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2015 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */
#import "TiViewProxy.h"
#import "DeHansknoechelGooglemapsMapView.h"

@interface DeHansknoechelGooglemapsMapViewProxy : TiViewProxy {
    DeHansknoechelGooglemapsMapView* mapView;
}

-(void)addMarker:(id)args;
-(void)removeMarker:(id)args;

@end
