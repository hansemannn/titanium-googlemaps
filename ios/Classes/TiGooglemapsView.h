/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-Present by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */
#import "TiUIView.h"
#import <GoogleMaps/GoogleMaps.h>
#import "GMUMarkerClustering.h"

@interface TiGooglemapsView : TiUIView<GMSMapViewDelegate, GMUClusterManagerDelegate>

@property(nonatomic, retain) GMSMapView *mapView;
@property(nonatomic, retain) GMUClusterManager *clusterManager;

@end
