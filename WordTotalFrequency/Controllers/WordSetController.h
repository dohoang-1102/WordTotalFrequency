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
#import "WordTestView.h"
#import "CustomSegmentedControl.h"

@class WordListController;

@interface WordSetController : UIViewController<CustomSegmentedControlDelegate> {
    WordListController *_listController;
    WordTestView *_wordTestView;
    CustomSegmentedControl *_segmentedControl;
}

@property (nonatomic, retain) UIView *viewContainer;
@property (nonatomic, retain) WordSet *wordSet;
@property (nonatomic, retain) NSArray *testWords;
@property (nonatomic) NSUInteger currentTestWordIndex;

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSFetchRequest *fetchRequest;

- (void)updateMarkedCount;

@end
