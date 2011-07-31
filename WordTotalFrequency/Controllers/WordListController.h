//
//  WordListController.h
//  WordTotalFrequency
//
//  Created by OCS on 11-7-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "Word.h"

@protocol WordListDelegate <NSObject>

@optional
- (void) willSelectWord:(Word *)word;
- (void) didSelectWord:(Word *)word;

@end

@interface WordListController : UITableViewController<NSFetchedResultsControllerDelegate> {
}

@property (nonatomic, assign) id<WordListDelegate> delegate;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, copy) NSString *searchString;

@end
