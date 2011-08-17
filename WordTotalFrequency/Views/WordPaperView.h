//
//  WordPaperView.h
//  WordTotalFrequency
//
//  Created by Perry on 11-8-16.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "Word.h"

@interface WordPaperView : UIView {
    NSUInteger _answerIndex;
}

- (id)initWithFrame:(CGRect)frame word:(NSString *)word options:(NSArray *)options answer:(NSUInteger)answer footer:(NSString *)footer;

@end
