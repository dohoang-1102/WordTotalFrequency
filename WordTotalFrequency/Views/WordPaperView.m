//
//  WordPaperView.m
//  WordTotalFrequency
//
//  Created by Perry on 11-8-16.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "WordPaperView.h"
#import "UIColor+WTF.h"

@implementation WordPaperView

- (void)choiceTapped:(UIGestureRecognizer *)gestureRecognizer
{
    CGPoint point = [gestureRecognizer locationInView:self];
    int tapIndex = -1;
    for (int i=0; i<4; i++)
    {
        UILabel *label = (UILabel *)[self viewWithTag:i+1];
        if (CGRectContainsPoint(label.frame, point))
        {
            tapIndex = i;
            break;
        }
    }
}

- (id)initWithFrame:(CGRect)frame word:(NSString *)word options:(NSArray *)options answer:(NSUInteger)answer footer:(NSString *)footer
{
    self = [super initWithFrame:frame];
    if (self) {
        _answerIndex = answer;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, CGRectGetWidth(frame)-30, 30)];
        label.font = [UIFont boldSystemFontOfSize:28];
        label.text = word;
        label.textColor = [UIColor colorForNormalText];
        [self addSubview:label];
        [label release];
        
        UILabel *option;
        int y = 77;
        for (int i=0; i<[options count]; i++) {
            option = [[UILabel alloc] initWithFrame:CGRectMake(20, y, CGRectGetWidth(frame)-20, 30)];
            option.tag = i+1;
            option.font = [UIFont systemFontOfSize:18];
            option.textColor = [UIColor colorForNormalText];
            option.text = [NSString stringWithFormat:@"%d   %@", (i+1), [options objectAtIndex:i]];
            option.adjustsFontSizeToFitWidth = YES;
            [self addSubview:option];
            [option release];
            
            y += 50;
        }
        
        UILabel *footerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(frame)-20, CGRectGetWidth(frame)-5, 20)];
        footerLabel.textColor = [UIColor grayColor];
        footerLabel.font = [UIFont systemFontOfSize:14];
        footerLabel.text = footer;
        footerLabel.textAlignment = UITextAlignmentRight;
        [self addSubview:footerLabel];
        [footerLabel release];
        
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]
                                           initWithTarget:self action:@selector(choiceTapped:)];
        [self addGestureRecognizer:gesture];
        [gesture release];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc
{
    [super dealloc];
}

@end
