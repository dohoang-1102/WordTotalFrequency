//
//  WordSet.m
//  WordTotalFrequency
//
//  Created by OCS on 11-7-22.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "WordSet.h"


@implementation WordSet

@synthesize totalWordCount = _totalWordCount;
@synthesize markedWordCount = _markedWordCount;
@synthesize description = _description;
@synthesize color = _color;
@synthesize completePercentage = _completePercentage;
@synthesize iconUrl = _iconUrl;
@synthesize categoryId = _categoryId;

- (id)initWithTotal:(NSInteger)total marked:(NSInteger)marked color:(UIColor *)color
{
    if ((self = [super init]))
    {
        self.totalWordCount = total;
        self.markedWordCount= marked;
        self.color          = color;
    }
    return self;
}

- (void)dealloc
{
    [_description release];
    [_color release];
    [super dealloc];
}

- (NSInteger)completePercentage
{
    if (_totalWordCount <= 0)
        return 0;
    else
        return lround(_markedWordCount * 100.f / _totalWordCount);
}

@end