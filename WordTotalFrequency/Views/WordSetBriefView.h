//
//  WordSetBriefView.h
//  WordTotalFrequency
//
//  Created by OCS on 11-7-23.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTLabel.h"
#import "WordSet.h"
#import "DashboardController.h"

@interface WordSetBriefView : UIView<UITableViewDelegate, UITableViewDataSource> {
    UILabel *_countlabel;
    MTLabel *_countNoteLabel;
    MTLabel *_percentLabel;
    UIProgressView *_progress;
}

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) WordSet *wordSet;
@property (nonatomic, assign) DashboardController *dashboardController;

@end
