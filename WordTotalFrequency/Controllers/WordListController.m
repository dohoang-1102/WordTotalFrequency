//
//  WordListController.m
//  WordTotalFrequency
//
//  Created by OCS on 11-7-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "WordListController.h"
#import "WordListCellContentView.h"
#import "WordDetailController.h"
#import "Word.h"
#import "WordTotalFrequencyAppDelegate.h"

@implementation WordListController

@synthesize delegate = _delegate;
@synthesize wordSetController = _wordSetController;

@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize searchString = _searchString;
@synthesize wordSetIndex = _wordSetIndex;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)init
{
    if ((self = [super init]))
    {
        self.wordSetIndex = -1;
    }
    return self;
}

- (void)dealloc
{
    [_fetchedResultsController release];
    [_searchString release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)setSearchString:(NSString *)searchString
{
    if (_searchString != searchString)
    {
        [_searchString release];
        _searchString = [searchString copy];
        
        if ([searchString isEqualToString:@""])
        {
            [self.fetchedResultsController.fetchRequest setPredicate:nil];
        }
        else
        {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"spell contains[cd] %@", searchString];
            [self.fetchedResultsController.fetchRequest setPredicate:predicate];
        }
        
        NSError *error;
        if (![[self fetchedResultsController] performFetch:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            exit(-1);  // Fail
        }
        
        [self.tableView reloadData];
    }
}

#pragma mark - View lifecycle

// Implement loadView to create a view hierarchy programmatically, without using a nib.

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorColor = [UIColor colorWithWhite:1.f alpha:.5f];
    
    if (_wordSetIndex > -1)
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"category = %d", _wordSetIndex];
        [self.fetchedResultsController.fetchRequest setPredicate:predicate];
    }
    
    NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}
    
    if (_wordSetIndex > -1)
        self.wordSetController.testWords = self.fetchedResultsController.fetchedObjects;
}

- (void)viewDidUnload
{
    [_fetchedResultsController release];
    _fetchedResultsController = nil;
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
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
    return 38;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
        WordListCellContentView *cellView = [[WordListCellContentView alloc] initWithFrame:cell.bounds];
        cellView.wordSetController = _wordSetController;
        cellView.tag = 1;
        [cell.contentView addSubview:cellView];
        [cellView release];
    }
    
    // Configure the cell...
    WordListCellContentView *cellView = (WordListCellContentView *)[cell viewWithTag:1];
    Word *word = [_fetchedResultsController objectAtIndexPath:indexPath];
    cellView.word = word;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Word *word = (Word *)[[self fetchedResultsController] objectAtIndexPath:indexPath];
    [self.delegate willSelectWord:word];
    
    WordDetailController *controller = [[WordDetailController alloc] init];
    controller.word = word;
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
    [fetchRequest setFetchBatchSize:20];
    
    // Create the sort descriptors array.
	NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"rank" ascending:NO];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:descriptor, nil];
    [descriptor release];
	[fetchRequest setSortDescriptors:sortDescriptors];
	[sortDescriptors release];
    
    NSArray *propertiesToFetch = [[NSArray alloc] initWithObjects:@"spell", @"translate", nil];
    [fetchRequest setPropertiesToFetch:propertiesToFetch];
    [propertiesToFetch release];

	
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
