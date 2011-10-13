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

@implementation DataController

SYNTHESIZE_SINGLETON_FOR_CLASS(DataController);

@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;

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

- (NSFetchRequest *)fetchHistoryRequest
{
    if (_fetchRequest != nil)
    {
        return _fetchRequest;
    }
    
    _fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"History"
                                              inManagedObjectContext:[DataController sharedDataController].managedObjectContext];
    [_fetchRequest setEntity:entity];
    return _fetchRequest;
}

- (void)markWord:(Word *)word
{
    NSManagedObject *history = [MANAGED_OBJECT_CONTEXT insertNewObjectForEntityForName:@"History"];
    [history setValue:word.category forKey:@"category"];
    [history setValue:word.spell forKey:@"spell"];
    [history setValue:word.translate forKey:@"translate"];
    [history setValue:[NSDate date] forKey:@"date"];
    
    NSURL *uri = [[word objectID] URIRepresentation];
    NSData *uriData = [NSKeyedArchiver archivedDataWithRootObject:uri];
    [history setValue:uriData forKey:@"uriRepresentation"];
    
    [self saveFromSource:@"mark word"];
    [MANAGED_OBJECT_CONTEXT refreshObject:word mergeChanges:NO];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HistoryChanged" object:self];
}

- (void)unmarkWord:(NSString *)spell
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"spell = %@", spell];
    [[self fetchHistoryRequest] setPredicate:predicate];
    NSArray *items = [MANAGED_OBJECT_CONTEXT  executeFetchRequest:[self fetchHistoryRequest] error:nil];
    if ([items count] > 0){
        [MANAGED_OBJECT_CONTEXT deleteObject:[items objectAtIndex:0]];
        [self saveFromSource:@"unmark word"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"HistoryChanged" object:self];
    }
}



@end
