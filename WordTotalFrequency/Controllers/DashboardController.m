//
//  DashboardController.m
//  WordTotalFrequency
//
//  Created by OCS on 11-7-21.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "DashboardController.h"
#import "Common.h"
#import "DashboardView.h"
#import "WordSet.h"
#import "WordSetController.h"
#import "UnitIconView.h"

@implementation DashboardController

@synthesize wordSets = _wordSets;
@synthesize unitIcons = _unitIcons;
@synthesize selectedIconIndex = _selectedIconIndex;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [_wordSets release];
    [_unitIcons release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    CGRect rect = [UIScreen mainScreen].bounds;
    rect = CGRectMake(0, 64, rect.size.width, rect.size.height-64);
    
    self.view = [[[DashboardView alloc] initWithFrame:rect] autorelease];
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectZero];
    searchBar.delegate = self;
    [searchBar sizeToFit];
    [[[searchBar subviews] objectAtIndex:0] setAlpha:0.0];
    
    [self.view addSubview:searchBar];
    [searchBar release];
    
    // unit icons
    _unitIcons = [[NSMutableArray alloc] init];
    UnitIconView *icon = [[UnitIconView alloc]
                          initWithFrame:CGRectMake(20, 50, 36, 36)
                          image:@"Unit-1.png" percent:87];
    icon.dashboard = self;
    [self.view addSubview:icon];
    [_unitIcons addObject:icon];
    [icon release];
    
    icon = [[UnitIconView alloc]
                          initWithFrame:CGRectMake(81, 50, 36, 36)
                          image:@"Unit-2.png" percent:57];
    icon.dashboard = self;
    [self.view addSubview:icon];
    [_unitIcons addObject:icon];
    [icon release];
    
    icon = [[UnitIconView alloc]
            initWithFrame:CGRectMake(142, 50, 36, 36)
            image:@"Unit-3.png" percent:32];
    icon.dashboard = self;
    [self.view addSubview:icon];
    [_unitIcons addObject:icon];
    [icon release];
    
    icon = [[UnitIconView alloc]
            initWithFrame:CGRectMake(203, 50, 36, 36)
            image:@"Unit-4.png" percent:13];
    icon.dashboard = self;
    [self.view addSubview:icon];
    [_unitIcons addObject:icon];
    [icon release];
    
    icon = [[UnitIconView alloc]
            initWithFrame:CGRectMake(264, 50, 36, 36)
            image:@"Unit-5.png" percent:0];
    icon.dashboard = self;
    [self.view addSubview:icon];
    [_unitIcons addObject:icon];
    [icon release];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _selectedIconIndex = -1;
    // prepare data
    self.wordSets = [NSArray arrayWithObjects:
                     [[[WordSet alloc] initWithName:@"1." count:5765 color:[UIColor redColor]] autorelease],
                     [[[WordSet alloc] initWithName:@"2." count:9233 color:[UIColor orangeColor]] autorelease],
                     [[[WordSet alloc] initWithName:@"3." count:12457 color:[UIColor lightGrayColor]] autorelease],
                     [[[WordSet alloc] initWithName:@"4." count:23219 color:[UIColor purpleColor]] autorelease],
                     [[[WordSet alloc] initWithName:@"5." count:49346 color:[UIColor yellowColor]] autorelease],
                     nil];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
	[searchBar resignFirstResponder];
}


@end
