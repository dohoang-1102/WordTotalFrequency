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
#import "WordTotalFrequencyAppDelegate.h"

@interface DashboardController()
- (void)dismissSearchResult:(BOOL)animated;
@end

@implementation DashboardController

@synthesize wordSets = _wordSets;
@synthesize unitIcons = _unitIcons;
@synthesize wordSetBrief = _wordSetBrief;
@synthesize briefView = _briefView;
@synthesize searchBar = _searchBar;
@synthesize listController = _listController;
@synthesize collapseButton = _collapseButton;
@synthesize fetchRequest = _fetchRequest;

#define SEARCH_BAR_HEIGHT 40
#define WORDSETBRIEF_HEIGHT 115

- (void)dealloc
{
    [_collapseButton release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [_fetchRequest release];
    _fetchRequest = nil;
    
    [_wordSets release];
    [_unitIcons release];
    [_briefView release];
    [_wordSetBrief release];
    [_searchBar release];
    [_listController release];
    
    [_barContainer release];
    [_pieChart release];
    
    [super dealloc];
}

- (void)loadData
{
    _wordSets = [[NSMutableArray alloc] init];
    WordSet *set = [[[WordSet alloc] initWithTotal:5765 marked:3210 color:[UIColor colorWithHex:0xff4600]] autorelease];
    set.description = @"Master this word set you can read some short .";
    set.iconUrl = @"Unit-1";
    set.categoryId = 0;
    set.arrowColor = [UIColor colorWithHex:0xbee3fd];
    [_wordSets addObject:set];
    
    set = [[[WordSet alloc] initWithTotal:9233 marked:235 color:[UIColor colorWithHex:0xff6600]] autorelease];
    set.description = @"Master this word set you can understand basic conversations.";
    set.iconUrl = @"Unit-2";
    set.categoryId = 1;
    set.arrowColor = [UIColor colorWithHex:0xa1d7f9];
    [_wordSets addObject:set];
    
    set = [[[WordSet alloc] initWithTotal:12457 marked:2348 color:[UIColor colorWithHex:0xff9800]] autorelease];
    set.description = @"Master this word set you can adfasf asdfasdf werwer asfasdf.";
    set.iconUrl = @"Unit-3";
    set.categoryId = 2;
    set.arrowColor = [UIColor colorWithHex:0x8ecff7];
    [_wordSets addObject:set];
    
    set = [[[WordSet alloc] initWithTotal:23219 marked:1030 color:[UIColor colorWithHex:0xffb900]] autorelease];
    set.description = @"Master this word set you can read some short article.";
    set.iconUrl = @"Unit-4";
    set.categoryId = 3;
    set.arrowColor = [UIColor colorWithHex:0xa1d7f9];
    [_wordSets addObject:set];
    
    set = [[[WordSet alloc] initWithTotal:49346 marked:0 color:[UIColor colorWithHex:0xffda00]] autorelease];
    set.description = @"Master this word set you can read some short articles and have.";
    set.iconUrl = @"Unit-5";
    set.categoryId = 4;
    set.arrowColor = [UIColor colorWithHex:0xbee3fd];
    [_wordSets addObject:set];
    
    // retrieve data
    for (int i=0; i<5; i++) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"category = %d", i];
        [self.fetchRequest setPredicate:predicate];
        
        NSError *error;
        NSUInteger total = [self.managedObjectContext countForFetchRequest:self.fetchRequest error:&error];
        
        // marked count
        predicate = [NSPredicate predicateWithFormat:@"category = %d and marked = 1", i];
        [self.fetchRequest setPredicate:predicate];
        
        NSUInteger marked = [self.managedObjectContext countForFetchRequest:self.fetchRequest error:&error];
        WordSet *wordSet = [_wordSets objectAtIndex:i];
        wordSet.totalWordCount = total;
        wordSet.markedWordCount = marked;
        
        UnitIconView *icon = [_unitIcons objectAtIndex:i];
        [icon updateData];
    }
}

