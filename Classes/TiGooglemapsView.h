/**
 * Ti.GoogleMaps
 * Copyright (c) 2015-present by Hans Knöchel. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */
#import "GMUMarkerClustering.h"
#import "TiUIView.h"
#import <GoogleMaps/GoogleMaps.h>
#import "TiClusterRenderer.h"

@interface TiGooglemapsView : TiUIView <GMSMapViewDelegate, GMUClusterManagerDelegate, GMUClusterRendererDelegate>

@property (nonatomic, strong) GMSMapView *mapView;

@property (nonatomic, strong) GMUClusterManager *clusterManager;

@property (nonatomic, strong) TiClusterRenderer *clusterRenderer;

@end
