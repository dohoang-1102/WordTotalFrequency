//
//  WordTestView.m
//  WordTotalFrequency
//
//  Created by Perry on 11-8-15.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "WordTestView.h"
#import "WordSetController.h"


@implementation WordTestView

@synthesize wordSetController = _wordSetController;

- (NSArray *)getTestOptionsWithAnswer:(NSString *)answer atIndex:(NSUInteger)answerIndex
{
    NSMutableArray *array = [NSMutableArray arrayWithObjects:
                             [[_wordSetController.testWords objectAtIndex:rand()%_wordSetController.wordSet.totalWordCount] translate],
                             [[_wordSetController.testWords objectAtIndex:rand()%_wordSetController.wordSet.totalWordCount] translate],
                             [[_wordSetController.testWords objectAtIndex:rand()%_wordSetController.wordSet.totalWordCount] translate],
                             nil];
    [array insertObject:answer atIndex:answerIndex];
    return array;
}

- (void)setWordSetController:(WordSetController *)wordSetController
{
    _wordSetController = wordSetController;
    
    if (_paperView)
    {
        [_paperView removeFromSuperview];
        [_paperView release];
        _paperView = nil;
    }
    
    Word *word = [_wordSetController.testWords objectAtIndex:_wordSetController.currentTestWordIndex];
    WordSet *wordSet = [_wordSetController wordSet];
    int answerIndex = rand()%4;
    NSArray *options = [self getTestOptionsWithAnswer:word.translate atIndex:answerIndex];
    _paperView = [[WordPaperView alloc] initWithFrame:_containerView.bounds
                                                 word:word.spell
                                              options:options
                                               answer:answerIndex
                                               footer:[NSString stringWithFormat:@"%d/%d", _wordSetController.currentTestWordIndex+1, wordSet.totalWordCount]];
    _paperView.backgroundColor = [UIColor whiteColor];
    [_containerView addSubview:_paperView];
}

- (void)swipeAction:(UISwipeGestureRecognizer *)recognizer
{
    if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        if (_wordSetController.currentTestWordIndex == _wordSetController.wordSet.totalWordCount-1) return;
        _wordSetController.currentTestWordIndex++;
        
        [UIView transitionWithView:_containerView duration:0.5
                           options:UIViewAnimationOptionTransitionCurlUp
                        animations:^ { [_paperView removeFromSuperview]; }
                        completion:^(BOOL finished) {
                            if (finished)
                            {
                                Word *word = [_wordSetController.testWords objectAtIndex:_wordSetController.currentTestWordIndex];
                                WordSet *wordSet = [_wordSetController wordSet];
                                int answerIndex = rand()%4;
                                NSArray *options = [self getTestOptionsWithAnswer:word.translate atIndex:answerIndex];
                                _paperView = [[WordPaperView alloc] initWithFrame:_containerView.bounds
                                                                             word:word.spell
                                                                          options:options
                                                                           answer:answerIndex
                                                                           footer:[NSString stringWithFormat:@"%d/%d", _wordSetController.currentTestWordIndex+1, wordSet.totalWordCount]];
                                _paperView.backgroundColor = [UIColor whiteColor];
                                [_containerView addSubview:_paperView];
                            }
                        }];

        [_paperView release];
        _paperView = nil;
    }
    else
    {
        if (_wordSetController.currentTestWordIndex == 0) return;
        _wordSetController.currentTestWordIndex--;
        
        [_paperView removeFromSuperview];
        [_paperView release];
        _paperView = nil;
        
        Word *word = [_wordSetController.testWords objectAtIndex:_wordSetController.currentTestWordIndex];
        WordSet *wordSet = [_wordSetController wordSet];
        int answerIndex = rand()%4;
        NSArray *options = [self getTestOptionsWithAnswer:word.translate atIndex:answerIndex];
        _paperView = [[WordPaperView alloc] initWithFrame:_containerView.bounds
                                                     word:word.spell
                                                  options:options
                                                   answer:answerIndex
                                                   footer:[NSString stringWithFormat:@"%d/%d", _wordSetController.currentTestWordIndex+1, wordSet.totalWordCount]];
        _paperView.backgroundColor = [UIColor whiteColor];
        
        [UIView transitionWithView:_containerView duration:0.5
                           options:UIViewAnimationOptionTransitionCurlDown
                        animations:^ { [_containerView addSubview:_paperView]; }
                        completion:nil];
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGRect rect = CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame));
        
        UIImage *image = [UIImage imageNamed:@"paper"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = CGRectMake((rect.size.width-image.size.width)/2.0, (rect.size.height-image.size.height)/2.0, image.size.width, image.size.height);
        [self addSubview:imageView];
        [imageView release];
        
        UISwipeGestureRecognizer *recognizer;
        recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeAction:)];
        recognizer.direction = UISwipeGestureRecognizerDirectionLeft;
        recognizer.delegate = self;
        [self addGestureRecognizer:recognizer];
        [recognizer release];
        
        recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeAction:)];
        recognizer.direction = UISwipeGestureRecognizerDirectionRight;
        recognizer.delegate = self;
        [self addGestureRecognizer:recognizer];
        [recognizer release];
        
        _containerView = [[UIView alloc] initWithFrame:CGRectMake(23, 18, 270, 328)];
        [self addSubview:_containerView];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc
{
    if (_paperView)
    {
        [_paperView release];
        _paperView = nil;
    }
    [_containerView release];
    [super dealloc];
}

@end
