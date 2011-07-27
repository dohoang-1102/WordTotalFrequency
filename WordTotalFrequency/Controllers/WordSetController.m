//
//  WordSetController.m
//  WordTotalFrequency
//
//  Created by OCS on 11-7-22.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "WordSetController.h"
#import "DashboardView.h"

@implementation WordSetController

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

#pragma mark - View lifecycle

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{    
    CGRect rect = [UIScreen mainScreen].bounds;
    rect = CGRectMake(0, 20, rect.size.width, rect.size.height-20);
    
    self.view = [[[DashboardView alloc] initWithFrame:rect] autorelease];
    
    _listController = [[WordListController alloc] init];
    [self.view addSubview:_listController.view];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(10, 13, 14, 17);
    [button setBackgroundImage:[UIImage imageNamed:@"arrow-back"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UISegmentedControl *segment = [[UISegmentedControl alloc]
                                   initWithItems:[NSArray arrayWithObjects:@"List", @"Test", @"History", @"Setting", nil]];
    segment.frame = CGRectMake(10, CGRectGetHeight(rect)-46, CGRectGetWidth(rect)-20, 40);
    [self.view addSubview:segment];
    [segment release];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Word Set";
}

- (void)viewDidUnload
{
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
                                            CGRectGetHeight(self.view.frame)-88);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_listController.tableView deselectRowAtIndexPath:[_listController.tableView indexPathForSelectedRow] animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
