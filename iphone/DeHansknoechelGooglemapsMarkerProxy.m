/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2015 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "DeHansknoechelGooglemapsMarkerProxy.h"
#import "TiUtils.h"

@implementation DeHansknoechelGooglemapsMarkerProxy

-(void)_initWithProperties:(NSDictionary *)properties
{
    ENSURE_UI_THREAD_1_ARG(properties);
    marker = [[[GMSMarker alloc] init] retain];
    
    [marker setPosition:CLLocationCoordinate2DMake([TiUtils doubleValue:[properties objectForKey:@"latitude"]],[TiUtils doubleValue:[properties valueForKey:@"longitude"]])];
    
    [marker setTitle:[TiUtils stringValue:[properties objectForKey:@"title"]]];
    [marker setSnippet:[TiUtils stringValue:[properties objectForKey:@"snippet"]]];
    
    [super _initWithProperties:properties];
}

-(GMSMarker*)marker
{
    return marker;
}

-(void)dealloc
{
    [super dealloc];
}

@end
