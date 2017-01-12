/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2016 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiGooglemapsAutocompleteDialogProxy.h"
#import "TiApp.h"

@implementation TiGooglemapsAutocompleteDialogProxy

#pragma mark Memory Management

- (void)dealloc
{
    dialog.delegate = nil;
    RELEASE_TO_NIL(dialog);
    
    [super dealloc];
}

#pragma mark Public APIs

- (GMSAutocompleteViewController*)dialog
{
    if (dialog == nil) {
        dialog = [GMSAutocompleteViewController new];
        [dialog setDelegate:self];
    }
    
    return dialog;
}

- (void)configure:(id)value
{
    ENSURE_SINGLE_ARG(value, NSString);
    [GMSPlacesClient provideAPIKey:value];
}

- (void)open:(id)args
{
    [self rememberSelf];
    ENSURE_UI_THREAD(open, args);

    id animated = [args valueForKey:@"animated"];
    ENSURE_TYPE_OR_NIL(animated, NSNumber);
    
    [[TiApp app] showModalController:[self dialog] animated:[TiUtils boolValue:animated def:YES]];
}

- (void)setTableCellBackgroundColor:(id)value
{
    ENSURE_TYPE(value, NSString);
    [[self dialog] setTableCellBackgroundColor:[[TiUtils colorValue:value] color]];
}

- (void)setTableCellSeparatorColor:(id)value
{
    ENSURE_TYPE(value, NSString);
    [[self dialog] setTableCellSeparatorColor:[[TiUtils colorValue:value] color]];
}

- (void)setPrimaryTextColor:(id)value
{
    ENSURE_TYPE(value, NSString);
    [[self dialog] setPrimaryTextColor:[[TiUtils colorValue:value] color]];
}

- (void)setPrimaryTextHighlightColor:(id)value
{
    ENSURE_TYPE(value, NSString);
    [[self dialog] setPrimaryTextHighlightColor:[[TiUtils colorValue:value] color]];
}

- (void)setSecondaryTextColor:(id)value
{
    ENSURE_TYPE(value, NSString);
    [[self dialog] setSecondaryTextColor:[[TiUtils colorValue:value] color]];
}

- (void)setTintColor:(id)value
{
    ENSURE_TYPE(value, NSString);
    [[self dialog] setTintColor:[[TiUtils colorValue:value] color]];
}

#pragma mark - Delegates

- (void)viewController:(GMSAutocompleteViewController *)viewController didAutocompleteWithPlace:(GMSPlace *)place
{
    if ([self _hasListeners:@"success"]) {
        [self fireEvent:@"success" withObject:@{
            @"place": [TiGooglemapsAutocompleteDialogProxy dictionaryFromPlace:place]
        }];
    }
    
    [self closeDialog];
}

- (void)viewController:(GMSAutocompleteViewController *)viewController didFailAutocompleteWithError:(NSError *)error
{
    if ([self _hasListeners:@"error"]) {
        [self fireEvent:@"error" withObject:@{
            @"error": [error localizedDescription],
            @"code": NUMINTEGER([error code])
        }];
    }
    
    [self closeDialog];
}

- (void)wasCancelled:(GMSAutocompleteViewController *)viewController
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
    RELEASE_TO_NIL(dialog);
}

+ (NSDictionary*)dictionaryFromPlace:(GMSPlace*)place
{
    return @{
        @"name": [place name],
        @"placeID": [place placeID],
        @"latitude": NUMDOUBLE([place coordinate].latitude),
        @"longitude": NUMDOUBLE([place coordinate].longitude),
        @"formattedAddress": [place formattedAddress],
        @"addressComponents": [TiGooglemapsAutocompleteDialogProxy arrayFromAddressComponents:[place addressComponents]]
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
    
    return [result autorelease];
}

+ (id)dictionaryFromPrediction:(GMSAutocompletePrediction*)prediction
{
    if (prediction == nil) {
        return nil;
    }
    
    return @{
        @"attributedFullText": [[prediction attributedFullText] string],
        @"attributedPrimaryText": [[prediction attributedPrimaryText] string],
        @"attributedSecondaryText": [[prediction attributedSecondaryText] string],
        @"placeID": [prediction placeID],
        @"types": [prediction types]
    };
}

@end
