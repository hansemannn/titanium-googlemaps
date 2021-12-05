/**
 * Ti.GoogleMaps
 * Copyright (c) 2015-present by Hans Knöchel. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiModule.h"

@class TiGooglemapsClusterItemProxy;

@interface TiGooglemapsModule : TiModule {
  NSString *_apiKey;
}

/**
 * Provides your API key to the Google Maps SDK for iOS.
 *
 * @param apiKey The API-key to use.
 * @since 1.0.0
 */
- (void)setAPIKey:(NSString *)apiKey;

/**
 * Enables the map to render using Metal instead of OpenGL.
 *
 * The rendering might look very slightly different between renderers. The default is @c false and
 * value must be updated before the services instance is initialized.
 *
 * @param metalRendererEnabled Whether or not the metal renderer should be enabled
 * @since 8.0.0
 */
- (void)setMetalRendererEnabled:(NSNumber *)metalRendererEnabled;

/**
 * Returns the version for this release of the Google Maps SDK for iOS.
 *
 * @return The GoogleMaps SDK version.
 * @since 1.0.0
 */
- (NSString *)version;

/**
 * Reverse geocodes a coordinate on the Earth's surface.
 *
 * @param apiKey The arguments passed to the reverse geocoder.
 * @since 3.1.0
 */
- (void)reverseGeocoder:(NSArray *)args;

/**
 * Calculates the directions between two given addresses.
 *
 * @param args The arguments passed to the directions-API.
 * @since 3.2.0
 */
- (void)getDirections:(NSArray *)args;


/**
 * Checks if a given geometry contains a given location.
 *
 * @param args The geometry and location.
 * @return Whether or not the geometry contains the location.
 * @since 5.2.0
 */
- (NSNumber *)geometryContainsLocation:(id)location;

/**
 * Calculates the distance between two points.
 *
 * @param args The two points
 * @return The distance in meters.
 * @since 5.2.0
*/
- (NSNumber *)geometryDistanceBetweenPoints:(id)locations;

/**
 * Decodes a given number of encoded polyline-points.
 *
 * @param args The polines to decode.
 * @since 3.2.0
 */
- (NSArray *)decodePolylinePoints:(NSArray *)args;

/**
 * Creates a new cluster-item.
 *
 * @param apiKey The API-key to use.
 * @since 2.7.0
 */
- (TiGooglemapsClusterItemProxy *)createClusterItem:(NSArray *)args;

@end
