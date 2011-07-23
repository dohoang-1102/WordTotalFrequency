//
//  DashboardController.h
//  WordTotalFrequency
//
//  Created by OCS on 11-7-21.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DashboardController : UIViewController<UISearchBarDelegate>

@property (nonatomic, retain)NSArray *wordSets;
@property (nonatomic, retain)NSMutableArray *unitIcons;
@property (nonatomic)NSInteger selectedIconIndex;

@end
