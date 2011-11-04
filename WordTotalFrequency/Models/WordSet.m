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
@synthesize intermediateMarkedWordCount = _intermediateMarkedWordCount;
@synthesize completeMarkedWordCount = _completeMarkedWordCount;
@synthesize description = _description;
@synthesize color = _color;
@synthesize arrowColor = _arrowColor;
@synthesize completePercentage = _completePercentage;
@synthesize iconUrl = _iconUrl;
@synthesize categoryId = _categoryId;

- (void)dealloc
{
    [_description release];
    [_color release];
    [_arrowColor release];
    [_iconUrl release];
    [super dealloc];
}

-  (NSInteger)markedWordCount
{
    return _intermediateMarkedWordCount + _completeMarkedWordCount;
}

- (NSInteger)completePercentage
{
    if (_totalWordCount <= 0)
        return 0;
    else
        return lround(_markedWordCount * 100.f / _totalWordCount);
}

@end