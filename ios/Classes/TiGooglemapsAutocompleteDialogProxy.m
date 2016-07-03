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

- (void)open:(id)args
{
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

#pragma mark GMSAutocompleteFetcherDelegate

- (void)didAutocompleteWithPredictions:(GMS_NSArrayOf(GMSAutocompletePrediction *) *)predictions
{
    if ([self _hasListeners:@"fetch:success"]) {
        NSMutableArray *output = [NSMutableArray arrayWithCapacity:[predictions count]];
        
        for (GMSAutocompletePrediction* prediction in predictions) {
            [output addObject:[self dictionaryFromPrediction:prediction]];
        }
        
        [self fireEvent:@"fetch:success" withObject:@{@"predictions": output}];
    }
}

- (void)didFailAutocompleteWithError:(NSError *)error
{
    if ([self _hasListeners:@"fetch:error"]) {
        [self fireEvent:@"fetch:error" withObject:@{
            @"error": [error localizedDescription],
            @"code": NUMINTEGER([error code])
        }];
    }
}

#pragma mark GMSAutocompleteViewControllerDelegate

- (void)viewController:(GMSAutocompleteViewController *)viewController didAutocompleteWithPlace:(GMSPlace *)place
{
    if ([self _hasListeners:@"dialog:success"]) {
        [self fireEvent:@"dialog:success" withObject:@{@"place": [self dictionaryFromPlace:place]}];
    }
}

- (void)viewController:(GMSAutocompleteViewController *)viewController didFailAutocompleteWithError:(NSError *)error
{
    if ([self _hasListeners:@"dialog:error"]) {
        [self fireEvent:@"dialog:error" withObject:@{
            @"error": [error localizedDescription],
            @"code": NUMINTEGER([error code])
        }];
    }
}

- (void)wasCancelled:(GMSAutocompleteViewController *)viewController
{
    [[self dialog] dismissViewControllerAnimated:YES completion:nil];
    
    if ([self _hasListeners:@"dialog:cancel"]) {
        [self fireEvent:@"dialog:cancel" withObject:nil];
    }
}

#pragma mark GMSAutocompleteTableDataSourceDelegate

- (void)tableDataSource:(GMSAutocompleteTableDataSource *)tableDataSource didAutocompleteWithPlace:(GMSPlace *)place
{
    if ([self _hasListeners:@"dataSource:success"]) {
        [self fireEvent:@"dataSource:success" withObject:@{@"place": [self dictionaryFromPlace:place]}];
    }
}

- (void)tableDataSource:(GMSAutocompleteTableDataSource *)tableDataSource didFailAutocompleteWithError:(NSError *)error
{
    if ([self _hasListeners:@"dataSource:error"]) {
        [self fireEvent:@"dataSource:error" withObject:@{
            @"error": [error localizedDescription],
            @"code": NUMINTEGER([error code])
        }];
    }
}

#pragma mark GMSAutocompleteResultsViewControllerDelegate

- (void)resultsController:(GMSAutocompleteResultsViewController *)resultsController didAutocompleteWithPlace:(GMSPlace *)place
{
    if ([self _hasListeners:@"results:success"]) {
        [self fireEvent:@"results:success" withObject:@{@"place": [self dictionaryFromPlace:place]}];
    }
}

- (void)resultsController:(GMSAutocompleteResultsViewController *)resultsController didFailAutocompleteWithError:(NSError *)error
{
    if ([self _hasListeners:@"results:error"]) {
        [self fireEvent:@"results:error" withObject:@{
            @"error": [error localizedDescription],
            @"code": NUMINTEGER([error code])
        }];
    }
}

#pragma mark Utilities

- (NSDictionary*)dictionaryFromPlace:(GMSPlace*)place
{
    return @{
        @"name": [place name],
        @"placeID": [place placeID],
        @"latitude": NUMDOUBLE([place coordinate].latitude),
        @"longitude": NUMDOUBLE([place coordinate].longitude),
        @"formattedAddress": [place formattedAddress]
    };
}

- (NSDictionary*)dictionaryFromPrediction:(GMSAutocompletePrediction*)prediction
{
    return @{
        @"attributedFullText": [[prediction attributedFullText] string],
        @"attributedPrimaryText": [[prediction attributedPrimaryText] string],
        @"attributedSecondaryText": [[prediction attributedSecondaryText] string],
        @"placeID": [prediction placeID],
        @"types": [prediction types]
    };
}

@end
