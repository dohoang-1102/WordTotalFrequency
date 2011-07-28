//
//  DashboardController.h
//  WordTotalFrequency
//
//  Created by OCS on 11-7-21.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomSearchBar.h"
#import "WordListController.h"
#import "BriefView.h"

@class WordSetBriefView;

@interface DashboardController : UIViewController<UISearchBarDelegate, WordListDelegate>
{
    NSInteger _selectedIconIndex;
}

@property (nonatomic, retain) NSMutableArray *wordSets;
@property (nonatomic, retain) NSMutableArray *unitIcons;
@property (readwrite) NSInteger selectedIconIndex;
@property (nonatomic, retain) CustomSearchBar *searchBar;
@property (nonatomic, retain) WordListController *listController;

@property (nonatomic, retain) BriefView *briefView;
@property (nonatomic, retain) WordSetBriefView *wordSetBrief;

@end
