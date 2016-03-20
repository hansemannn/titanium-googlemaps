/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2015 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */
#import "TiViewProxy.h"
#import <GoogleMaps/GoogleMaps.h>

@interface TiGooglemapsMarkerProxy : TiProxy<GMSMapViewDelegate>

@property(nonatomic,retain) GMSMarker *marker;

// TODO: Document properties

-(void)setMarker:(GMSMarker*)marker;

-(void)setTitle:(id)value;

-(void)setSnippet:(id)value __attribute((deprecated("Use subtitle instead.")));

-(void)setSubtitle:(id)value;

-(void)setInfoWindowAnchor:(id)args __attribute((deprecated("Use centerOffset instead.")));

-(void)setCenterOffset:(id)args;

-(void)setGroundOffset:(id)args;

-(void)setIcon:(id)value __attribute((deprecated("Use image instead.")));

-(void)setImage:(id)value;

-(void)setPinColor:(id)value;

-(void)setTappable:(id)value __attribute((deprecated("Use touchEnabled instead.")));;

-(void)setTouchEnabled:(id)value;

-(void)setFlat:(id)value;

-(void)setDraggable:(id)value;

-(void)setOpacity:(id)value;

-(void)setAnimationStyle:(id)value;

-(void)setUserData:(id)value;

@end
