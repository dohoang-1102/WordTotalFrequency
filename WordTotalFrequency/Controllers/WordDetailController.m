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
@synthesize wordListController = _wordListController;

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

- (void)dealloc
{
    [_word release];
    [_words release];
    [super dealloc];
}

- (void)backAction
{
    if (self.wordListController &&
        _currentWordIndex != [self.wordListController.tableView indexPathForSelectedRow].row)
    {
        NSUInteger ii[2] = {0, _currentWordIndex};
        NSIndexPath* indexPath = [NSIndexPath indexPathWithIndexes:ii length:2];
        [self.wordListController.tableView reloadData];
        [self.wordListController.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionTop];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)swipeAction:(UISwipeGestureRecognizer *)recognizer
{
    if (_wordSetIndex < 0) return;
    
    if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft)
    {
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
    
    WordDetailView *view =  [[self.view subviews] objectAtIndex:0];
    view.word = _word;
    [view updateWordData];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.words = nil;
}

@end
