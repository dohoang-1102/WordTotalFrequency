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

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat top = 10;
        
        UIImageView *bg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dashline-bg"]];
        bg.frame = CGRectMake(1, -11, 318, 35);
        [self addSubview:bg];
        [bg release];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, top-2, 80, 48)];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont boldSystemFontOfSize:40];
        label.adjustsFontSizeToFitWidth = YES;
        label.textColor = [UIColor colorForNormalText];
        label.textAlignment = UITextAlignmentRight;
        label.shadowColor = [UIColor whiteColor];
        label.shadowOffset = CGSizeMake(0, 1.5f);
        [self addSubview:label];
        [label release];
        _totalLabel = label;
        
        MTLabel *note = [[MTLabel alloc] initWithFrame:CGRectMake(85, top, 80, 60)];
        note.backgroundColor = [UIColor clearColor];
        note.font = [UIFont systemFontOfSize:12];
        note.numberOfLines = 0;
        note.text = @"words\nmarkedas\nremembered";
        [note setFontColor:[UIColor colorForNormalText]];
        [note setLineHeight:12];
        note.textAlignment = UITextAlignmentLeft;
        [self addSubview:note];
        [note release];
        
        UIImage *image = [UIImage imageNamed:@"check-mark"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = CGRectMake(150, 0, image.size.width, image.size.height);
        [self addSubview:imageView];
        [imageView release];
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(200, 22+top, 50, 20)];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:18];
        label.textColor = [UIColor colorForNormalText];
        label.text = @"Level:";
        [self addSubview:label];
        [label release];
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(250, 4+top, 80, 44)];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont boldSystemFontOfSize:34];
        label.adjustsFontSizeToFitWidth = YES;
        label.textColor = [UIColor colorForNormalText];
        label.shadowColor = [UIColor whiteColor];
        label.shadowOffset = CGSizeMake(0, 1.5f);
        [self addSubview:label];
        [label release];
        _levelLabel = label;
    }
    return self;
}

- (void)updateTotalMarkedCount:(NSUInteger)total
{
    _totalLabel.text = [NSString stringWithFormat:@"%d", total];
    
    // get level
    NSString *level = @"I";
    if (total > 12000)
        level = @"V";
    else if (total > 9000)
        level = @"IV";
    else if (total > 6000)
        level = @"III";
    else if (total > 3000)
        level = @"II";
    
    _levelLabel.text = level;
}

- (void)dealloc
{
    [super dealloc];
}

@end
