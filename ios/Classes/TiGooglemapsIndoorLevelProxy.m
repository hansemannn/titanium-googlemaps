/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2017 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiGooglemapsIndoorLevelProxy.h"

@implementation TiGooglemapsIndoorLevelProxy

- (id _Nonnull)_initWithPageContext:(id<TiEvaluator> _Nullable)context andIndoorLevel:(GMSIndoorLevel * _Nonnull)indoorLevel
{
    if (self = [super _initWithPageContext:pageContext]) {
        _indoorLevel = indoorLevel;
    }
    
    return self;
}

- (GMSIndoorLevel * _Nonnull)indoorLevel
{
    return _indoorLevel;
}

#pragma mark Public API

- (NSString * _Nullable)name
{
    return NULL_IF_NIL([_indoorLevel name]);
}

- (NSString * _Nullable)shortName
{
    return NULL_IF_NIL([_indoorLevel shortName]);
}

@end
