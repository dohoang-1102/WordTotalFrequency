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
    
    if (tapIndex > -1)
    {
        if (tapIndex != _answerIndex)
        {
            UIView *tappedView = [self  viewWithTag:tapIndex+1];
            UIImageView *wrong = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mark-circle-wrong"]];
            wrong.center = CGPointMake(CGRectGetMinX(tappedView.frame), CGRectGetMidY(tappedView.frame));
            CGSize size = CGSizeMake(CGRectGetWidth(wrong.bounds), CGRectGetHeight(wrong.bounds));
            CGAffineTransform scaled = CGAffineTransformMakeScale(1/size.width, 1/size.height);
            wrong.transform = scaled;
            
            [UIView animateWithDuration:.2
                                  delay:0
                                options:UIViewAnimationCurveEaseInOut
                             animations:^{
                                 [self addSubview:wrong];
                                 wrong.transform = CGAffineTransformIdentity;
                             }
                             completion:^(BOOL finished){}];
            [wrong release];
        }
        
        UIView *rightView = [self  viewWithTag:_answerIndex+1];
        UIImageView *right = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mark-circle-right"]];
        right.center = CGPointMake(CGRectGetMinX(rightView.frame), CGRectGetMidY(rightView.frame));
        CGSize size = CGSizeMake(CGRectGetWidth(right.bounds), CGRectGetHeight(right.bounds));
        CGAffineTransform scaled = CGAffineTransformMakeScale(1/size.width, 1/size.height);
        right.transform = scaled;
        
        [UIView animateWithDuration:.2
                              delay:(tapIndex != _answerIndex ? .2 : 0)
                            options:UIViewAnimationCurveEaseInOut
                         animations:^{
                             [self addSubview:right];
                             right.transform = CGAffineTransformIdentity;
                         }
                         completion:^(BOOL finished){}];
        [right release];
        
        [self removeGestureRecognizer:gestureRecognizer];
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
