/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2015 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"
#import "TiGooglemapsModule.h"
#import "TiGooglemapsMapViewProxy.h"
#import <GoogleMaps/GoogleMaps.h>

@implementation TiGooglemapsModule

#pragma mark Internal

-(id)moduleGUID
{
	return @"81fe0326-e874-4843-b902-51bbd46f9283";
}

-(NSString*)moduleId
{
	return @"de.hansknoechel.googlemaps";
}

#pragma mark Lifecycle

-(void)startup
{
	[super startup];

	NSLog(@"[INFO] %@ loaded",self);
}

-(void)shutdown:(id)sender
{
	[super shutdown:sender];
}

#pragma mark Cleanup

-(void)dealloc
{
	[super dealloc];
}

#pragma mark Internal Memory Management

-(void)didReceiveMemoryWarning:(NSNotification*)notification
{
	// optionally release any resources that can be dynamically
	// reloaded once memory is available - such as caches
	[super didReceiveMemoryWarning:notification];
}

#pragma mark Listener Notifications

-(void)_listenerAdded:(NSString *)type count:(int)count
{
	if (count == 1 && [type isEqualToString:@"my_event"])
	{
		// the first (of potentially many) listener is being added
		// for event named 'my_event'
	}
}

-(void)_listenerRemoved:(NSString *)type count:(int)count
{
	if (count == 0 && [type isEqualToString:@"my_event"])
	{
		// the last listener called for event named 'my_event' has
		// been removed, we can optionally clean up any resources
		// since no body is listening at this point for that event
	}
}

#pragma Public APIs

-(void)setAPIKey:(id)value
{
    [GMSServices provideAPIKey:[TiUtils stringValue:value]];
}

-(NSString*)version
{
    return [TiUtils stringValue:[GMSServices version]];
}

MAKE_SYSTEM_PROP(MAP_TYPE_HYBRID, kGMSTypeHybrid);
MAKE_SYSTEM_PROP(MAP_TYPE_NONE, kGMSTypeNone);
MAKE_SYSTEM_PROP(MAP_TYPE_NORMAL, kGMSTypeNormal);
MAKE_SYSTEM_PROP(MAP_TYPE_SATTELITE, kGMSTypeSatellite);
MAKE_SYSTEM_PROP(MAP_TYPE_TERRAIN, kGMSTypeTerrain);

@end
