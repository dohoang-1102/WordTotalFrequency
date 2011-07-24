//
//  CustomSearchBar.m
//  WordTotalFrequency
//
//  Created by OCS on 11-7-24.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "CustomSearchBar.h"
#import "UIColor+WTF.h"


@implementation CustomSearchBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView* segment = [self.subviews objectAtIndex:0];
        segment.alpha = 0;
    }
    return self;
}

- (void)layoutSubviews {
    UITextField *searchField;
    NSUInteger numViews = [self.subviews count];
    for(int i = 0; i < numViews; i++) {
        NSLog(@"%d - xxxx %@", i, NSStringFromClass([[self.subviews objectAtIndex:i] class]));
        if([[self.subviews objectAtIndex:i] isKindOfClass:[UITextField class]]) {
            searchField = [self.subviews objectAtIndex:i];
        }
    }
    if(!(searchField == nil)) {
        searchField.leftView.hidden = YES;
        searchField.textColor = [UIColor colorForNormalText];
        [searchField setBackground: [UIImage imageNamed:@"search-bg.png"] ];
        [searchField setBorderStyle:UITextBorderStyleNone];
    }
    
    [super layoutSubviews];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
/*
- (void)drawRect:(CGRect)rect
{
    UIImage *image = [UIImage imageNamed: @"search-bg.png"];
	[image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}
*/

- (void)dealloc
{
    [super dealloc];
}

@end
