//
//  WordDetailView.h
//  WordTotalFrequency
//
//  Created by Perry on 11-8-12.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "Word.h"
#import "WordDetailController.h"

@interface WordDetailView : UIView {
    AVAudioPlayer *_player;
}

@property (nonatomic, retain) Word *word;
@property (nonatomic, assign) WordDetailController *wordDetailController;

- (void)updateWordData;

@end
