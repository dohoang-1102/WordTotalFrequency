//
//  WordListCellContentView.h
//  WordTotalFrequency
//
//  Created by OCS on 11-7-26.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WordItem.h"

@interface WordListCellContentView : UIView {
    BOOL _highlighted;
}

@property (nonatomic, assign)WordItem *wordItem;

@end
