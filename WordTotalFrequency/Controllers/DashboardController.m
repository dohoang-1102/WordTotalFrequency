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
#import "WordSetBriefView.h"
#import "UIColor+WTF.h"
#import "CustomSearchBar.h"

@implementation DashboardController

@synthesize wordSets = _wordSets;
@synthesize unitIcons = _unitIcons;
@synthesize selectedIconIndex = _selectedIconIndex;
@synthesize wordSetBrief = _wordSetBrief;

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
    [_wordSetBrief release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)setSelectedIconIndex:(NSInteger)selectedIconIndex
{
    _selectedIconIndex = selectedIconIndex;
    
    if (selectedIconIndex > -1)
    {
        _wordSetBrief.wordSet = [_wordSets objectAtIndex:selectedIconIndex];
        _wordSetBrief.hidden = NO;
        
        UnitIconView *icon = [_unitIcons objectAtIndex:selectedIconIndex];
        CGPoint point = icon.center;
        point = [_wordSetBrief convertPoint:point fromView:icon.superview];
        [_wordSetBrief centerArrowToX:point.x];
    }
}

#pragma mark - View lifecycle

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    CGRect rect = [UIScreen mainScreen].bounds;
    rect = CGRectMake(0, 20, rect.size.width, rect.size.height-20);
    
    self.view = [[[DashboardView alloc] initWithFrame:rect] autorelease];
    
    CustomSearchBar *searchBar = [[CustomSearchBar alloc] initWithFrame:CGRectZero];
    searchBar.delegate = self;
    [searchBar sizeToFit];    
    [self.view addSubview:searchBar];
    [searchBar release];
    
    // unit icons
    _unitIcons = [[NSMutableArray alloc] init];
    UnitIconView *icon = [[UnitIconView alloc]
                          initWithFrame:CGRectMake(20, 50, 36, 36)
                          image:@"Unit-1.png" percent:87 color:[UIColor colorWithHex:0xea240a]];
    icon.dashboard = self;
    [self.view addSubview:icon];
    [_unitIcons addObject:icon];
    [icon release];
    
    icon = [[UnitIconView alloc]
                          initWithFrame:CGRectMake(81, 50, 36, 36)
                          image:@"Unit-2.png" percent:57 color:[UIColor colorWithHex:0xea6d0a]];
    icon.dashboard = self;
    [self.view addSubview:icon];
    [_unitIcons addObject:icon];
    [icon release];
    
    icon = [[UnitIconView alloc]
            initWithFrame:CGRectMake(142, 50, 36, 36)
            image:@"Unit-3.png" percent:32 color:[UIColor colorWithHex:0xed9d14]];
    icon.dashboard = self;
    [self.view addSubview:icon];
    [_unitIcons addObject:icon];
    [icon release];
    
    icon = [[UnitIconView alloc]
            initWithFrame:CGRectMake(203, 50, 36, 36)
            image:@"Unit-4.png" percent:13 color:[UIColor colorWithHex:0xebb306]];
    icon.dashboard = self;
    [self.view addSubview:icon];
    [_unitIcons addObject:icon];
    [icon release];
    
    icon = [[UnitIconView alloc]
            initWithFrame:CGRectMake(264, 50, 36, 36)
            image:@"Unit-5.png" percent:0 color:[UIColor colorWithHex:0xeee745]];
    icon.dashboard = self;
    [self.view addSubview:icon];
    [_unitIcons addObject:icon];
    [icon release];
    
    // word set brief
    _wordSetBrief = [[WordSetBriefView alloc] initWithFrame:CGRectMake(10, 92, CGRectGetWidth(rect)-20, 200)];
    _wordSetBrief.hidden = YES;
    _wordSetBrief.dashboardController = self;
    [self.view addSubview:_wordSetBrief];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    
    // prepare data
    _wordSets = [[NSMutableArray alloc] init];
    WordSet *set = [[[WordSet alloc] initWithTotal:5765 marked:2328 color:[UIColor colorWithHex:0xea240a]] autorelease];
    set.description = @"Master this word set you can read some short articles and have basic conversations.";
    [_wordSets addObject:set];
    
    set = [[[WordSet alloc] initWithTotal:9233 marked:235 color:[UIColor colorWithHex:0xea6d0a]] autorelease];
    set.description = @"Master this word set you can understand basic conversations.";
    [_wordSets addObject:set];
    
    set = [[[WordSet alloc] initWithTotal:12457 marked:0 color:[UIColor colorWithHex:0xed9d14]] autorelease];
    set.description = @"Master this word set you can adfasf asdfasdf werwer asfasdf.";
    [_wordSets addObject:set];
    
    set = [[[WordSet alloc] initWithTotal:23219 marked:0 color:[UIColor colorWithHex:0xebb306]] autorelease];
    set.description = @"Master this word set you can read some short articles and have basic conversations.";
    [_wordSets addObject:set];
    
    set = [[[WordSet alloc] initWithTotal:49346 marked:0 color:[UIColor colorWithHex:0xeee745]] autorelease];
    set.description = @"Master this word set you can read some short articles and have basic conversations.";
    [_wordSets addObject:set];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (_selectedIconIndex > -1)
    {
        [_wordSetBrief.tableView
            deselectRowAtIndexPath:[_wordSetBrief.tableView indexPathForSelectedRow]
                          animated:YES];
    }
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    _selectedIconIndex = -1;
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
