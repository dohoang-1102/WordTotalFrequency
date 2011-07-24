//
//  UnitIconView.m
//  WordTotalFrequency
//
//  Created by OCS on 11-7-23.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "UnitIconView.h"
#import "UIColor+WTF.h"

@implementation UnitIconView

@synthesize imageLayer = _imagelayer;
@synthesize circleLayer = _circleLayer;
@synthesize percentLayer = _percentLayer;
@synthesize percent = _percent;
@synthesize dashboard = _dashboard;
@synthesize color = _color;

- (id)initWithFrame:(CGRect)frame image:(NSString *)image percent:(NSInteger)percent color:(UIColor *)color
{
    self = [super initWithFrame:frame];
    if (self) {
        self.color = color;
        
        _percent = percent;
        _percentArc = percent * 2 * M_PI / 100.f;
        
        CGRect rect = CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame));
        
        _circleLayer = [[CAShapeLayer alloc] init];
        _circleLayer.bounds = rect;
        _circleLayer.position = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
        _circleLayer.strokeColor = [UIColor colorWithHex:0xb3d7ef].CGColor;
        _circleLayer.fillColor = [UIColor clearColor].CGColor;
        _circleLayer.lineWidth = 4.f;
        CGMutablePathRef thePath = CGPathCreateMutable();
        CGPathAddArc(thePath,
                     NULL,
                     CGRectGetMidX(rect),
                     CGRectGetMidY(rect),
                     CGRectGetWidth(rect)/2.0,
                     0,
                     2*M_PI,
                     NO);
        _circleLayer.path = thePath;
        CGPathRelease(thePath);
        [self.layer addSublayer:_circleLayer];
        
        _percentLayer = [[CAShapeLayer alloc] init];
        _percentLayer.bounds = rect;
        _percentLayer.position = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
        _percentLayer.strokeColor = [UIColor colorWithHex:0x45738e].CGColor;
        _percentLayer.fillColor = [UIColor clearColor].CGColor;
        _percentLayer.lineWidth = 4.f;
        [self.layer addSublayer:_percentLayer];
        
        _imagelayer = [[CALayer alloc] init];
        _imagelayer.frame = CGRectInset(rect, 2, 2);
        _imagelayer.contents = (id)[UIImage imageNamed:image].CGImage;
        [self.layer addSublayer:_imagelayer];
        
        // CADisplayLink
        CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updatePath:)];
        [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        
        // Tap Gesture
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]
                                           initWithTarget:self action:@selector(iconTapped:)];
        [self addGestureRecognizer:gesture];
        [gesture release];
    }
    return self;
}

- (void)drawPathWithArc:(CGFloat)arc {
    CGMutablePathRef thePath = CGPathCreateMutable();
    CGPathAddArc(thePath,
                 NULL,
                 CGRectGetMidX(self.bounds),
                 CGRectGetMidY(self.bounds),
                 CGRectGetWidth(self.bounds)/2.0,
                 -M_PI/2,
                 arc,
                 NO);
    _percentLayer.path = thePath;
    CGPathRelease(thePath);
}

- (void)updatePath:(CADisplayLink *)displayLink {
    _currentArc = fminf(_currentArc + 0.2f, _percentArc-M_PI/2);
    [self drawPathWithArc:_currentArc];
    if(_currentArc >= _percentArc-M_PI/2) {
        [displayLink invalidate];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc
{
    [_imagelayer release];
    [_circleLayer release];
    [_percentLayer release];
    [_color release];
    [super dealloc];
}
                                           
- (void)iconTapped:(UIGestureRecognizer *)gestureRecognizer
{
    if (!_isSelected)
        [self toggleDisplayState:self affectDashboard:YES];
}

- (void)toggleDisplayState:(UnitIconView *)iconView affectDashboard:(BOOL)affect
{
    // toggle previous selected
    if (_dashboard.selectedIconIndex > -1 && affect)
    {
        UnitIconView *icon = [_dashboard.unitIcons objectAtIndex:_dashboard.selectedIconIndex];
        [icon toggleDisplayState:icon affectDashboard:NO];
    }
    
    // toggle self
    if (_isSelected)
    {
        _imagelayer.transform = CATransform3DIdentity;
    }
    else
    {
        CATransform3D currentTransform = _imagelayer.transform;
        CATransform3D scaled = CATransform3DScale(currentTransform, 1.43, 1.43, 1.43);
        _imagelayer.transform = scaled;
        
        // set selectedIconIndex
        if (affect)
        {
            for (int i=0; i<[_dashboard.unitIcons count]; i++) {
                UnitIconView *view = [_dashboard.unitIcons objectAtIndex:i];
                if (view == self)
                {
                    _dashboard.selectedIconIndex = i;
                    break;
                }
            }
        }
    }
    _isSelected = !_isSelected;
}
@end
