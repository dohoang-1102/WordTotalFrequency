//
//  WordPaperView.h
//  WordTotalFrequency
//
//  Created by Perry on 11-8-16.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "Word.h"

@class WordTestView;

@interface WordPaperView : UIView {
    NSUInteger _answerIndex;
    WordTestView *_wordTestView;
}

- (id)initWithFrame:(CGRect)frame word:(NSString *)word options:(NSArray *)options answer:(NSUInteger)answer footer:(NSString *)footer testView:(WordTestView *)testView;

@end
