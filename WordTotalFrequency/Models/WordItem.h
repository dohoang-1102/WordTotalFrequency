//
//  WordItem.h
//  WordTotalFrequency
//
//  Created by OCS on 11-7-26.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface WordItem : NSObject {
    
}

@property (copy) NSString *word;
@property (copy) NSString *translation;
@property BOOL marked;

- (id)initWithWord:(NSString *)word translation:(NSString *)translation marked:(BOOL)marked;

@end
