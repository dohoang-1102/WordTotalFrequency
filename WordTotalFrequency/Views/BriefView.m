//
//  BriefView.m
//  WordTotalFrequency
//
//  Created by OCS on 11-7-27.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "BriefView.h"
#import "UIColor+WTF.h"
#import "MTLabel.h"

@implementation BriefView

- (id)initWithFrame:(CGRect)frame count:(NSInteger)count level:(NSString *)level
{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 48)];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont boldSystemFontOfSize:40];
        label.adjustsFontSizeToFitWidth = YES;
        label.textColor = [UIColor colorForNormalText];
        label.text = [NSString stringWithFormat:@"%d", count];
        label.textAlignment = UITextAlignmentRight;
        [self addSubview:label];
        [label release];
        
        MTLabel *note = [[MTLabel alloc] initWithFrame:CGRectMake(85, 0, 80, 60)];
        note.backgroundColor = [UIColor clearColor];
        note.font = [UIFont systemFontOfSize:12];
        note.numberOfLines = 0;
        note.text = @"words\nmarkedas\nremembered";
        [note setFontColor:[UIColor colorForNormalText]];
        [note setLineHeight:12];
        note.textAlignment = UITextAlignmentLeft;
        [self addSubview:note];
        [note release];
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(200, 22, 50, 20)];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:18];
        label.textColor = [UIColor colorForNormalText];
        label.text = @"Level:";
        [self addSubview:label];
        [label release];
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(250, 4, 80, 44)];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont boldSystemFontOfSize:34];
        label.adjustsFontSizeToFitWidth = YES;
        label.textColor = [UIColor colorForNormalText];
        label.text = level;
        [self addSubview:label];
        [label release];
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
