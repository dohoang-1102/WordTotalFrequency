//
//  UIColor+WTF.m
//  WordTotalFrequency
//
//  Created by OCS on 11-7-22.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "UIColor+WTF.h"


@implementation UIColor (WTF)

+ (UIColor *)colorWithHex:(NSUInteger)color
{
    return [UIColor colorWithHex:color alpha:1];
}

+ (UIColor *)colorWithHex:(NSUInteger)color alpha:(CGFloat)alpha
{
    unsigned char r, g, b;
    b = color & 0xFF;
    g = (color >> 8) & 0xFF;
    r = (color >> 16) & 0xFF;
    return [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:alpha];
}

+ (UIColor *)colorForNormalText
{
    return [UIColor colorWithHex:0x45738e];
}

@end
