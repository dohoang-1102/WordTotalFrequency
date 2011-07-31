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

@synthesize word = _word;

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
    if ([_word.marked boolValue])
        [[UIImage imageNamed:@"mark-circle"] drawAtPoint:CGPointMake(15, 15)];
    
    _highlighted ? [[UIColor whiteColor] set] : [[UIColor colorForNormalText] set];
    [_word.spell drawAtPoint:CGPointMake(36, 8) withFont:[UIFont systemFontOfSize:20]];
    [_word.translate drawAtPoint:CGPointMake(140, 10) withFont:[UIFont systemFontOfSize:18]];
}

- (void)setWord:(Word *)word
{
    if (_word != word)
    {
        [_word release];
        _word = [word retain];
        [self setNeedsDisplay];
    }
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
    [_word release];
    [super dealloc];
}

@end
