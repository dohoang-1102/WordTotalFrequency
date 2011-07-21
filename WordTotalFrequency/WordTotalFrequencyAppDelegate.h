//
//  WordTotalFrequencyAppDelegate.h
//  WordTotalFrequency
//
//  Created by OCS on 11-7-21.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WordTotalFrequencyViewController;

@interface WordTotalFrequencyAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet WordTotalFrequencyViewController *viewController;

@end
