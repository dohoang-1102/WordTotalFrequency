//
//  WordDetailController.h
//  WordTotalFrequency
//
//  Created by OCS on 11-7-27.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "Word.h"

@interface WordDetailController : UIViewController<UIGestureRecognizerDelegate> {
    AVAudioPlayer *_player;
}

@property (nonatomic, retain) Word *word;
@property (nonatomic, retain) NSArray *words;
@property (nonatomic) NSInteger wordSetIndex;
@property (nonatomic) NSUInteger currentWordIndex;

@end
