//
//  WordItem.m
//  WordTotalFrequency
//
//  Created by OCS on 11-7-26.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "WordItem.h"


@implementation WordItem

@synthesize word = _word;
@synthesize translation = _translation;
@synthesize marked = _marked;

- (id)initWithWord:(NSString *)word translation:(NSString *)translation marked:(BOOL)marked
{
    if ((self = [super init]))
    {
        self.word = word;
        self.translation = translation;
        self.marked = marked;
    }
    return self;
}

- (void)dealloc
{
    [_word release];
    [_translation release];
    [super dealloc];
}

@end
