/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2015 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */
#import "TiViewProxy.h"
#import "DeHansknoechelGooglemapsMapView.h"

@interface DeHansknoechelGooglemapsMapViewProxy : TiViewProxy<GMSMapViewDelegate> {
    DeHansknoechelGooglemapsMapView* mapView;
}

-(void)setMapView:(GMSMapView*)mapView;

-(void)addMarker:(id)args;
-(void)addMarkers:(id)args;
-(void)removeMarker:(id)args;

-(void)addPolyline:(id)args;
-(void)removePolyline:(id)args;

-(void)addPolygon:(id)args;
-(void)removePolygon:(id)args;

-(void)addCircle:(id)args;
-(void)removeCircle:(id)args;

@end
