//
//  WordListCellContentView.h
//  WordTotalFrequency
//
//  Created by OCS on 11-7-26.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Word.h"

@interface WordListCellContentView : UIView {
    BOOL _highlighted;
    CGPoint _lastHitPoint;
}

@property (nonatomic, retain) Word *word;

@end
