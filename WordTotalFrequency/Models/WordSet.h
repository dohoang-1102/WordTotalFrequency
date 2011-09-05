//
//  WordSet.h
//  WordTotalFrequency
//
//  Created by OCS on 11-7-22.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface WordSet : NSObject {
    
}

@property (nonatomic) NSInteger totalWordCount;
@property (nonatomic) NSInteger markedWordCount;
@property (nonatomic, copy) NSString *description;
@property (nonatomic, retain) UIColor *color;
@property (nonatomic, retain) UIColor *arrowColor;
@property (nonatomic, readonly) NSInteger completePercentage;
@property (nonatomic, copy) NSString *iconUrl;
@property (nonatomic) NSInteger categoryId;

- (id)initWithTotal:(NSInteger)total marked:(NSInteger)marked color:(UIColor *)color;

@end
