//
//  WordSet.m
//  WordTotalFrequency
//
//  Created by OCS on 11-7-22.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "WordSet.h"


@implementation WordSet

@synthesize name = _name;
@synthesize wordCount = _wordCount;
@synthesize completePercent = _completePercent;
@synthesize color = _color;

- (id)initWithName:(NSString *)name count:(NSInteger)count color:(UIColor *)color
{
    if ((self = [super init]))
    {
        self.name           = name;
        self.wordCount      = count;
        self.completePercent= 0;
        self.color          = color;
    }
    return self;
}

- (void)dealloc
{
    [_name release];
    [_color release];
    [super dealloc];
}

@end