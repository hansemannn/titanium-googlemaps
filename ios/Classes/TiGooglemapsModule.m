/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-Present by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"
#import "TiGooglemapsModule.h"
#import <GoogleMaps/GoogleMaps.h>

@implementation TiGooglemapsModule

#pragma mark Internal

-(id)moduleGUID
{
	return @"81fe0326-e874-4843-b902-51bbd46f9283";
}

-(NSString*)moduleId
{
	return @"ti.googlemaps";
}

#pragma mark Lifecycle

-(void)startup
{
	[super startup];

	NSLog(@"[INFO] %@ loaded",self);
}

#pragma Public APIs

-(void)setAPIKey:(id)value
{
    [GMSServices provideAPIKey:[TiUtils stringValue:value]];
}

-(NSNumber *)version
{
    return NUMINTEGER([GMSServices version]);
}

#pragma mark Constants

MAKE_SYSTEM_PROP(MAP_TYPE_HYBRID, kGMSTypeHybrid);
MAKE_SYSTEM_PROP(MAP_TYPE_NONE, kGMSTypeNone);
MAKE_SYSTEM_PROP(MAP_TYPE_NORMAL, kGMSTypeNormal);
MAKE_SYSTEM_PROP(MAP_TYPE_SATTELITE, kGMSTypeSatellite);
MAKE_SYSTEM_PROP(MAP_TYPE_TERRAIN, kGMSTypeTerrain);

MAKE_SYSTEM_PROP(APPEAR_ANIMATION_NONE, kGMSMarkerAnimationNone);
MAKE_SYSTEM_PROP(APPEAR_ANIMATION_POP, kGMSMarkerAnimationPop);

@end
