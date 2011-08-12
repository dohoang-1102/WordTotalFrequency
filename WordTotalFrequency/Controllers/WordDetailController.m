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
#import "WordTotalFrequencyAppDelegate.h"
#import "WordDetailView.h"

@implementation WordDetailController

@synthesize word = _word;
@synthesize words = _words;
@synthesize wordSetIndex = _wordSetIndex;
@synthesize currentWordIndex = _currentWordIndex;

#define MARK_ICON_TAG 1
#define SPELL_LABEL_TAG 2
#define PHONETIC_LABEL_TAG 3
#define DETAIL_LABEL_TAG 4

- (id)init
{
    if ((self = [super init]))
    {
        _wordSetIndex = -1;
    }
    return self;
}

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
    [_words release];
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

- (void)swipeAction:(UISwipeGestureRecognizer *)recognizer
{
    if (_wordSetIndex < 0) return;
    
    if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        NSLog(@"swipe left");
        if (_currentWordIndex < [self.words count]-1)
        {
            CGRect rect = self.view.bounds;
            rect.origin.x += CGRectGetWidth(rect);
            WordDetailView *view = [[WordDetailView alloc] initWithFrame:rect];
            [self.view addSubview:view];
            
            WordDetailView *oldView =  [[self.view subviews] objectAtIndex:0];
            [UIView transitionWithView:self.view duration:0.5
                               options:UIViewAnimationOptionCurveEaseInOut
                            animations:^ {
                                view.frame = self.view.bounds;
                                oldView.frame = CGRectMake(-CGRectGetWidth(rect), rect.origin.y, CGRectGetWidth(rect), CGRectGetHeight(rect));
                            }
                            completion:^(BOOL finished) {
                                if (finished)
                                    [oldView removeFromSuperview];
                            }];
            
            self.word = [self.words objectAtIndex:++_currentWordIndex];
            view.word = self.word;
            [view updateWordData];
            [view release];
        }
    }
    else
    {
        NSLog(@"swiped right");
        if (_currentWordIndex > 0)
        {
            CGRect rect = self.view.bounds;
            rect.origin.x -= CGRectGetWidth(rect);
            WordDetailView *view = [[WordDetailView alloc] initWithFrame:rect];
            [self.view addSubview:view];
            
            WordDetailView *oldView =  [[self.view subviews] objectAtIndex:0];
            [UIView transitionWithView:self.view duration:0.5
                               options:UIViewAnimationOptionCurveEaseInOut
                            animations:^ {
                                view.frame = self.view.bounds;
                                oldView.frame = CGRectMake(CGRectGetWidth(rect), rect.origin.y, CGRectGetWidth(rect), CGRectGetHeight(rect));
                            }
                            completion:^(BOOL finished) {
                                if (finished)
                                    [oldView removeFromSuperview];
                            }];
            
            self.word = [self.words objectAtIndex:--_currentWordIndex];
            view.word = self.word;
            [view updateWordData];
            [view release];
        }
    }
}

#pragma mark - View lifecycle

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    CGRect rect = [[UIScreen mainScreen] bounds];
    
    self.view = [[[DashboardView alloc] initWithFrame:rect] autorelease];
    
    WordDetailView *view = [[WordDetailView alloc] initWithFrame:rect];
    [self.view addSubview:view];
    [view release];
    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.frame = CGRectMake(10, 13, 12, 15);
//    [button setBackgroundImage:[UIImage imageNamed:@"arrow-back"] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:button];
//    
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(92, 0, 170, 44)];
//    [self.view addSubview:view];
//    
//    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(markAction:)];
//    [view addGestureRecognizer:tapGesture];
//    [tapGesture release];
//    
//    UIButton *mark = [UIButton buttonWithType:UIButtonTypeCustom];
//    mark.frame = CGRectMake(0, 20, 8, 9);
//    mark.tag = MARK_ICON_TAG;
//    mark.userInteractionEnabled = NO;
//    [view addSubview:mark];
//    
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(18, 4, 160, 32)];
//    label.backgroundColor = [UIColor clearColor];
//    label.font = [UIFont systemFontOfSize:28];
//    label.textColor = [UIColor colorForNormalText];
//    label.tag = SPELL_LABEL_TAG;
//    [view addSubview:label];
//    [label release];
//    
//    [view release];
//    
//    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 44, CGRectGetWidth(rect), 1.5)];
//    line.backgroundColor = [UIColor colorWithWhite:1.f alpha:.6f];
//    [self.view addSubview:line];
//    [line release];
//    
//    UIButton *speaker = [UIButton buttonWithType:UIButtonTypeCustom];
//    speaker.frame = CGRectMake(255, 22, 47, 47);
//    [speaker setBackgroundImage:[UIImage imageNamed:@"speaker"] forState:UIControlStateNormal];
//    [speaker addTarget:self action:@selector(speakAction) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:speaker];
//    
//    UILabel *phonetic = [[UILabel alloc] initWithFrame:CGRectMake(10, 70, 200, 20)];
//    phonetic.backgroundColor = [UIColor clearColor];
//    phonetic.textColor = [UIColor colorForNormalText];
//    phonetic.tag = PHONETIC_LABEL_TAG;
//    [self.view addSubview:phonetic];
//    [phonetic release];
//    
//    UILabel *detail = [[UILabel alloc] initWithFrame:CGRectMake(10, 100, 300, 300)];
//    detail.backgroundColor = [UIColor clearColor];
//    detail.textColor = [UIColor colorForNormalText];
//    detail.numberOfLines = 0;
//    detail.tag = DETAIL_LABEL_TAG;
//    [self.view addSubview:detail];
//    [detail release];
    
    UISwipeGestureRecognizer *recognizer;
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeAction:)];
    recognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    recognizer.delegate = self;
    [self.view addGestureRecognizer:recognizer];
    [recognizer release];
    
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeAction:)];
    recognizer.direction = UISwipeGestureRecognizerDirectionRight;
    recognizer.delegate = self;
    [self.view addGestureRecognizer:recognizer];
    [recognizer release];
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
    
    if (_wordSetIndex > -1)
    {
        // retrieve data
        WordTotalFrequencyAppDelegate *appDelegate = (WordTotalFrequencyAppDelegate *)[UIApplication sharedApplication].delegate;
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Word" inManagedObjectContext:appDelegate.managedObjectContext];
        [request setEntity:entity];
        [request setFetchBatchSize:20];
        
        // Create the sort descriptors array.
        NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"rank" ascending:YES];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:descriptor, nil];
        [descriptor release];
        [request setSortDescriptors:sortDescriptors];
        [sortDescriptors release];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"category = %d", _wordSetIndex];
        [request setPredicate:predicate];
        
        NSError *error;
        self.words = [appDelegate.managedObjectContext executeFetchRequest:request error:&error];
        [request release];
    }
    
    WordDetailView *view =  [[self.view subviews] objectAtIndex:0];
    view.word = _word;
    [view updateWordData];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.words = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
