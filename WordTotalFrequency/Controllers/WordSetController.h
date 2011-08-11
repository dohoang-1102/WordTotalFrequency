//
//  WordSetController.h
//  WordTotalFrequency
//
//  Created by OCS on 11-7-22.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WordListController.h"
#import "WordSet.h"

@class WordListController;

@interface WordSetController : UIViewController {
    WordListController *_listController;
}

@property (nonatomic, retain) WordSet *wordSet;

- (void)updateMarkedCount;

@end
