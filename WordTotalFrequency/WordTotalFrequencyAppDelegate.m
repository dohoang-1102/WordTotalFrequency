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
#import <sqlite3.h>

@implementation WordTotalFrequencyAppDelegate


@synthesize window=_window;

@synthesize navigationController=_navigationController;

#define DB_NAME @"MySql.sqlite"

sqlite3 *database;

- (BOOL)initDatabase {
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSString *defaultDBPath;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:DB_NAME];
    
    NSLog(@"==== DB: %@ ====", writableDBPath);
    
    if (![fileManager fileExistsAtPath:writableDBPath]){
		// The writable database does not exist, so copy the default to the appropriate location.
		defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:DB_NAME];
		success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
		if (!success) {
			NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
			return NO;
		}
	}
	
	//Open the database
	if (sqlite3_open([writableDBPath UTF8String], &database) == SQLITE_OK) {
		NSLog(@"Database initialized");
	} else {
		// Even though the open failed, call close to properly clean up resources.
		sqlite3_close(database);
		database = NULL;
		return NO;
	}
	return YES;
}

- (void)syncData
{
    const char *sql = "SELECT spell, phonetic, soundFile, translate, tags, detail, category FROM word";
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            Word *word = [NSEntityDescription insertNewObjectForEntityForName:@"Word" inManagedObjectContext:[self managedObjectContext]];
            [word setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)] forKey:@"spell"];
            [word setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)] forKey:@"phonetic"];
            [word setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)] forKey:@"soundFile"];
            [word setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)] forKey:@"translate"];
//            [word setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)] forKey:@"tags"];
            [word setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)] forKey:@"detail"];
            [word setValue:[NSNumber numberWithInt:sqlite3_column_int(statement, 6)] forKey:@"category"];
            [word setValue:[NSNumber numberWithBool:NO] forKey:@"marked"];
            [self saveAction];
        }
    }
    sqlite3_finalize(statement);
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    DashboardController *dc = [[DashboardController alloc] init];
    _navigationController = [[UINavigationController alloc] initWithRootViewController:dc];
    _navigationController.navigationBar.tintColor = [UIColor colorWithHex:0x3A3A65];
    [dc release];
    self.window.rootViewController = self.navigationController;
    
//    [self initDatabase];
//    [self syncData];
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    NSError *error;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
			// Update to handle the error appropriately.
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			exit(-1);  // Fail
        } 
    }
}

- (void)dealloc
{
    [managedObjectContext release];
    [managedObjectModel release];
    [persistentStoreCoordinator release];
    
    [_window release];
    [_navigationController release];
    [super dealloc];
}

#pragma mark - save

- (void)saveAction
{	
    NSError *error;
    if (![[self managedObjectContext] save:&error]) {
		// Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
    }
}


#pragma mark - Core Data Stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *) managedObjectContext {
	
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
	
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    return managedObjectContext;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
 */
- (NSManagedObjectModel *)managedObjectModel {
	
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];    
    return managedObjectModel;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
	
	
	NSString *storePath = [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"WordTotalFrequency.sqlite"];
	/*
	 Set up the store.
	 For the sake of illustration, provide a pre-populated default store.
	 */
	NSFileManager *fileManager = [NSFileManager defaultManager];
	// If the expected store doesn't exist, copy the default store.
	if (![fileManager fileExistsAtPath:storePath]) {
		NSString *defaultStorePath = [[NSBundle mainBundle] pathForResource:@"WordTotalFrequency" ofType:@"sqlite"];
		if (defaultStorePath) {
			[fileManager copyItemAtPath:defaultStorePath toPath:storePath error:NULL];
		}
	}
    
	NSURL *storeUrl = [NSURL fileURLWithPath:storePath];
	
	NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];	
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
    
	NSError *error;
	if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:options error:&error]) {
		// Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
    }    
	
    return persistentStoreCoordinator;
}


#pragma mark - Application's documents directory

/**
 Returns the path to the application's documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
	
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}


@end
