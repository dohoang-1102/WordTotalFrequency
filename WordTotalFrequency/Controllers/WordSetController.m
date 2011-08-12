//
//  WordSetController.m
//  WordTotalFrequency
//
//  Created by OCS on 11-7-22.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "WordSetController.h"
#import "DashboardView.h"
#import "OCProgress.h"
#import "UIColor+WTF.h"
#import "WordTotalFrequencyAppDelegate.h"

@implementation WordSetController

@synthesize wordSet = _wordSet;

#define ICON_IMAGE_TAG 1
#define PERCENT_LABEL_TAG 2
#define PROGRESS_TAG 3

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
    [_listController release];
    [_wordSet release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)updateMarkedCount
{
    WordTotalFrequencyAppDelegate *appDelegate = (WordTotalFrequencyAppDelegate *)[UIApplication sharedApplication].delegate;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Word" inManagedObjectContext:appDelegate.managedObjectContext];
    [request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"category = %d and marked = 1", _wordSet.categoryId];
    [request setPredicate:predicate];
    
    NSError *error;
    NSUInteger count = [appDelegate.managedObjectContext countForFetchRequest:request error:&error];
    _wordSet.markedWordCount = count;
    [request release];

    // update control
    [(UILabel *)[self.view viewWithTag:PERCENT_LABEL_TAG] setText:[NSString stringWithFormat:@"%d / %d", _wordSet.markedWordCount, _wordSet.totalWordCount]];
}

#pragma mark - View lifecycle

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{    
    CGRect rect = [UIScreen mainScreen].bounds;
    rect = CGRectMake(0, 20, rect.size.width, rect.size.height-20);
    
    self.view = [[[DashboardView alloc] initWithFrame:rect] autorelease];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(14, 13, 12, 15);
    [button setBackgroundImage:[UIImage imageNamed:@"arrow-back"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
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
    
    OCProgress *progress = [[OCProgress alloc] initWithFrame:CGRectMake(110, 21, 160, 16)];
    progress.minValue = 0;
    progress.maxValue = 100;
    progress.tag = PROGRESS_TAG;
    progress.progressRemainingColor = [UIColor colorWithHex:0x337fc8];
    progress.lineColor = [UIColor colorWithHex:0x337fc8];
    [self.view addSubview:progress];
    [progress release];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 44, CGRectGetWidth(rect), 1.5)];
    line.backgroundColor = [UIColor colorWithWhite:1.f alpha:.6f];
    [self.view addSubview:line];
    [line release];
    
    UISegmentedControl *segment = [[UISegmentedControl alloc]
                                   initWithItems:[NSArray arrayWithObjects:@"List", @"Test", @"History", @"Setting", nil]];
    segment.frame = CGRectMake(10, CGRectGetHeight(rect)-46, CGRectGetWidth(rect)-20, 40);
    segment.selectedSegmentIndex = 0;
    [self.view addSubview:segment];
    [segment release];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Word Set";
    
    [(UIImageView *)[self.view viewWithTag:ICON_IMAGE_TAG] setImage:[UIImage imageNamed:_wordSet.iconUrl]];
    OCProgress *progress = (OCProgress *)[self.view viewWithTag:PROGRESS_TAG];
    progress.currentValue = _wordSet.completePercentage;
    progress.progressColor = _wordSet.color;
    
    _listController = [[WordListController alloc] init];
    _listController.wordSetIndex = _wordSet.categoryId;
    _listController.wordSetController = self;
    [self.view addSubview:_listController.view];
}

- (void)viewDidUnload
{
    [_listController viewDidUnload];
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _listController.view.frame = CGRectMake(0,
                                            44,
                                            CGRectGetWidth(self.view.frame),
                                            CGRectGetHeight(self.view.frame)-94);
    
    [self updateMarkedCount];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_listController.tableView reloadData];
    [_listController.tableView deselectRowAtIndexPath:[_listController.tableView indexPathForSelectedRow] animated:YES];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [_listController viewDidDisappear:NO];
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
