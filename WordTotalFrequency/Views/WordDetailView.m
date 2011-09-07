//
//  WordDetailView.m
//  WordTotalFrequency
//
//  Created by Perry on 11-8-12.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "WordDetailView.h"
#import "UIColor+WTF.h"

@implementation WordDetailView

#define MARK_ICON_TAG 1
#define SPELL_LABEL_TAG 2
#define PHONETIC_LABEL_TAG 3
#define DETAIL_LABEL_TAG 4
#define SPEAKER_TAG 5
#define SCROLLVIEW_TAG 6

@synthesize word = _word;
@synthesize wordDetailController = _wordDetailController;
@synthesize player = _player;

- (void)markAction:(UIGestureRecognizer *)gestureRecognizer
{
    BOOL marked = [_word.marked boolValue];
    _word.marked = [NSNumber numberWithBool:!marked];
    
    if ([_word.marked boolValue])
        [(UIButton *)[self viewWithTag:MARK_ICON_TAG] setBackgroundImage:[UIImage imageNamed:@"mark-circle"] forState:UIControlStateNormal];
    else
        [(UIButton *)[self viewWithTag:MARK_ICON_TAG] setBackgroundImage:[UIImage imageNamed:@"mark-circle-gray"] forState:UIControlStateNormal];
}

- (void)speakAction
{
    if (_player)
        [_player play];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 2, 44, 44);
        [button setImage:[UIImage imageNamed:@"arrow-back"] forState:UIControlStateNormal];
        [button addTarget:self.wordDetailController action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(92, 0, 170, 44)];
        [self addSubview:view];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(markAction:)];
        [view addGestureRecognizer:tapGesture];
        [tapGesture release];
        
        UIButton *mark = [UIButton buttonWithType:UIButtonTypeCustom];
        mark.frame = CGRectMake(0, 16, 12, 13);
        mark.tag = MARK_ICON_TAG;
        mark.userInteractionEnabled = NO;
        [view addSubview:mark];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(21, 4, 155, 32)];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:28];
        label.textColor = [UIColor colorForNormalText];
        label.adjustsFontSizeToFitWidth = YES;
        label.tag = SPELL_LABEL_TAG;
        label.shadowColor = [UIColor whiteColor];
        label.shadowOffset = CGSizeMake(.5, 1);
        [view addSubview:label];
        [label release];
        
        [view release];
        
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 44, CGRectGetWidth(frame), 1.5)];
        line.backgroundColor = [UIColor colorWithWhite:1.f alpha:.6f];
        [self addSubview:line];
        [line release];
        
        UIButton *speaker = [UIButton buttonWithType:UIButtonTypeCustom];
        speaker.frame = CGRectMake(255, 22, 47, 47);
        speaker.tag = SPEAKER_TAG;
        [speaker setBackgroundImage:[UIImage imageNamed:@"speaker"] forState:UIControlStateNormal];
        [speaker addTarget:self action:@selector(speakAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:speaker];
        
        UILabel *phonetic = [[UILabel alloc] initWithFrame:CGRectMake(10, 70, 200, 20)];
        phonetic.backgroundColor = [UIColor clearColor];
        phonetic.textColor = [UIColor colorForNormalText];
        phonetic.tag = PHONETIC_LABEL_TAG;
        [self addSubview:phonetic];
        [phonetic release];
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 100, 300, 300)];
        scrollView.tag = SCROLLVIEW_TAG;
        [self addSubview:scrollView];
        
        UILabel *detail = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(scrollView.frame), CGRectGetHeight(scrollView.frame))];
        detail.backgroundColor = [UIColor clearColor];
        detail.textColor = [UIColor colorForNormalText];
        detail.numberOfLines = 0;
        detail.tag = DETAIL_LABEL_TAG;
        detail.shadowColor = [UIColor whiteColor];
        detail.shadowOffset = CGSizeMake(.5, 1);
        [scrollView addSubview:detail];
        [detail release];
        [scrollView release];
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
    [_word release];
    [_player release];
    [super dealloc];
}

- (void)updateWordData
{
    if ([_word.marked boolValue])
        [(UIButton *)[self viewWithTag:MARK_ICON_TAG] setBackgroundImage:[UIImage imageNamed:@"mark-circle"] forState:UIControlStateNormal];
    else
        [(UIButton *)[self viewWithTag:MARK_ICON_TAG] setBackgroundImage:[UIImage imageNamed:@"mark-circle-gray"] forState:UIControlStateNormal];
    
    [(UILabel *)[self viewWithTag:SPELL_LABEL_TAG] setText:_word.spell];
    [(UILabel *)[self viewWithTag:PHONETIC_LABEL_TAG] setText:_word.phonetic];
    
    // detail translate
    UIScrollView *scrollView = (UIScrollView *)[self viewWithTag:SCROLLVIEW_TAG];
    UILabel *label = (UILabel *)[scrollView viewWithTag:DETAIL_LABEL_TAG];
    CGRect frame = label.frame;
    CGSize maximumSize = CGSizeMake(CGRectGetWidth(frame), 9999);
    CGSize size = [_word.detail sizeWithFont:label.font constrainedToSize:maximumSize lineBreakMode:label.lineBreakMode];
    frame = CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(frame), CGRectGetWidth(frame), size.height);
    label.frame = frame;
    [(UILabel *)[self viewWithTag:DETAIL_LABEL_TAG] setText:_word.detail];
    
    if (size.height > scrollView.bounds.size.height)
        scrollView.contentSize = size;
    
    
    
    NSArray *files = [_word.soundFile componentsSeparatedByString:@" "];
    NSString *file = [files objectAtIndex:0];
    file = [[[file lastPathComponent] stringByDeletingPathExtension]
            stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if (file && [file length] > 0)
    {
//        NSLog(@"mp3 file: %@", file);
//        NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: [[NSBundle mainBundle] pathForResource:file ofType:@"mp3"]];
//        AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
//        self.player = audioPlayer;
//        [fileURL release];
//        [audioPlayer release];
//        [self.player prepareToPlay];
    }
    else
    {
        [self viewWithTag:SPEAKER_TAG].hidden = YES;
    }
}

@end
