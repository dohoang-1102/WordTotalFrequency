//
//  DashboardController.h
//  WordTotalFrequency
//
//  Created by OCS on 11-7-21.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DashboardController : UIViewController<UITableViewDataSource, UITableViewDelegate> {
    
}

@property (nonatomic, retain)NSArray *wordSets;
@property (nonatomic, retain)UITableView *tableView;

@end
