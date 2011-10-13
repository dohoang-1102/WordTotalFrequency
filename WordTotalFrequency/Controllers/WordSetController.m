//
//  WordSetController.m
//  WordTotalFrequency
//
//  Created by OCS on 11-7-22.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "WordSetController.h"
#import "DashboardView.h"
#import "CustomProgress.h"
#import "UIColor+WTF.h"
#import "DataController.h"

typedef enum {
    CapLeft          = 0,
    CapMiddle        = 1,
    CapRight         = 2,
    CapLeftAndRight  = 3
} CapLocation;


@implementation WordSetController

@synthesize viewContainer = _viewContainer;
@synthesize wordSet = _wordSet;
@synthesize testWords = _testWords;
@synthesize currentTestWordIndex = _currentTestWordIndex;
@synthesize fetchRequest = _fetchRequest;
@synthesize wordTestView = _wordTestView;
@synthesize selectedViewIndex = _selectedViewIndex;

#define ICON_IMAGE_TAG 1
#define PERCENT_LABEL_TAG 2
#define PROGRESS_TAG 3

#define kSegmentLabelTag 99

- (void)dealloc
{
//    [self.managedObjectContext reset];
//    [NSFetchedResultsController deleteCacheWithName:nil];
    
    [_listController release];
    _listController = nil;
    
    [_historyController release];
    _historyController = nil;

    
    [_fetchRequest release];
    _fetchRequest = nil;
    [_wordTestView release];
    _wordTestView = nil;
    
    [_segmentedControl release];
    [_viewContainer release];
    [_wordSet release];
    [_testWords release];
    [super dealloc];
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)updateMarkedCount
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"category = %d and marked = 1", _wordSet.categoryId];
    [self.fetchRequest setPredicate:predicate];
    
    NSError *error;
    NSUInteger count = [[DataController sharedDataController].managedObjectContext countForFetchRequest:self.fetchRequest error:&error];
    _wordSet.markedWordCount = count;

    // update control
    [(UILabel *)[self.view viewWithTag:PERCENT_LABEL_TAG] setText:[NSString stringWithFormat:@"%d / %d", _wordSet.markedWordCount, _wordSet.totalWordCount]];
}

#pragma mark - View lifecycle

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{    
    CGRect rect = [UIScreen mainScreen].applicationFrame;
    
    self.view = [[[DashboardView alloc] initWithFrame:rect] autorelease];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 2, 44, 44);
    [button setImage:[UIImage imageNamed:@"arrow-back"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [button setShowsTouchWhenHighlighted:YES];
    [self.view addSubview:button];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(70, 7, 30, 30)];
    imageView.tag = ICON_IMAGE_TAG;
    [self.view addSubview:imageView];
    [imageView release];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(114, 4, 160, 16)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor colorForNormalText];
    label.tag = PERCENT_LABEL_TAG;
    [self.view addSubview:label];
    [label release];
    
    CustomProgress *progress = [[CustomProgress alloc] initWithFrame:CGRectMake(110, 21, 160, 13)];
    progress.tag = PROGRESS_TAG;
    [self.view addSubview:progress];
    [progress release];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 44, CGRectGetWidth(rect), 1.5)];
    line.backgroundColor = [UIColor colorWithWhite:1.f alpha:.6f];
    [self.view addSubview:line];
    [line release];
    
    _viewContainer = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                              45.5,
                                                              CGRectGetWidth(self.view.bounds),
                                                              CGRectGetHeight(self.view.bounds)-100)];
    [self.view addSubview:_viewContainer];
    
    
    UIImageView *segmentBg = [[UIImageView alloc] initWithFrame:CGRectMake(6, CGRectGetHeight(rect)-49, 309, 48)];
    segmentBg.image = [UIImage imageNamed:@"segment-bg"];
    [self.view addSubview:segmentBg];
    [segmentBg release];
    
    NSArray *titles = [NSArray arrayWithObjects:@"List", @"Test", @"History", @"Setting", nil];
    _segmentedControl = [[CustomSegmentedControl alloc]
                                                     initWithSegmentCount:titles.count
                                                     segmentsize:CGSizeMake(77, 48)
                                                     dividerImage:[UIImage imageNamed:@"segment-breaker"]
                                                     tag:1000
                                                    delegate:self];
    _segmentedControl.frame = CGRectMake(6, CGRectGetHeight(rect)-54, 308, 48);
    [self.view addSubview:_segmentedControl];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Word Set";
    
    [(UIImageView *)[self.view viewWithTag:ICON_IMAGE_TAG] setImage:[UIImage imageNamed:_wordSet.iconUrl]];
    CustomProgress *progress = (CustomProgress *)[self.view viewWithTag:PROGRESS_TAG];
    [progress setImageName:[NSString stringWithFormat:@"progress-fg-%d", _wordSet.categoryId+1]];
    progress.currentValue = _wordSet.completePercentage;
    
    _listController = [[WordListController alloc] initWIthListType:WordListTypeWordSet];
    _listController.wordSetIndex = _wordSet.categoryId;
    _listController.wordSetController = self;
    _listController.view.frame = _viewContainer.bounds;
    [_viewContainer addSubview:_listController.view];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];    
    [self updateMarkedCount];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (_selectedViewIndex == 0)
        [_listController.tableView deselectRowAtIndexPath:[_listController.tableView indexPathForSelectedRow] animated:YES];
    else if (_selectedViewIndex == 2)
        [_historyController.tableView deselectRowAtIndexPath:[_historyController.tableView indexPathForSelectedRow] animated:YES];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [_listController viewDidDisappear:NO];
    [super viewDidDisappear:animated];
}