- (void)dismissSearchResult:(BOOL)animated
{
    if (animated)
    {
        CGContextRef context = UIGraphicsGetCurrentContext();
        [UIView beginAnimations:nil context:context];
        
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.2];
        CGRect rect = _listController.view.frame;
        rect.origin.y = CGRectGetHeight(self.view.frame);
        _listController.view.frame = rect;
        
        [UIView commitAnimations];
    }
    else
    {
        CGRect rect = _listController.view.frame;
        rect.origin.y = CGRectGetHeight(self.view.frame);
        _listController.view.frame = rect;
    }
}

- (void)presentWordSetBrief
{
    [UIView transitionWithView:_barContainer duration:.2
                       options:UIViewAnimationOptionCurveEaseInOut
                    animations:^ {
                        _wordSetBrief.frame = CGRectMake(0, 0, 320, WORDSETBRIEF_HEIGHT);
                    }
                    completion:^(BOOL finished) {
                        if (finished)
                            _briefView.hidden = YES;
                    }];
}

- (void)dismissWordSetBrief
{
    [UIView transitionWithView:_barContainer duration:.2
                       options:UIViewAnimationOptionCurveEaseInOut
                    animations:^ {
                        _wordSetBrief.frame = CGRectMake(0, -WORDSETBRIEF_HEIGHT, 320, WORDSETBRIEF_HEIGHT);
                    }
                    completion:^(BOOL finished) {
                    }];
    _briefView.hidden = NO;
}

- (NSInteger)selectedIconIndex
{
    @synchronized(self) {
        return _selectedIconIndex;
    }
}

- (void)setSelectedIconIndex:(NSInteger)selectedIconIndex
{
    @synchronized(self) {
        NSInteger oldIndex = _selectedIconIndex;
        _selectedIconIndex = selectedIconIndex;
        
        UnitIconView *icon;
        if (selectedIconIndex > -1)
        {
            _wordSetBrief.wordSet = [_wordSets objectAtIndex:selectedIconIndex];
            
            icon = [_unitIcons objectAtIndex:selectedIconIndex];
            CGPoint point = icon.center;
            point = [_wordSetBrief convertPoint:point fromView:icon.superview];
            [_wordSetBrief centerArrowToX:point.x];
            [self performSelector:@selector(presentWordSetBrief) withObject:nil afterDelay:.25];
        }
        else if (oldIndex > -1)
        {
            icon = [_unitIcons objectAtIndex:oldIndex];
            [icon toggleDisplayState:icon affectDashboard:NO];
        }
    }
}

- (void)keyboardWillShow:(NSNotification *)note {
    NSArray *allWindows = [[UIApplication sharedApplication] windows];
	int topWindow = [allWindows count] - 1;
	UIWindow *keyboardWindow = [allWindows objectAtIndex:topWindow];
    [keyboardWindow addSubview:self.collapseButton];

    [UIView transitionWithView:self.collapseButton duration:0.2
                       options:UIViewAnimationOptionCurveLinear
                    animations:^ {
                        self.collapseButton.frame = CGRectMake(242, 438, 75, 39);
                    }
                    completion:^(BOOL finished) {
                    }];
}

- (void)keyboardWillHide:(NSNotification *)note {
    [UIView transitionWithView:self.collapseButton duration:0.2
                       options:UIViewAnimationOptionCurveLinear
                    animations:^ {
                        self.collapseButton.frame = CGRectMake(242, 480, 75, 39);
                    }
                    completion:^(BOOL finished) {
                        if (finished)
                            [self.collapseButton removeFromSuperview];
                    }];
}

- (void)dismissKeyboard
{
    [_searchBar resignFirstResponder];
}


