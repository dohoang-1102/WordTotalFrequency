//
//  WordTotalFrequencyAppDelegate.m
//  WordTotalFrequency
//
//  Created by OCS on 11-7-21.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "WordTotalFrequencyAppDelegate.h"
#import "DashboardController.h"
#import "Common.h"
#import "UIColor+WTF.h"
#import "Word.h"
#import "DataController.h"

@implementation WordTotalFrequencyAppDelegate


@synthesize window=_window;
@synthesize navigationController=_navigationController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    DashboardController *dc = [[DashboardController alloc] init];
    _navigationController = [[UINavigationController alloc] initWithRootViewController:dc];
    _navigationController.navigationBar.tintColor = [UIColor colorWithHex:0x3A3A65];
    [dc release];
    self.window.rootViewController = self.navigationController;
    
//    [[DataController sharedDataController] saveFromSource:@"save data free sqlite"];
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    if ([[[DataController sharedDataController] managedObjectContext] hasChanges]) {
		[[DataController sharedDataController] saveFromSource:@"application will terminate"];
	}
}

- (void)dealloc
{
    [_window release];
    [_navigationController release];
    [super dealloc];
}

@end
