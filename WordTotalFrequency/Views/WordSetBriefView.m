//
//  WordSetBriefView.m
//  WordTotalFrequency
//
//  Created by OCS on 11-7-23.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "WordSetBriefView.h"
#import "UIColor+WTF.h"
#import "WordSetController.h"

@implementation WordSetBriefView

@synthesize tableView = _tableView;
@synthesize dashboardController = _dashboardController;

- (void)navigateToWordSetController
{
    WordSetController *wsc = [[WordSetController alloc] init];
    wsc.wordSet = _wordSet;
    [self.dashboardController.navigationController pushViewController:wsc animated:YES];
    [wsc release];
}

- (void)fadeSelectedBackground
{
    _backgroundImage.image = [UIImage imageNamed:@"word-set-bg"];
}

- (void)wordSetBriefTapped:(UIGestureRecognizer *)gestureRecognizer
{
    _backgroundImage.image = [UIImage imageNamed:@"word-set-selected-bg"];
    
    [self performSelector:@selector(navigateToWordSetController) withObject:nil afterDelay:.15];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat top = 15.f;
        CGFloat margin = 10.f;
        
        // separator layer
        _arrowLayer = [[CAArrowShapeLayer alloc] init];
        _arrowLayer.bounds = CGRectMake(0, 0, 600, CGRectGetHeight(frame));
        _arrowLayer.position = CGPointMake(CGRectGetWidth(frame)/2, CGRectGetHeight(frame)/2);
        self.layer.masksToBounds = YES;
        [self.layer addSublayer:_arrowLayer];
        
        _backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"word-set-bg"]];
        _backgroundImage.frame = CGRectMake(0, 8.5, frame.size.width, 106);
        [self addSubview:_backgroundImage];
        
        _countlabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _countlabel.backgroundColor = [UIColor clearColor];
        _countlabel.frame = CGRectMake(margin, top+4, 80, 44);
        _countlabel.font = [UIFont systemFontOfSize:36];
        _countlabel.adjustsFontSizeToFitWidth = YES;
        _countlabel.textColor = [UIColor colorForNormalText];
        _countlabel.textAlignment = UITextAlignmentCenter;
        _countlabel.shadowColor = [UIColor whiteColor];
        _countlabel.shadowOffset = CGSizeMake(0, 1.5);
        _countlabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        [self addSubview:_countlabel];
        
        _countNoteLabel = [[MTLabel alloc] initWithFrame:CGRectZero];
        _countNoteLabel.backgroundColor = [UIColor clearColor];
        _countNoteLabel.frame = CGRectMake(margin+80, top+4, 80, 60);
        _countNoteLabel.font = [UIFont systemFontOfSize:12];
        _countNoteLabel.numberOfLines = 0;
        _countNoteLabel.text = @"words\nmarked as\nremembered";
        [_countNoteLabel setFontColor:[UIColor colorForNormalText]];
        [_countNoteLabel setLineHeight:12];
        _countNoteLabel.textAlignment = UITextAlignmentLeft;
        [self addSubview:_countNoteLabel];
        
        _percentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _percentLabel.backgroundColor = [UIColor clearColor];
        _percentLabel.frame = CGRectMake(margin+160, top+5, 140, 22);
        _percentLabel.font = [UIFont boldSystemFontOfSize:20];
        _percentLabel.text = @"";
        _percentLabel.textColor = [UIColor colorForNormalText];
        _percentLabel.textAlignment = UITextAlignmentRight;
        _percentLabel.shadowColor = [UIColor whiteColor];
        _percentLabel.shadowOffset = CGSizeMake(.5, 1);
        [self addSubview:_percentLabel];
        
        _progress = [[CustomProgress alloc] initWithFrame:CGRectMake(margin+160, top+30, 140, 13)];
        [self addSubview:_progress];
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(margin, top+46, 300, 70) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.userInteractionEnabled = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self addSubview:_tableView];
        
        // Tap Gesture
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]
                                           initWithTarget:self action:@selector(wordSetBriefTapped:)];
        [self addGestureRecognizer:gesture];
        [gesture release];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    _arrowLayer.bounds = CGRectMake(0, 0, 600, CGRectGetHeight(frame));
    _arrowLayer.position = CGPointMake(_arrowLayer.position.x, CGRectGetHeight(frame)/2);
    [_arrowLayer setNeedsDisplay];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (WordSet *)wordSet
{
    return _wordSet;
}

- (void)setWordSet:(WordSet *)wordSet
{
    if (_wordSet != wordSet)
    {
        [_wordSet release];
        _wordSet = [wordSet retain];
        
        [self updateDisplay];
    }
}

- (void)updateDisplay
{
    _arrowLayer.strokeColor = _wordSet.color;
    _countlabel.text = [NSString stringWithFormat:@"%d", _wordSet.markedWordCount];
    _countlabel.textColor = _wordSet.color;
    [_percentLabel setText:[NSString stringWithFormat:@"%d%%", _wordSet.completePercentage]];
    [_progress setImageName:[NSString stringWithFormat:@"progress-fg-%d", _wordSet.categoryId+1]];
    _progress.currentValue = _wordSet.completePercentage;
    [_tableView reloadData];
    
    [_arrowLayer setNeedsDisplay];
}

- (void)centerArrowToX:(CGFloat)x
{
    CGPoint point = _arrowLayer.position;
    point.x = x;
    _arrowLayer.position = point;
}

- (void)dealloc
{
    [_countlabel release];
    [_countNoteLabel release];
    [_percentLabel release];
    [_progress release];
    [_tableView release];
    [_arrowLayer release];
    [_backgroundImage release];
    
    [_wordSet release];
    [super dealloc];
}

#pragma mark - UITableViewDataSource & Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 56;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.textLabel.textColor = [UIColor colorForNormalText];
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.backgroundColor = [UIColor yellowColor];
        cell.textLabel.frame = CGRectMake(0, 0, 260, 70);
        cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
        cell.textLabel.shadowColor = [UIColor whiteColor];
        cell.textLabel.shadowOffset = CGSizeMake(.5, 1);
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    }
    
    cell.textLabel.text = _wordSet.description;        
    return cell;
}

@end
