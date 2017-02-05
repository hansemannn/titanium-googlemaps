/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2017 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiGooglemapsTileProxy.h"
#import "TiUtils.h"

@implementation TiGooglemapsTileProxy

- (GMSURLTileLayer *)tile
{
    if (_tile == nil) {
        _tile = [GMSURLTileLayer tileLayerWithURLConstructor:^NSURL* (NSUInteger x, NSUInteger y, NSUInteger zoom) {
            NSString *template = [TiUtils stringValue:[self valueForKey:@"url"]];
            
            template = [template stringByReplacingOccurrencesOfString:@"{x}" withString:[NSString stringWithFormat: @"%lu", x]];
            template = [template stringByReplacingOccurrencesOfString:@"{y}" withString:[NSString stringWithFormat: @"%lu", y]];
            template = [template stringByReplacingOccurrencesOfString:@"{z}" withString:[NSString stringWithFormat: @"%lu", zoom]];

            return [NSURL URLWithString:template];
        }];
    }
    
    return _tile;
}

#pragma mark Public API

- (void)setZIndex:(id)value
{
    ENSURE_TYPE(value, NSNumber);
    
    [[self tile] setZIndex:[TiUtils intValue:value]];
    [self replaceValue:value forKey:@"zIndex" notification:NO];
}

- (void)setOpacity:(id)value
{
    ENSURE_TYPE(value, NSNumber);
    
    [[self tile] setOpacity:[TiUtils floatValue:value]];
    [self replaceValue:value forKey:@"opacity" notification:NO];
}

- (void)setFadeIn:(id)value
{
    ENSURE_TYPE(value, NSNumber);
    
    [[self tile] setFadeIn:[TiUtils boolValue:value]];
    [self replaceValue:value forKey:@"fadeIn" notification:NO];
}

- (void)setSize:(id)value
{
    ENSURE_TYPE(value, NSNumber);
    
    [[self tile] setTileSize:[TiUtils intValue:value]];
    [self replaceValue:value forKey:@"size" notification:NO];
}

- (void)setUserAgent:(id)value
{
    ENSURE_TYPE(value, NSString);
    
    [[self tile] setUserAgent:[TiUtils stringValue:value]];
    [self replaceValue:value forKey:@"userAgent" notification:NO];
}

- (void)clearTileCache:(id)unused
{
    [[self tile] clearTileCache];
}

@end
