//
//  GMSPlaceLocationOptions.h
//  Google Places SDK for iOS
//
//  Copyright 2019 Google Inc.
//
//  Usage of this SDK is subject to the Google Maps/Google Earth APIs Terms of
//  Service: https://developers.google.com/maps/terms
//


#import <CoreLocation/CoreLocation.h>

@protocol GMSPlaceLocationBias;
@protocol GMSPlaceLocationRestriction;

NS_ASSUME_NONNULL_BEGIN

/*
 * Returns a rectangular location to filter place results inside the boundaries.
 * Supports filtering as a restriction where results must be inside the bounds, or as a bias where
 * results in the bounds are preferred.
 *
 * @param northEastBounds The north east corner of the bounds.
 * @param southWestBounds The south west corner of the bounds.
 */
FOUNDATION_EXTERN id<GMSPlaceLocationBias, GMSPlaceLocationRestriction>
GMSPlaceRectangularLocationOption(CLLocationCoordinate2D northEastBounds,
                                  CLLocationCoordinate2D southWestBounds);

NS_ASSUME_NONNULL_END
