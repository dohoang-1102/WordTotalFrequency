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

@interface DashboardController()
- (void)dismissSearchResult;
@end

@implementation DashboardController

@synthesize wordSets = _wordSets;
@synthesize unitIcons = _unitIcons;
@synthesize selectedIconIndex = _selectedIconIndex;
@synthesize wordSetBrief = _wordSetBrief;
@synthesize searchBar = _searchBar;
@synthesize listController = _listController;

#define SEARCH_BAR_HEIGHT 40

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
    [_searchBar release];
    [_listController release];
    [super dealloc];
}

- (void)loadData
{
    _wordSets = [[NSMutableArray alloc] init];
    WordSet *set = [[[WordSet alloc] initWithTotal:5765 marked:5328 color:[UIColor colorWithHex:0xff4600]] autorelease];
    set.description = @"Master this word set you can read some short articles and have basic conversations.";
    [_wordSets addObject:set];
    
    set = [[[WordSet alloc] initWithTotal:9233 marked:235 color:[UIColor colorWithHex:0xff6600]] autorelease];
    set.description = @"Master this word set you can understand basic conversations.";
    [_wordSets addObject:set];
    
    set = [[[WordSet alloc] initWithTotal:12457 marked:2348 color:[UIColor colorWithHex:0xff9800]] autorelease];
    set.description = @"Master this word set you can adfasf asdfasdf werwer asfasdf.";
    [_wordSets addObject:set];
    
    set = [[[WordSet alloc] initWithTotal:23219 marked:8729 color:[UIColor colorWithHex:0xffb900]] autorelease];
    set.description = @"Master this word set you can read some short articles and have basic conversations.";
    [_wordSets addObject:set];
    
    set = [[[WordSet alloc] initWithTotal:49346 marked:0 color:[UIColor colorWithHex:0xffda00]] autorelease];
    set.description = @"Master this word set you can read some short articles and have basic conversations.";
    [_wordSets addObject:set];
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
        _wordSetBrief.hidden = NO;
        _wordSetBrief.wordSet = [_wordSets objectAtIndex:selectedIconIndex];
        
        UnitIconView *icon = [_unitIcons objectAtIndex:selectedIconIndex];
        CGPoint point = icon.center;
        point = [_wordSetBrief convertPoint:point fromView:icon.superview];
        [_wordSetBrief centerArrowToX:point.x];
    }
}

- (void)dismissSearchResult
{
    CGContextRef context = UIGraphicsGetCurrentContext();
	[UIView beginAnimations:nil context:context];
    
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.25];
	CGRect rect = _listController.view.frame;
	rect.origin.y = CGRectGetHeight(self.view.frame);
	_listController.view.frame = rect;
	
    for (UIView *view in self.view.subviews) {
        if (view != _searchBar && view != _listController.view)
        {
            view.alpha = 100;
        }
    }
    
    [UIView commitAnimations];
}

#pragma mark - View lifecycle

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    CGRect rect = [UIScreen mainScreen].bounds;
    rect = CGRectMake(0, 20, rect.size.width, rect.size.height-20);
    
    self.view = [[[DashboardView alloc] initWithFrame:rect] autorelease];
    
    _searchBar = [[CustomSearchBar alloc] initWithFrame:CGRectZero];
    _searchBar.delegate = self;
    _searchBar.placeholder = @"type to search";
    [_searchBar sizeToFit];    
    [self.view addSubview:_searchBar];
    
    // unit icons
    _unitIcons = [[NSMutableArray alloc] init];
    for (int i=0; i<5; i++)
    {
        UnitIconView *icon = [[UnitIconView alloc]
                              initWithFrame:CGRectMake(20 + i * 61, 50, 36, 36)
                              image:[NSString stringWithFormat:@"Unit-%d", (i+1)]];
        icon.dashboard = self;
        [self.view addSubview:icon];
        [_unitIcons addObject:icon];
        [icon release];
    }

    // word set brief
    _wordSetBrief = [[WordSetBriefView alloc] initWithFrame:CGRectMake(0, 92, CGRectGetWidth(rect), 200)];
    _wordSetBrief.hidden = YES;
    _wordSetBrief.dashboardController = self;
    [self.view addSubview:_wordSetBrief];
    
    _listController = [[WordListController alloc] init];
    [self.view addSubview:_listController.view];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _listController.view.frame = CGRectMake(0,
                                            CGRectGetHeight(self.view.frame),
                                            CGRectGetWidth(self.view.frame),
                                            CGRectGetHeight(self.view.frame)- SEARCH_BAR_HEIGHT);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    for (UnitIconView *icon in _unitIcons) {
        [icon addCADisplayLink];
    }
    
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
    
    [self loadData];
    for (int i=0; i<[_wordSets count]; i++)
    {
        UnitIconView *icon = [_unitIcons objectAtIndex:i];
        icon.wordSet = [_wordSets objectAtIndex:i];
    }
    
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

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    [_searchBar resignFirstResponder];
    [self dismissSearchResult];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    CGContextRef context = UIGraphicsGetCurrentContext();
	[UIView beginAnimations:nil context:context];
    
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.25];
	CGRect rect = _listController.view.frame;
	rect.origin.y = SEARCH_BAR_HEIGHT;
	_listController.view.frame = rect;
    
    for (UIView *view in self.view.subviews) {
        if (view != _searchBar && view != _listController.view)
        {
            view.alpha = 0;
        }
    }
	
    [UIView commitAnimations];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [self dismissSearchResult];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
	[searchBar resignFirstResponder];
    [self dismissSearchResult];
}


@end
