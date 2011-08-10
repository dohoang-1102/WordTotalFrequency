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

static NSUInteger const kWordWrapperTag = 1;
static NSUInteger const kMarkIconTag = 2;
static NSUInteger const kSpellLabelTag = 3;
static NSUInteger const kTranslateLabelTag = 4;

- (void)markAction:(UIGestureRecognizer *)gestureRecognizer
{
    NSLog(@"XXYYZZ");
    BOOL marked = [_word.marked boolValue];
    _word.marked = [NSNumber numberWithBool:!marked];
    
    [self setNeedsDisplay];
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.opaque = NO;
        
//        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(markAction:)];
//        [self addGestureRecognizer:tapGesture];
//        [tapGesture release];

//        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 140, CGRectGetHeight(frame))];
//        [self addSubview:view];
//        [view release];
//        
//        UIView *subview = [[UIView alloc] initWithFrame:CGRectMake(15, 0, 125, CGRectGetHeight(frame))];
//        subview.tag = kWordWrapperTag;
//        [self addSubview:subview];
//        
//        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(markAction:)];
//        [subview addGestureRecognizer:tapGesture];
//        [tapGesture release];
//        
//        UIImageView *mark = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mark-circle-gray"]];
//        mark.frame = CGRectMake(0, 15, mark.image.size.width, mark.image.size.height);
//        mark.tag = kMarkIconTag;
//        [subview addSubview:mark];
//        [mark release];
//        
//        UILabel *spell = [[UILabel alloc] initWithFrame:CGRectMake(21, 0, 100, CGRectGetHeight(frame))];
//        spell.backgroundColor = [UIColor clearColor];
//        spell.tag = kSpellLabelTag;
//        spell.userInteractionEnabled = NO;
//        [subview addSubview:spell];
//        [spell release];
//        
//        [subview release];
//        
//        UILabel *translate = [[UILabel alloc] initWithFrame:CGRectMake(140, 0, CGRectGetWidth(frame)-140, CGRectGetHeight(frame))];
//        translate.backgroundColor = [UIColor clearColor];
//        translate.tag = kTranslateLabelTag;
//        [self addSubview:translate];
//        [translate release];
    }
    return self;
}

- (void)updateWordDisplay
{
    if ([_word.marked boolValue])
        [(UIImageView *)[self viewWithTag:kMarkIconTag] setImage:nil];
    else
        [(UIImageView *)[self viewWithTag:kMarkIconTag] setImage:[UIImage imageNamed:@"mark-circle-gray"]];
    
    [(UILabel *)[self viewWithTag:kSpellLabelTag] setText:_word.spell];
    [(UILabel *)[self viewWithTag:kTranslateLabelTag] setText:_word.translate];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    if ([_word.marked boolValue])
        [[UIImage imageNamed:@"mark-circle"] drawAtPoint:CGPointMake(15, 15)];
    
    _highlighted ? [[UIColor whiteColor] set] : [[UIColor colorForNormalText] set];
    [_word.spell drawAtPoint:CGPointMake(36, 8)
                    forWidth:100
                    withFont:[UIFont systemFontOfSize:20]
                 minFontSize:12
              actualFontSize:nil
               lineBreakMode:UILineBreakModeCharacterWrap
          baselineAdjustment:UIBaselineAdjustmentAlignCenters];
//    [_word.spell drawAtPoint:CGPointMake(36, 8) withFont:[UIFont systemFontOfSize:20]];
    [_word.translate drawAtPoint:CGPointMake(140, 10) withFont:[UIFont systemFontOfSize:18]];
}

- (void)setWord:(Word *)word
{
    if (_word != word)
    {
        [_word release];
        _word = [word retain];
//        [self updateWordDisplay];
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGSize size = [_word.spell sizeWithFont:[UIFont systemFontOfSize:20] constrainedToSize:CGSizeMake(100, 50)];
    CGRect rect = CGRectMake(15, 4, 21+size.width, CGRectGetHeight(self.bounds)-8);
    if (CGRectContainsPoint(rect, _lastHitPoint))
    {
        BOOL marked = [_word.marked boolValue];
        _word.marked = [NSNumber numberWithBool:!marked];
        
        [self setNeedsDisplay];
    }
    else
    {
        [self.nextResponder touchesBegan:touches withEvent:event];
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    _lastHitPoint = point;
    return [super hitTest:point withEvent:event];
}

@end
