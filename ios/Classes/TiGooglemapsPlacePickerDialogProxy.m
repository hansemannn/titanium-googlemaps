/**
 * Ti.GoogleMaps
 * Copyright (c) 2015-Present by Hans Knoechel, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiGooglemapsPlacePickerDialogProxy.h"
#import "TiApp.h"

#import <GoogleMaps/GoogleMaps.h>

@implementation TiGooglemapsPlacePickerDialogProxy

#pragma mark Public APIs

- (GMSPlacePickerViewController *)dialog
{
    if (dialog == nil) {
        NSDictionary *config = [self valueForKey:@"config"];
        id viewport = [config valueForKey:@"viewport"];
        GMSCoordinateBounds *bounds = nil;
      
        if (viewport != nil) {
            id northEast = [viewport valueForKey:@"northEast"];
            double northEastLatitude = [TiUtils doubleValue:[northEast valueForKey:@"latitude"]];
            double northEastLongitude = [TiUtils doubleValue:[northEast valueForKey:@"longitude"]];
          
            id southWest = [viewport valueForKey:@"southWest"];
            double southWestLatitude = [TiUtils doubleValue:[southWest valueForKey:@"latitude"]];
            double southWestLongitude = [TiUtils doubleValue:[southWest valueForKey:@"longitude"]];

            bounds = [[GMSCoordinateBounds alloc] initWithCoordinate:CLLocationCoordinate2DMake(northEastLatitude, northEastLongitude)
                                                          coordinate:CLLocationCoordinate2DMake(southWestLatitude, southWestLongitude)];
        }
      
        GMSPlacePickerConfig *gmsConfig = [[GMSPlacePickerConfig alloc] initWithViewport:bounds];
      
        dialog = [[GMSPlacePickerViewController alloc] initWithConfig:gmsConfig];
        [dialog setDelegate:self];
    }
    
    return dialog;
}

- (void)configure:(id)value
{
    ENSURE_SINGLE_ARG(value, NSString);
    [GMSServices provideAPIKey:value];
}

- (void)open:(id)args
{
    [self rememberSelf];
    ENSURE_UI_THREAD(open, args);

    id animated = [args valueForKey:@"animated"];
    ENSURE_TYPE_OR_NIL(animated, NSNumber);
    
    [[TiApp app] showModalController:[self dialog] animated:[TiUtils boolValue:animated def:YES]];
}

#pragma mark - Delegates

- (void)placePicker:(GMSPlacePickerViewController *)viewController didPickPlace:(GMSPlace *)place
{
  if ([self _hasListeners:@"success"]) {
    [self fireEvent:@"success" withObject:@{
      @"place": [TiGooglemapsPlacePickerDialogProxy dictionaryFromPlace:place]
    }];
  }
  
  [self closeDialog];
}

- (void)placePicker:(GMSPlacePickerViewController *)viewController didFailWithError:(NSError *)error
{
  if ([self _hasListeners:@"error"]) {
    [self fireEvent:@"error" withObject:@{
      @"error": [error localizedDescription],
      @"code": NUMINTEGER([error code])
    }];
  }
  
  [self closeDialog];
}

- (void)placePickerDidCancel:(GMSPlacePickerViewController *)viewController
{
  if ([self _hasListeners:@"cancel"]) {
    [self fireEvent:@"cancel" withObject:nil];
  }
  
  [self closeDialog];
}

#pragma mark Utilities

- (void)closeDialog
{
    [[self dialog] setDelegate:nil];
    [[self dialog] dismissViewControllerAnimated:YES completion:nil];
    [self forgetSelf];
}

+ (NSDictionary *)dictionaryFromPlace:(GMSPlace*)place
{
    return @{
        @"name": [place name],
        @"placeID": [place placeID],
        @"latitude": NUMDOUBLE([place coordinate].latitude),
        @"longitude": NUMDOUBLE([place coordinate].longitude),
        @"formattedAddress": [place formattedAddress],
        @"addressComponents": [TiGooglemapsPlacePickerDialogProxy arrayFromAddressComponents:[place addressComponents]]
    };
}

+ (id)arrayFromAddressComponents:(NSArray<GMSAddressComponent*>*)addressComponents
{
    if (addressComponents == nil) {
        return [NSNull null];
    }
    
    NSMutableArray *result = [NSMutableArray new];
    for (GMSAddressComponent *addressComponent in addressComponents) {
        [result addObject:@{
            @"type": addressComponent.type,
            @"name":addressComponent.name
        }];
    }
    
    return result;
}

@end
