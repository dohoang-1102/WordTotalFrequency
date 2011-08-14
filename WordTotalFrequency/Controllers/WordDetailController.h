//
//  WordDetailController.h
//  WordTotalFrequency
//
//  Created by OCS on 11-7-27.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Word.h"
#import "WordListController.h"

@interface WordDetailController : UIViewController<UIGestureRecognizerDelegate> {
}

@property (nonatomic, retain) Word *word;
@property (nonatomic, retain) NSArray *words;
@property (nonatomic) NSInteger wordSetIndex;
@property (nonatomic) NSUInteger currentWordIndex;
@property (nonatomic, assign) WordListController *wordListController;

@end