#pragma mark - View lifecycle

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    CGRect rect = [UIScreen mainScreen].bounds;
    rect = CGRectMake(0, 20, rect.size.width, rect.size.height-20);
    
    self.view = [[[DashboardView alloc] initWithFrame:rect] autorelease];
    
    _searchBar = [[CustomSearchBar alloc] init];
    _searchBar.keyboardType = UIKeyboardTypeASCIICapable;
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
    
    _barContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 92, CGRectGetWidth(rect), WORDSETBRIEF_HEIGHT)];
    _barContainer.clipsToBounds = YES;
    [self.view addSubview:_barContainer];
    
    _briefView = [[BriefView alloc] 
                  initWithFrame:CGRectMake(10, 20, CGRectGetWidth(rect)-20, 100)
                  count:1234 level:@"IV"];
    [_barContainer addSubview:_briefView];

    // word set brief
    _wordSetBrief = [[WordSetBriefView alloc]
                     initWithFrame:CGRectMake(0, -WORDSETBRIEF_HEIGHT, CGRectGetWidth(rect), WORDSETBRIEF_HEIGHT)];
    _wordSetBrief.dashboardController = self;
    [_barContainer addSubview:_wordSetBrief];
    
    // pie chart
    _pieChart = [[PieChart alloc] initWithFrame:CGRectMake(0, 120, 320, 360)];
    _pieChart.backgroundColor = [UIColor clearColor];
    [self.view insertSubview:_pieChart atIndex:1];
    
    _listController = [[WordListController alloc] initWIthListType:WordListTypeSearchResult];
    _listController.delegate = self;
    [self.view addSubview:_listController.view];
    
    // keyboard notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    self.collapseButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    self.collapseButton.frame = CGRectMake(242, 480, 75, 39);
    [self.collapseButton setImage:[UIImage imageNamed:@"down-button.png"] forState:UIControlStateNormal];
    [self.collapseButton setImage:[UIImage imageNamed:@"down-button.png"] forState:UIControlStateHighlighted];
    [self.collapseButton addTarget:self action:@selector(dismissKeyboard)  forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _listController.view.frame = CGRectMake(0,
                                            CGRectGetHeight(self.view.frame),
                                            CGRectGetWidth(self.view.frame),
                                            CGRectGetHeight(self.view.frame)- SEARCH_BAR_HEIGHT);
    
    [_searchBar resignFirstResponder];
    [self dismissSearchResult:NO];
    
    if (_selectedIconIndex > -1)
        [_wordSetBrief updateDisplay];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.managedObjectContext reset];
    
    for (UnitIconView *icon in _unitIcons) {
        [icon addCADisplayLink];
    }
    
    if (_selectedIconIndex > -1)
    {
        [_wordSetBrief performSelector:@selector(fadeSelectedBackground) withObject:nil afterDelay:0.15];
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
    [self dismissSearchResult:YES];
    [self dismissWordSetBrief];
    self.selectedIconIndex = -1;
}

#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [self.searchBar.searchBox setBackground:[UIImage imageNamed:@"search-bg-highlight"]];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
	[UIView beginAnimations:nil context:context];
    
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.2];
	CGRect rect = _listController.view.frame;
	rect.origin.y = SEARCH_BAR_HEIGHT;
	_listController.view.frame = rect;
    
    [UIView commitAnimations];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [self dismissSearchResult:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
	[searchBar resignFirstResponder];
    [self dismissSearchResult:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    _listController.searchString = searchBar.text;
}

#pragma mark - WordListDelegate

- (void)willSelectWord:(Word *)word
{
}

- (NSManagedObjectContext *)managedObjectContext
{
    WordTotalFrequencyAppDelegate *appDelegate = (WordTotalFrequencyAppDelegate *)[UIApplication sharedApplication].delegate;
    return appDelegate.managedObjectContext;
}

- (NSFetchRequest *)fetchRequest
{
    if (_fetchRequest != nil)
    {
        return _fetchRequest;
    }
    
    WordTotalFrequencyAppDelegate *appDelegate = (WordTotalFrequencyAppDelegate *)[UIApplication sharedApplication].delegate;
    _fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Word" inManagedObjectContext:appDelegate.managedObjectContext];
    [_fetchRequest setEntity:entity];
    return _fetchRequest;
}


@end
