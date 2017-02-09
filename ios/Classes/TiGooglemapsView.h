/**
 * Ti.GoogleMaps
 * Copyright (c) 2015-Present by Hans Knoechel, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */
#import "TiUIView.h"
#import <GoogleMaps/GoogleMaps.h>
#import "GMUMarkerClustering.h"

@interface TiGooglemapsView : TiUIView<GMSMapViewDelegate, GMUClusterManagerDelegate, GMUClusterRendererDelegate>

@property(nonatomic, strong) GMSMapView *mapView;
@property(nonatomic, strong) GMUClusterManager *clusterManager;

@end
