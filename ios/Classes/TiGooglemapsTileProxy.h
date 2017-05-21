/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2017 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */
#import "TiProxy.h"
#import <GoogleMaps/GoogleMaps.h>

@interface TiGooglemapsTileProxy : TiProxy<GMSTileReceiver> {
    
}

@property(nonatomic, strong) GMSURLTileLayer *tile;

/**
 * Set the tile z-index.
 *
 * @since 3.2.0
 */
- (void)setZIndex:(id)value;

/**
 * Set the tile opacity.
 *
 * @since 3.2.0
 */
- (void)setOpacity:(id)value;

/**
 * Enable / Disable fading in the tile.
 *
 * @since 3.2.0
 */
- (void)setFadeIn:(id)value;

/**
 * Set the tile size
 *
 * @since 3.2.0
 */
- (void)setSize:(id)value;

/**
 * Set the user agent when requesting the url.
 *
 * @since 3.2.0
 */
- (void)setUserAgent:(id)value;

/**
 * Clear the current tile cache.
 *
 * @since 3.2.0
 */
- (void)clearTileCache:(id)unused;

@end
