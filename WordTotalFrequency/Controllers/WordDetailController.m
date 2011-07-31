//
//  WordDetailController.m
//  WordTotalFrequency
//
//  Created by OCS on 11-7-27.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "WordDetailController.h"
#import "DashboardView.h"
#import "UIColor+WTF.h"

@implementation WordDetailController

@synthesize word = _word;

#define MARK_ICON_TAG 1
#define SPELL_LABEL_TAG 2
#define PHONETIC_LABEL_TAG 3
#define DETAIL_LABEL_TAG 4

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
    [_word release];
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

- (void)speakAction
{
    
}

#pragma mark - View lifecycle

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    CGRect rect = [UIScreen mainScreen].bounds;
    rect = CGRectMake(0, 20, rect.size.width, rect.size.height-20);
    
    self.view = [[[DashboardView alloc] initWithFrame:rect] autorelease];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(10, 13, 12, 15);
    [button setBackgroundImage:[UIImage imageNamed:@"arrow-back"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIButton *mark = [UIButton buttonWithType:UIButtonTypeCustom];
    mark.frame = CGRectMake(92, 20, 8, 9);
    mark.tag = MARK_ICON_TAG;
    mark.userInteractionEnabled = NO;
    [self.view addSubview:mark];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(110, 4, 160, 32)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:28];
    label.textColor = [UIColor colorForNormalText];
    label.tag = SPELL_LABEL_TAG;
    [self.view addSubview:label];
    [label release];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 44, CGRectGetWidth(rect), 1.5)];
    line.backgroundColor = [UIColor colorWithWhite:1.f alpha:.6f];
    [self.view addSubview:line];
    [line release];
    
    UIButton *speaker = [UIButton buttonWithType:UIButtonTypeCustom];
    speaker.frame = CGRectMake(255, 22, 47, 47);
    [speaker setBackgroundImage:[UIImage imageNamed:@"speaker"] forState:UIControlStateNormal];
    [speaker addTarget:self action:@selector(speakAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:speaker];
    
    UILabel *phonetic = [[UILabel alloc] initWithFrame:CGRectMake(10, 70, 200, 20)];
    phonetic.backgroundColor = [UIColor clearColor];
    phonetic.textColor = [UIColor colorForNormalText];
    phonetic.tag = PHONETIC_LABEL_TAG;
    [self.view addSubview:phonetic];
    [phonetic release];
    
    UILabel *detail = [[UILabel alloc] initWithFrame:CGRectMake(10, 100, 300, 300)];
    detail.backgroundColor = [UIColor clearColor];
    detail.textColor = [UIColor colorForNormalText];
    detail.numberOfLines = 0;
    detail.tag = DETAIL_LABEL_TAG;
    [self.view addSubview:detail];
    [detail release];
    
    UISegmentedControl *segment = [[UISegmentedControl alloc]
                                   initWithItems:[NSArray arrayWithObjects:@"Last", @"Mark as remembered", @"Next",nil]];
    segment.frame = CGRectMake(10, CGRectGetHeight(rect)-46, CGRectGetWidth(rect)-20, 40);
    [self.view addSubview:segment];
    [segment release];
}

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([_word.marked boolValue])
        [(UIButton *)[self.view viewWithTag:MARK_ICON_TAG] setBackgroundImage:[UIImage imageNamed:@"mark-circle"] forState:UIControlStateNormal];
    else
        [(UIButton *)[self.view viewWithTag:MARK_ICON_TAG] setBackgroundImage:[UIImage imageNamed:@"mark-circle-gray"] forState:UIControlStateNormal];
    
    [(UILabel *)[self.view viewWithTag:SPELL_LABEL_TAG] setText:_word.spell];
    [(UILabel *)[self.view viewWithTag:PHONETIC_LABEL_TAG] setText:_word.phonetic];
    
    // detail translate
    NSArray *array = [_word.detail componentsSeparatedByString:@"\n"];
    NSMutableString *detail = [[NSMutableString alloc] initWithCapacity:0];
    int count = 0;
    for (NSString *string in array) {
        [detail appendFormat:@"%d. %@\n", ++count, string];
    }
    UILabel *label = (UILabel *)[self.view viewWithTag:DETAIL_LABEL_TAG];
    CGRect frame = label.frame;
    CGSize maximumSize = CGSizeMake(CGRectGetWidth(frame), 9999);
    CGSize size = [detail sizeWithFont:label.font constrainedToSize:maximumSize lineBreakMode:label.lineBreakMode];
    frame = CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(frame), CGRectGetWidth(frame), size.height);
    label.frame = frame;
    [(UILabel *)[self.view viewWithTag:DETAIL_LABEL_TAG] setText:detail];
    [detail release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
