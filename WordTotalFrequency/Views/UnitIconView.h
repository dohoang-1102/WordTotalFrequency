//
//  UnitIconView.h
//  WordTotalFrequency
//
//  Created by OCS on 11-7-23.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "DashboardController.h"

@interface UnitIconView : UIView {
    CGFloat _currentArc;
    CGFloat _percentArc;
    BOOL _isSelected;
}

@property (nonatomic, retain) CALayer *imageLayer;
@property (nonatomic, retain) CAShapeLayer *circleLayer;
@property (nonatomic, retain) CAShapeLayer *percentLayer;
@property (nonatomic, assign) DashboardController *dashboard;
@property (nonatomic) NSInteger percent;

- (id)initWithFrame:(CGRect)frame image:(NSString *)image percent:(NSInteger)percent;
- (void)toggleDisplayState:(UnitIconView *)iconView affectDashboard:(BOOL)affect;

@end
