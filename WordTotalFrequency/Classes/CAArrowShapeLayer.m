//
//  CAArrowShapeLayer.m
//  WordTotalFrequency
//
//  Created by OCS on 11-7-23.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "CAArrowShapeLayer.h"
#import "UIColor+WTF.h"


@implementation CAArrowShapeLayer

- (void)drawInContext:(CGContextRef)ctx
{
    CGGradientRef glossGradient;
    CGColorSpaceRef rgbColorspace;
    size_t num_locations = 2;
    CGFloat locations[2] = { 0.0, 1.0 };
    CGFloat components[8] = {148.0/255, 185.0/255, 209.0/255, 0.8,  // Start color
        148.0/255, 185.0/255, 209.0/255, 0}; // End color
	
    rgbColorspace = CGColorSpaceCreateDeviceRGB();
    glossGradient = CGGradientCreateWithColorComponents(rgbColorspace, components, locations, num_locations);
	
    CGRect currentBounds = self.bounds;
    CGPoint topCenter = CGPointMake(CGRectGetMidX(currentBounds), 0.0f);
    CGPoint midCenter = CGPointMake(CGRectGetMidX(currentBounds), CGRectGetMidY(currentBounds));
    

    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 9.5);
    CGPathAddLineToPoint(path, NULL, 295.5, 9.5);
    CGPathAddLineToPoint(path, NULL, 300, 0);
    CGPathAddLineToPoint(path, NULL, 304.5, 9.5);
    CGPathAddLineToPoint(path, NULL, 600, 9.5);
    CGPathAddLineToPoint(path, NULL, 600, 1000);
    CGPathAddLineToPoint(path, NULL, 0, 1000);
    CGPathCloseSubpath(path);
    
    CGContextSetLineWidth(ctx, 1.f);
    CGContextSetStrokeColorWithColor(ctx, [UIColor colorWithHex:0xed9f1e].CGColor);
    
    CGContextAddPath(ctx, path);
    CGContextDrawPath(ctx, kCGPathStroke);

    CGContextAddPath(ctx, path);
    CGContextClip(ctx);
    CGPathRelease(path);

    CGContextDrawLinearGradient(ctx, glossGradient, topCenter, midCenter, 0);
    
    CGGradientRelease(glossGradient);
    CGColorSpaceRelease(rgbColorspace);
}

- (void)dealloc
{
    [super dealloc];
}

@end
