//
//  WordListController.m
//  WordTotalFrequency
//
//  Created by OCS on 11-7-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "WordListController.h"
#import "WordDetailController.h"
#import "Word.h"
#import "WordTotalFrequencyAppDelegate.h"
#import "WordListCell.h"



@implementation WordListController

@synthesize delegate = _delegate;
@synthesize wordSetController = _wordSetController;

@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize searchString = _searchString;
@synthesize wordSetIndex = _wordSetIndex;
@synthesize listType = _listType;

- (id)initWIthListType:(WordListType)listType
{
    if ((self = [super init]))
    {
        _listType = listType;
        self.wordSetIndex = -1;
    }
    return self;
}

- (void)dealloc
{
    self.fetchedResultsController.delegate = nil;
    self.fetchedResultsController = nil;
    
    [_searchString release];
    [super dealloc];
}

- (void)setSearchString:(NSString *)searchString
{
    if (_searchString != searchString)
    {
        [_searchString release];
        _searchString = [searchString copy];
        
        [NSFetchedResultsController deleteCacheWithName:nil];
        if ([searchString isEqualToString:@""])
        {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"1 != -1"];
            [self.fetchedResultsController.fetchRequest setPredicate:predicate];
        }
        else
        {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"spell contains[cd] %@", searchString];
            [self.fetchedResultsController.fetchRequest setPredicate:predicate];
        }
        
        
        dispatch_queue_t main_queue = dispatch_get_main_queue();
        dispatch_queue_t request_queue = dispatch_queue_create("com.app.biterice", NULL);
        
        __block __typeof__(self) blockSelf = self;
        
        dispatch_async(request_queue, ^{
            NSError *error;
            if (![blockSelf.fetchedResultsController performFetch:&error]) {
                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                exit(-1);  // Fail
            }
            
            dispatch_sync(main_queue, ^{
                [blockSelf.tableView reloadData];
            });
        });
    }
}

#pragma mark - View lifecycle

// Implement loadView to create a view hierarchy programmatically, without using a nib.

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];

//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.separatorColor = [UIColor colorWithWhite:1.f alpha:.5f];
    
    if (_wordSetIndex > -1)
    {
        self.tableView.backgroundColor = [UIColor clearColor];
        if (_listType == WordListTypeWordSet)
            [self.fetchedResultsController.fetchRequest
             setPredicate:[NSPredicate predicateWithFormat:@"category = %d", _wordSetIndex]];
        else
            [self.fetchedResultsController.fetchRequest
             setPredicate:[NSPredicate predicateWithFormat:@"category = %d and marked = true", _wordSetIndex]];
    }
    else
    {
        self.tableView.backgroundColor = [UIColor colorWithRed:203.0/255 green:234.0/255 blue:1.0 alpha:1.0];
    }
    
    if (_wordSetIndex > -1 || _searchString)
    {
        dispatch_queue_t main_queue = dispatch_get_main_queue();
        dispatch_queue_t request_queue = dispatch_queue_create("com.app.biterice", NULL);
        
        __block __typeof__(self) blockSelf = self;
        
        dispatch_async(request_queue, ^{
            NSError *error;
            if (![blockSelf.fetchedResultsController performFetch:&error]) {
                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                exit(-1);  // Fail
            }
            
            dispatch_sync(main_queue, ^{
                [blockSelf.tableView reloadData];
                if (_listType == WordListTypeWordSet)
                    blockSelf.wordSetController.testWords = blockSelf.fetchedResultsController.fetchedObjects;
                
                dispatch_release(request_queue);
            });
        });
    }
}

- (void)viewDidUnload
{
    _fetchedResultsController = nil;
    [super viewDidUnload];
}

- (void)viewDidDisappear:(BOOL)animated
{
    WordTotalFrequencyAppDelegate *appDelegate = (WordTotalFrequencyAppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate saveAction];
    [super viewDidDisappear:animated];
}

#pragma mark - table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [_fetchedResultsController.sections objectAtIndex:section];
    if (_wordSetIndex > -1)
    {
        return [sectionInfo numberOfObjects];        
    }
    return MIN(30, [sectionInfo numberOfObjects]);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    WordListCell *cell = (WordListCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[WordListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.wordSetController = _wordSetController;
        cell.ownerTable = tableView;
    }
    
    Word *word = [_fetchedResultsController objectAtIndexPath:indexPath];
    cell.word = word;
    cell.rowIndex = indexPath.row;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Word *word = (Word *)[[self fetchedResultsController] objectAtIndexPath:indexPath];
    [self.delegate willSelectWord:word];
    
    WordDetailController *controller = [[WordDetailController alloc] init];
    controller.word = word;
    controller.words = self.fetchedResultsController.fetchedObjects;
    controller.wordSetIndex = self.wordSetIndex;
    controller.currentWordIndex = indexPath.row;
    controller.wordListController = self;
    [(UINavigationController *)self.view.window.rootViewController pushViewController:controller animated:YES];
    [controller release];
}


#pragma mark -- Fetched Results Controller

/**
 Returns the fetched results controller. Creates and configures the controller if necessary.
 */
- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    WordTotalFrequencyAppDelegate *appDelegate = (WordTotalFrequencyAppDelegate *)[UIApplication sharedApplication].delegate;

	// Create and configure a fetch request with the Book entity.
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Word" inManagedObjectContext:appDelegate.managedObjectContext];
	[fetchRequest setEntity:entity];
    
    // Create the sort descriptors array.
	NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"rank" ascending:NO];
	[fetchRequest setSortDescriptors:[NSArray arrayWithObject:descriptor]];
    [descriptor release];

    NSArray *propertiesToFetch = [[NSArray alloc] initWithObjects:@"marked", @"spell", @"translate", nil];
    [fetchRequest setPropertiesToFetch:propertiesToFetch];
    [propertiesToFetch release];

    [fetchRequest setFetchBatchSize:20];
    	
	// Create and initialize the fetch results controller.
	NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc]
                                                             initWithFetchRequest:fetchRequest
                                                             managedObjectContext:appDelegate.managedObjectContext
                                                             sectionNameKeyPath:nil cacheName:nil];
	self.fetchedResultsController = aFetchedResultsController;
	_fetchedResultsController.delegate = self;
	
	// Memory management.
	[aFetchedResultsController release];
	[fetchRequest release];
	
	return _fetchedResultsController;
}

@end
