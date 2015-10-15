/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2015 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "DeHansknoechelGooglemapsMapView.h"
#import "DeHansknoechelGooglemapsMarkerProxy.h"

@implementation DeHansknoechelGooglemapsMapView

-(void)initializeState
{
    mapView = [self mapView];
    [super initializeState];
}

-(GMSMapView*)mapView
{
    if(mapView == nil) {
        
        // TODO: Own proxy maps.createCamera({latitude:longitude:zoom})
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.86 longitude:151.20 zoom:6];
        
        mapView = [GMSMapView mapWithFrame:self.bounds camera:camera];
        mapView.delegate = self;
        mapView.myLocationEnabled = [TiUtils boolValue:[[self proxy] valueForKey:@"myLocationEnabled"] def:YES];
        mapView.userInteractionEnabled = [TiUtils boolValue:[[self proxy] valueForKey:@"userInteractionEnabled"] def:YES];
        mapView.autoresizingMask = UIViewAutoresizingNone;
        
        [self addSubview:mapView];
    }
    
    return mapView;
}

- (void)frameSizeChanged:(CGRect)frame bounds:(CGRect)bounds
{
    [TiUtils setView:mapView positionRect:bounds];
    [super frameSizeChanged:frame bounds:bounds];
}

#pragma mark Public API's

-(void)setMyLocationEnabled_:(id)value
{
    ENSURE_UI_THREAD_1_ARG(value);
    ENSURE_TYPE(value, NSNumber);
    
    [mapView setMyLocationEnabled:[TiUtils boolValue:value]];
}

-(NSNumber*)myLocationEnabled
{
    return NUMBOOL([mapView isMyLocationEnabled]);
}

-(void)setMapType_:(id)value
{
    ENSURE_UI_THREAD_1_ARG(value);
    ENSURE_TYPE(value, NSNumber);
    
    [mapView setMapType:[TiUtils intValue:value def:kGMSTypeNormal]];
}

-(NSNumber*)mapType
{
    return NUMINT([mapView mapType]);
}

@end
