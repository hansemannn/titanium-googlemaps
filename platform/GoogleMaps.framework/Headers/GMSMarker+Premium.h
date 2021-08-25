//
//  GMSMarker+Premium.h
//  Google Maps SDK for iOS
//
//  Copyright 2020 Google LLC
//
//  Usage of this SDK is subject to the Google Maps/Google Earth APIs Terms of
//  Service: https://developers.google.com/maps/terms
//

#import "GMSMarker.h"

/**
 * How markers interact with other markers and regular labels.
 *
 * Priority is defined as:
 * 1) Required > Optional
 * 2) zIndex: higher zIndex > lower zIndex
 *
 * Beyond this, it is undefined which marker will show if both are optional and have the same
 * zIndex.
 * Regular map labels are the lowest priority.
 **/
typedef NS_ENUM(NSInteger, GMSCollisionBehavior) {
  /**
   * Marker always shows, and does not prevent any overlapping optional markers or regular labels
   * from showing.
   * This is the default collision behavior.
   **/
  GMSCollisionBehaviorRequired,

  /**
   * Marker always shows, and prevents overlapping optional markers and regular labels from showing.
   **/
  GMSCollisionBehaviorRequiredAndHidesOptional,

  /**
   * Marker shows if there are no collisions with RequiredAndHidesOptional, or
   * OptionalAndHidesLowerPriority of higher priority labels, and prevents lower-priority
   * overlapping optional labels from showing.
   **/
  GMSCollisionBehaviorOptionalAndHidesLowerPriority,
};

@interface GMSMarker ()

/**
 * The marker's collision behavior, which determines whether or not the marker's visibility can be
 * affected by other markers or labeled content on the map.
 */
@property(nonatomic) GMSCollisionBehavior collisionBehavior;

@end
