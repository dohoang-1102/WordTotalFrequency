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

- (id)initWithFrame:(CGRect)frame word:(NSString *)word options:(NSArray *)options answer:(NSUInteger)answer footer:(NSString *)footer
{
    self = [super initWithFrame:frame];
    if (self) {
        _answerIndex = answer;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, CGRectGetWidth(frame)-30, 30)];
        label.font = [UIFont systemFontOfSize:28];
        label.text = word;
        label.textColor = [UIColor colorForNormalText];
        [self addSubview:label];
        [label release];
        
        UILabel *option;
        int y = 60;
        for (int i=0; i<[options count]; i++) {
            option = [[UILabel alloc] initWithFrame:CGRectMake(30, y, CGRectGetWidth(frame)-30, 30)];
            option.tag = i;
            option.textColor = [UIColor colorForNormalText];
            option.text = [NSString stringWithFormat:@"%d %@", (i+1), [options objectAtIndex:i]];
            [self addSubview:option];
            [option release];
            
            y += 40;
        }
        
        UILabel *footerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(frame)-20, CGRectGetWidth(frame)-5, 20)];
        footerLabel.textColor = [UIColor grayColor];
        footerLabel.font = [UIFont systemFontOfSize:14];
        footerLabel.text = footer;
        footerLabel.textAlignment = UITextAlignmentRight;
        [self addSubview:footerLabel];
        [footerLabel release];
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