#pragma mark - CustomSegmentedControlDelegate

- (void)touchDownAtSegmentIndex:(NSUInteger)segmentIndex
{
    for (int i=0; i<4; i++) {
        UIButton* button = (UIButton *)[_segmentedControl viewWithTag:i+10];
        UILabel *label = (UILabel *)[button viewWithTag:kSegmentLabelTag];
        if (i == segmentIndex)
        {
            label.textColor = [UIColor whiteColor];
            label.shadowOffset = CGSizeMake(0, 0);
        }
        else
        {
            label.textColor = [UIColor colorForNormalText];
            label.shadowOffset = CGSizeMake(.5, 1);
        }
    }
}

- (void)touchUpInsideSegmentIndex:(NSUInteger)segmentIndex
{
    switch (segmentIndex) {
        case 0:
            [[_viewContainer.subviews objectAtIndex:0] removeFromSuperview];
            [_viewContainer addSubview:_listController.view];
            break;
        case 1:
            [[_viewContainer.subviews objectAtIndex:0] removeFromSuperview];
            [_viewContainer addSubview:self.wordTestView];
            break;
        case 2:
            [[_viewContainer.subviews objectAtIndex:0] removeFromSuperview];
            [_viewContainer addSubview:self.historyView];
            break;
        case 3:
            break;
        default:
            break;
    }
    _selectedViewIndex = segmentIndex;
}

- (UIButton *) buttonFor:(CustomSegmentedControl*)segmentedControl atIndex:(NSUInteger)segmentIndex;
{
//    NSUInteger dataOffset = segmentedControl.tag - TAG_VALUE ;
//    NSDictionary* data = [buttons objectAtIndex:dataOffset];
    NSArray *titles = [NSArray arrayWithObjects:@"List", @"Test", @"History", @"Setting", nil];
    
    CapLocation location;
    if (segmentIndex == 0)
        location = CapLeft;
    else if (segmentIndex == titles.count - 1)
        location = CapRight;
    else
        location = CapMiddle;
    
    UIImage* buttonImage = nil;
    UIImage* buttonPressedImage = nil;
    
    CGFloat capWidth = 0;
    CGSize buttonSize = CGSizeMake(77, 48);
    
    if (location == CapLeft)
    {
        buttonPressedImage = [[UIImage imageNamed:@"segment-left-pressed"] stretchableImageWithLeftCapWidth:capWidth topCapHeight:0.0];
    }
    else if (location == CapRight)
    {
        buttonPressedImage = [[UIImage imageNamed:@"segment-right-pressed"] stretchableImageWithLeftCapWidth:capWidth topCapHeight:0.0];
    }
    else
    {
        buttonPressedImage = [[UIImage imageNamed:@"segment-middle-pressed"] stretchableImageWithLeftCapWidth:capWidth topCapHeight:0.0];
    }
    
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0.0, 0.0, buttonSize.width, buttonSize.height);
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 8, buttonSize.width, 40)];
    label.tag = kSegmentLabelTag;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:16];
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor colorForNormalText];
    label.shadowColor = [UIColor whiteColor];
    label.shadowOffset = CGSizeMake(.5, 1);
    label.text = [titles objectAtIndex:segmentIndex];
    [button addSubview:label];
    [label release];
    
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setBackgroundImage:buttonPressedImage forState:UIControlStateHighlighted];
    [button setBackgroundImage:buttonPressedImage forState:UIControlStateSelected];
    button.adjustsImageWhenHighlighted = NO;
    
    if (segmentIndex == 0)
    {
        button.selected = YES;
        label.textColor = [UIColor whiteColor];
        label.shadowOffset = CGSizeMake(0, 0);
    }
    return button;
}

- (NSFetchRequest *)fetchRequest
{
    if (_fetchRequest != nil)
    {
        return _fetchRequest;
    }
    
    _fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Word"
                                              inManagedObjectContext:[DataController sharedDataController].managedObjectContext];
    [_fetchRequest setEntity:entity];
    return _fetchRequest;
}

#pragma mark - segmented views

- (WordTestView *)wordTestView
{
    if (_wordTestView == nil)
    {
        _wordTestView = [[WordTestView alloc] initWithFrame:_viewContainer.bounds];
        _wordTestView.wordSetController = self;
    }
    return _wordTestView;
}

- (UIView *)historyView
{
    if (_historyController == nil)
    {
        _historyController = [[WordListController alloc] initWIthListType:WordListTypeHistory];
        _historyController.wordSetIndex = _wordSet.categoryId;
        _historyController.wordSetController = self;
        _historyController.view.frame = _viewContainer.bounds;
    }
    return _historyController.view;
}

@end
