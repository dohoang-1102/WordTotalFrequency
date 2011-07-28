//
//  WordListController.h
//  WordTotalFrequency
//
//  Created by OCS on 11-7-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WordItem.h"

@protocol WordListDelegate <NSObject>

@optional
- (void) willSelectWord:(WordItem *)word;
- (void) didSelectWord:(WordItem *)word;

@end

@interface WordListController : UITableViewController {
    
}

@property (nonatomic, retain) NSArray *words;
@property (nonatomic, assign) id<WordListDelegate> delegate;

@end
