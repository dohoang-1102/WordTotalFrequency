//
//  WordListCellTranslateView.m
//  WordTotalFrequency
//
//  Created by Perry on 11-9-4.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "WordListCellTranslateView.h"
#import "UIColor+WTF.h"

@implementation WordListCellTranslateView

@synthesize translate = _translate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [[UIColor whiteColor] set];
    [_translate drawAtPoint:CGPointMake(.5, 11) withFont:[UIFont systemFontOfSize:18]];
    [[UIColor colorForNormalText] set];
    [_translate drawAtPoint:CGPointMake(0, 10) withFont:[UIFont systemFontOfSize:18]];
}

- (void)dealloc
{
    [_translate release];
    [super dealloc];
}

- (void)setTranslate:(NSString *)translate
{
    if (_translate != translate)
    {
        [_translate release];
        _translate = [translate retain];
        [self setNeedsDisplay];
    }
}

@end
