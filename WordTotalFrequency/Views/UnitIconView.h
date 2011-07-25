//
//  UnitIconView.h
//  WordTotalFrequency
//
//  Created by OCS on 11-7-23.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "DashboardController.h"
#import "WordSet.h"

@interface UnitIconView : UIView {
    CGFloat _currentArc;
    CGFloat _percentArc;
    BOOL _isSelected;
}

@property (nonatomic, retain) CALayer *imageLayer;
@property (nonatomic, retain) CAShapeLayer *circleLayer;
@property (nonatomic, retain) CAShapeLayer *percentLayer;
@property (nonatomic, assign) DashboardController *dashboard;
@property (nonatomic, assign) WordSet *wordSet;

- (id)initWithFrame:(CGRect)frame image:(NSString *)image;
- (void)toggleDisplayState:(UnitIconView *)iconView affectDashboard:(BOOL)affect;
- (void)addCADisplayLink;

@end
