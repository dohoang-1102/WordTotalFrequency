//
//  DataController.m
//  CoreDataLibrary
//
//  
//  Copyright 2010 Eric Peter. 
//  Released under the GPL v3 License
//
//  code.google.com/p/coredatalibrary

#import "DataController.h"
#import "SynthesizeSingleton.h"
#import "NSDate+Ext.h"
#import "DataUtil.h"
#import "Constant.h"
#import <sqlite3.h>

@implementation DataController

SYNTHESIZE_SINGLETON_FOR_CLASS(DataController);

@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize notificationOn;

#pragma mark -
#pragma mark Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *) managedObjectContext {
	
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
	
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator: coordinator];
        [_managedObjectContext setUndoManager:nil];
    }
    return _managedObjectContext;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
 */
- (NSManagedObjectModel *)managedObjectModel {
	
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    _managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];    
    return _managedObjectModel;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
		
	NSString *storePath = [[self applicationDocumentsDirectory] stringByAppendingPathComponent: SQL_DATABASE_NAME];
	
	storePath = [storePath stringByAppendingString: @".sqlite"];

	NSURL *storeUrl = [NSURL fileURLWithPath:storePath];

	
	/*
	 Set up the store.
	 For the first run, copy over our initial data.
	 Template code left here if you want to do this.
	 */
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	// If the expected store doesn't exist, copy the default store.
	if (![fileManager fileExistsAtPath:storePath]) {
		NSString *defaultStorePath = [[NSBundle mainBundle] pathForResource:SQL_DATABASE_NAME ofType:@"sqlite"];
		if (defaultStorePath) {
			[fileManager copyItemAtPath:defaultStorePath toPath:storePath error:NULL];
		}
	}
	
	
	//Try to automatically migrate minor changes
	NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys: [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,[NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
	
	NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:options error:&error]) {
		
		[self handleError:error fromSource:@"Open persistant store"];
    }    
	
    return _persistentStoreCoordinator;
}

#pragma mark -
#pragma mark CDLC Save

/**
 Saves the Managed Object Context, calling the logging method if an error occurs
 */
- (void)saveFromSource:(NSString *)source
{
	NSError *error;
	if (![[self managedObjectContext] save:&error]) {
		[self handleError:error fromSource:source];
	}
}

#pragma mark -
#pragma mark Error Handling

/**
 Error logging/user notification should be implemented here.  Call this method whenever an error happens
 */
/*
 Apple says: "Replace this implementation with code to handle the error appropriately.
 
 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.

 Check the error message to determine what the actual problem was."
 */
- (void) handleError:(NSError *)error fromSource:(NSString *)sourceString
{
	NSLog(@"Unresolved error %@ at %@, %@", error, sourceString, [error userInfo]);
	abort(); // Fail
	
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error loading data", @"Error loading data") 
													message:[NSString stringWithFormat:@"Error was: %@, quitting.", [error localizedDescription]]
												   delegate:self 
										  cancelButtonTitle:NSLocalizedString(@"Aw, Nuts", @"Aw, Nuts")
										  otherButtonTitles:nil];
	[alert show];
}

#pragma mark -
#pragma mark Application's Documents directory

/**
 Returns the path to the application's Documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}


#pragma mark - handy methods

- (void)markWord:(Word *)word status:(NSUInteger)status
{
    word.markStatus = [NSNumber numberWithInt:status];
    switch (status) {
        case 0:
            word.markDate = @"";
            break;
        default:
            word.markDate = [[NSDate date] formatLongDate];
            break;
    }
    [self saveFromSource:@"mark word"];
    [[NSNotificationCenter defaultCenter] postNotificationName:HISTORY_CHANGED_NOTIFICATION object:self];
}

- (void)markWordToNextLevel:(Word *)word
{
    NSUInteger k = 0;
    switch ([word.markStatus intValue]) {
        case 0:
            k = 1;
            break;
        case 1:
            k = 2;
            break;
        case 2:
            k = 0;
            break;
    }
    [self markWord:word status:k];
}

static NSDictionary *alldict = nil;

- (NSDictionary *)settingsDictionary
{
    if (alldict == nil){
        alldict = [[DataUtil readDictionaryFromFile:@"WordSets"] retain];
    }
    return alldict;
}

- (NSDictionary *)dictionaryForCategoryId:(NSUInteger)categoryId
{
    NSArray *array = [self.settingsDictionary objectForKey:@"WordSets"];
    NSDictionary *dict = [array objectAtIndex:categoryId];
    return dict;
}

- (void)setNotificationOn:(BOOL)_notificationOn
{
    [self.settingsDictionary setValue:[NSNumber numberWithBool:_notificationOn] forKey:@"NotificationOn"];
}

- (BOOL)isNoticationOn
{
    NSNumber *number = [self.settingsDictionary objectForKey:@"NotificationOn"];
    return [number boolValue];
}

- (void)saveSettingsDictionary
{
    [DataUtil writeDictionary:self.settingsDictionary toDataFile:@"WordSets"];
}

- (NSString *)dbPath
{
    NSString *storePath = [[self applicationDocumentsDirectory] stringByAppendingPathComponent: SQL_DATABASE_NAME];
	storePath = [storePath stringByAppendingString: @".sqlite"];
    return storePath;
}

- (void)scheduleNextWord
{
    if (![self isNoticationOn])
        return;
    
    // retrieve next unmarked word
    NSString *nextWord = @"";
    sqlite3 *database;
    if (sqlite3_open([self.dbPath UTF8String], &database) == SQLITE_OK) {
        NSString *sql = @"SELECT ZSPELL, ZCATEGORY FROM ZWORD WHERE ZMARKSTATUS=0 ORDER BY ZRANK DESC LIMIT 0, 1";
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_ROW) {
                nextWord = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
            }
        }
        sqlite3_finalize(statement);
    } else {
        NSLog(@"failed open db");
    }
    sqlite3_close(database);
    database = NULL;
    
    if (nextWord == @"")
        return;
    
    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    
    // Get the current date
    NSDate *pickerDate = [NSDate date];
    
    // Break the date up into components
    NSDateComponents *dateComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit)
												   fromDate:pickerDate];
//    NSDateComponents *timeComponents = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit)
//												   fromDate:pickerDate];
    // Set up the fire time
    NSDateComponents *dateComps = [[NSDateComponents alloc] init];
    [dateComps setDay:[dateComponents day]+1];
    [dateComps setMonth:[dateComponents month]];
    [dateComps setYear:[dateComponents year]];
    [dateComps setHour:11];
    [dateComps setMinute:30];
	[dateComps setSecond:0];
    NSDate *itemDate = [calendar dateFromComponents:dateComps];
    [dateComps release];
    
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    localNotif.fireDate = itemDate;
    localNotif.timeZone = [NSTimeZone defaultTimeZone];
    
	// Notification details
    localNotif.alertBody = [NSString stringWithFormat:@"Time to learn new word: %@", nextWord];
	// Set the action button
    localNotif.alertAction = @"View";
    
    localNotif.soundName = UILocalNotificationDefaultSoundName;
    localNotif.applicationIconBadgeNumber = 1;
    
	// Specify custom data for the notification
    NSDictionary *infoDict = [NSDictionary dictionaryWithObject:@"someValue" forKey:@"someKey"];
    localNotif.userInfo = infoDict;
    
	// Schedule the notification
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
    [localNotif release];
}

@end
