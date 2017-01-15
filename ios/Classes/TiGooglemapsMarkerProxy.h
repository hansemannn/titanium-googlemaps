/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-Present by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */
#import "TiViewProxy.h"
#import <GoogleMaps/GoogleMaps.h>

@interface TiGooglemapsMarkerProxy : TiProxy<GMSMapViewDelegate>

@property(nonatomic,retain) GMSMarker *marker;

/**
 *  Sets the native marker.
 *
 *  @param marker The marker
 *  @since 1.0.0
 */
-(void)setMarker:(GMSMarker*)marker;

/**
 *  Sets the annotation title.
 *
 *  @param value The title
 *  @since 1.0.0
 */
-(void)setTitle:(id)value;

/**
 *  Sets the annotation snippet.
 *
 *  @param value The snippet
 *  @deprecated 2.2.0
 *  @since 1.0.0
 */
-(void)setSnippet:(id)value __attribute((deprecated("Use subtitle instead.")));

/**
 *  Sets the annotation subtitle.
 *
 *  @param value The subtitle
 *  @since 2.2.0
 */
-(void)setSubtitle:(id)value;

/**
 *  Sets the annotation info window offset.
 *
 *  @param args The point
 *  @deprecated 2.2.0
 *  @since 1.0.0
 */
-(void)setInfoWindowAnchor:(id)args __attribute((deprecated("Use centerOffset instead.")));

/**
 *  Sets the annotation center offset.
 *
 *  @param args The point
 *  @since 2.2.0
 */
-(void)setCenterOffset:(id)args;

/**
 *  Sets the annotation ground offset.
 *
 *  @param args The point
 *  @since 2.2.0
 */
-(void)setGroundOffset:(id)args;

/**
 *  Sets the annotation icon.
 *
 *  @param value The icon
 *  @deprecated 2.2.0
 *  @since 1.0.0
 */
-(void)setIcon:(id)value __attribute((deprecated("Use image instead.")));

/**
 *  Sets the annotation image.
 *
 *  @param value The image
 *  @since 2.1.0
 */
-(void)setImage:(id)value;

/**
 *  Sets the annotation pin color.
 *
 *  @param value The color
 *  @since 2.1.0
 */
-(void)setPinColor:(id)value;

/**
 *  Sets the annotation touch-capacity.
 *
 *  @param value The boolean capacity
 *  @deprecated 2.2.0
 *  @since 1.0.0
 */
-(void)setTappable:(id)value __attribute((deprecated("Use touchEnabled instead.")));;

/**
 *  Sets the annotation touch-capacity.
 *
 *  @param value The boolean capacity
 *  @since 2.2.0
 */
-(void)setTouchEnabled:(id)value;

/**
 *  Sets the annotation flat-capacity.
 *
 *  @param value The boolean capacity
 *  @since 1.0.0
 */
-(void)setFlat:(id)value;

/**
 *  Sets the annotation draggable-capacity.
 *
 *  @param value The boolean capacity
 *  @since 1.0.0
 */
-(void)setDraggable:(id)value;

/**
 *  Sets the annotation opacity.
 *
 *  @param value The boolean opacity
 *  @since 2.2.0
 */
-(void)setOpacity:(id)value;

/**
 *  Sets the annotation animation style.
 *
 *  @param value The animation style
 *  @since 2.2.0
 */
-(void)setAnimationStyle:(id)value;

/**
 *  Sets the annotation user data.
 *
 *  @param value The user data
 *  @since 1.0.0
 */
-(void)setUserData:(id)value;

@end
