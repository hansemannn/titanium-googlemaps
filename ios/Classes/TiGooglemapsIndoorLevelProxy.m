/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2017 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiGooglemapsIndoorLevelProxy.h"

@implementation TiGooglemapsIndoorLevelProxy

- (id)_initWithPageContext:(id<TiEvaluator>)context andIndoorDisplay:(GMSIndoorLevel *)indoorLevel
{
    if (self = [super _initWithPageContext:pageContext]) {
        _indoorLevel = indoorLevel;
    }
    
    return self;
}

- (GMSIndoorLevel *)indoorLevel
{
    return _indoorLevel;
}

#pragma mark Public API

- (NSString *)name
{
    return NULL_IF_NIL([_indoorLevel name]);
}

- (NSString *)shortName
{
    return NULL_IF_NIL([_indoorLevel shortName]);
}

@end
