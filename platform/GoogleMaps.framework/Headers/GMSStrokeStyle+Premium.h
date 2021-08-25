//
//  GMSStrokeStyle+Premium.h
//  Google Maps SDK for iOS
//
//  Copyright 2020 Google LLC
//
//  Usage of this SDK is subject to the Google Maps/Google Earth APIs Terms of
//  Service: https://developers.google.com/maps/terms
//

#import "GMSStrokeStyle.h"

@class GMSStampStyle;

NS_ASSUME_NONNULL_BEGIN

@interface GMSStrokeStyle ()

/**
 * A repeated image over the stroke to allow a user to set a 2D texture on top of a stroke.
 * If the image has transparent or semi-transparent portions, the underlying stroke color will show
 * through in those places. Solid portions of the stamp will completely cover the base stroke.
 *
 * Known issue: If this is a texture stamp set on a gradient stroke, only one of the stroke colors
 * will be used. To still have a gradient, make the stroke color clear here, and have a separate
 * polyline with the gradient below this line.
 */
@property(nonatomic, strong, nullable) GMSStampStyle* stampStyle;

@end

NS_ASSUME_NONNULL_END
