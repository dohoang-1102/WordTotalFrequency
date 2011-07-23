//
//  DashboardController.h
//  WordTotalFrequency
//
//  Created by OCS on 11-7-21.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WordSetBriefView;

@interface DashboardController : UIViewController<UISearchBarDelegate>

@property (nonatomic, retain)NSMutableArray *wordSets;
@property (nonatomic, retain)NSMutableArray *unitIcons;
@property (nonatomic)NSInteger selectedIconIndex;

@property (nonatomic, retain)WordSetBriefView *wordSetBrief;

@end
