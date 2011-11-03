//
//  SettingView.h
//  WordTotalFrequency
//
//  Created by Perry on 11-10-16.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WordSetController;

@interface SettingsView : UIView<UIAlertViewDelegate> {
}

@property (nonatomic, assign) WordSetController *wordSetController;

@end
