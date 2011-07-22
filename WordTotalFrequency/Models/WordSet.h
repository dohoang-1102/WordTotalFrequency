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

@property (nonatomic, copy) NSString *name;
@property (nonatomic) NSInteger wordCount;
@property (nonatomic) NSInteger completePercent;
@property (nonatomic, retain)UIColor *color;

- (id)initWithName:(NSString *)name count:(NSInteger)count color:(UIColor *)color;

@end
