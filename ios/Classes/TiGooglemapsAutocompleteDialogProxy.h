/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2016 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */
#import "TiProxy.h"
#import <GoogleMaps/GoogleMaps.h>

@interface TiGooglemapsAutocompleteDialogProxy : TiProxy<GMSAutocompleteViewControllerDelegate, GMSAutocompleteFetcherDelegate, GMSAutocompleteTableDataSourceDelegate, GMSAutocompleteResultsViewControllerDelegate> {
    GMSAutocompleteViewController *dialog;
}

- (void)open:(id)args;

- (void)setTableCellBackgroundColor:(id)value;

- (void)setTableCellSeparatorColor:(id)value;

- (void)setPrimaryTextColor:(id)value;

- (void)setPrimaryTextHighlightColor:(id)value;

- (void)setSecondaryTextColor:(id)value;

- (void)setTintColor:(id)value;

@end
