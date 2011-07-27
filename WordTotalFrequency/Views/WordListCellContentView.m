//
//  WordListCellContentView.m
//  WordTotalFrequency
//
//  Created by OCS on 11-7-26.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "WordListCellContentView.h"
#import "UIColor+WTF.h"


@implementation WordListCellContentView

@synthesize wordItem = _wordItem;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    if (_wordItem.marked)
        [[UIImage imageNamed:@"mark-circle"] drawAtPoint:CGPointMake(15, 15)];
    
    _highlighted ? [[UIColor whiteColor] set] : [[UIColor colorForNormalText] set];
    [_wordItem.word drawAtPoint:CGPointMake(36, 8) withFont:[UIFont systemFontOfSize:20]];
    [_wordItem.translation drawAtPoint:CGPointMake(140, 10) withFont:[UIFont systemFontOfSize:18]];
}

- (void)setWordItem:(WordItem *)wordItem
{
    _wordItem = wordItem;
    [self setNeedsDisplay];
}

- (void)setHighlighted:(BOOL)highlighted
{
    _highlighted = highlighted;
    [self setNeedsDisplay];
}

- (BOOL)isHighlighted
{
    return _highlighted;
}


- (void)dealloc
{
    [super dealloc];
}

@end
