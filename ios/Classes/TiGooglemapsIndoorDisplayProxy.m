/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2017 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiGooglemapsIndoorDisplayProxy.h"
#import "TiGooglemapsIndoorLevelProxy.h"

@implementation TiGooglemapsIndoorDisplayProxy

- (id)_initWithPageContext:(id<TiEvaluator>)context andIndoorDisplay:(GMSIndoorDisplay *)indoorDisplay
{
    if (self = [super _initWithPageContext:pageContext]) {
        _indoorDisplay = indoorDisplay;
        [_indoorDisplay setDelegate:self];
    }
    
    return self;
}

#pragma mark Public API

- (id)activeBuilding
{
    return [self dictionaryFromIndoorBuilding:[_indoorDisplay activeBuilding]];
}

- (id)activeLevel
{
    return [[TiGooglemapsIndoorLevelProxy alloc] _initWithPageContext:[self pageContext] andIndoorDisplay:[_indoorDisplay activeLevel]];
}

- (void)setActiveLevel:(id)activeLevel
{
    ENSURE_UI_THREAD(setActiveLevel, activeLevel);
    ENSURE_TYPE(activeLevel, TiGooglemapsIndoorLevelProxy);
    
    [_indoorDisplay setActiveLevel:[(TiGooglemapsIndoorLevelProxy *)activeLevel indoorLevel]];
}

#pragma mark GMSIndoorDisplayDelegate

- (void)didChangeActiveLevel:(GMSIndoorLevel *)level
{
    if ([self _hasListeners:@"didChangeActiveLevel"]) {
        [self fireEvent:@"didChangeActiveLevel" withObject:[[TiGooglemapsIndoorLevelProxy alloc] _initWithPageContext:[self pageContext]
                                                                                                     andIndoorDisplay:level]];
    }
}

- (void)didChangeActiveBuilding:(GMSIndoorBuilding *)building
{
    if ([self _hasListeners:@"didChangeActiveBuilding"]) {
        [self fireEvent:@"didChangeActiveBuilding" withObject:[self dictionaryFromIndoorBuilding:building]];
    }
}

#pragma mark Utilities

- (NSDictionary<NSString *, id> *)dictionaryFromIndoorBuilding:(GMSIndoorBuilding *)indoorBuilding
{
    NSMutableArray *levels = [NSMutableArray arrayWithCapacity:[[indoorBuilding levels] count]];
    
    for (GMSIndoorLevel *indoorLevel in indoorBuilding.levels) {
        [levels addObject:[[TiGooglemapsIndoorLevelProxy alloc] _initWithPageContext:[self pageContext]
                                                                    andIndoorDisplay:indoorLevel]];
    }
    
    return @{
        @"defaultLevelIndex": NUMUINTEGER([indoorBuilding defaultLevelIndex]),
        @"isUnderground": NUMBOOL([indoorBuilding isUnderground]),
        @"levels": levels
    };
}

@end
