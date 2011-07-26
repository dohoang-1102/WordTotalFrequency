//
//  WordSetBriefView.h
//  WordTotalFrequency
//
//  Created by OCS on 11-7-23.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "MTLabel.h"
#import "WordSet.h"
#import "DashboardController.h"
#import "CAArrowShapeLayer.h"
#import "OCProgress.h"

@interface WordSetBriefView : UIView<UITableViewDelegate, UITableViewDataSource> {
    UILabel *_countlabel;
    MTLabel *_countNoteLabel;
    MTLabel *_percentLabel;
    OCProgress *_progress;
    CAArrowShapeLayer *_arrowLayer;
}

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) WordSet *wordSet;
@property (nonatomic, assign) DashboardController *dashboardController;

- (void)centerArrowToX:(CGFloat)x;

@end
