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
        if([[self.subviews objectAtIndex:i] isKindOfClass:[UITextField class]]) {
            searchField = [self.subviews objectAtIndex:i];
        }
    }
    if(!(searchField == nil)) {
        searchField.textColor = [UIColor colorForNormalText];
        searchField.font = [UIFont systemFontOfSize:18.f];
        [searchField setBackground: [UIImage imageNamed:@"search-bg"] ];
        [searchField setBorderStyle:UITextBorderStyleNone];
    }
    
    [super layoutSubviews];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
/*
- (void)drawRect:(CGRect)rect
{
}
*/

- (void)dealloc
{
    [super dealloc];
}

@end
