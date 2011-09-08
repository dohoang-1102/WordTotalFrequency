//
//  WordListController.h
//  WordTotalFrequency
//
//  Created by OCS on 11-7-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "Word.h"

typedef enum {
    WordListTypeWordSet         = 0,
    WordListTypeSearchResult    = 1,
    WordListTypeHistory         = 2
} WordListType;


@class WordSetController;

@protocol WordListDelegate <NSObject>

@optional
- (void) willSelectWord:(Word *)word;
- (void) didSelectWord:(Word *)word;

@end

@interface WordListController : UITableViewController<NSFetchedResultsControllerDelegate> {
}

@property (nonatomic, assign) id<WordListDelegate> delegate;
@property (nonatomic, assign) WordSetController *wordSetController;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, copy) NSString *searchString;
@property (nonatomic) NSInteger wordSetIndex;
@property (nonatomic) WordListType listType;

- (id)initWIthListType:(WordListType)listType;

@end
