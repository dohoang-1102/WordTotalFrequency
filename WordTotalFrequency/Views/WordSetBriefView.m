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
@synthesize wordSet = _wordSet;
@synthesize dashboardController = _dashboardController;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat top = 15.f;
        CGFloat margin = 10.f;
        
        // separator layer
        _arrowLayer = [[CAArrowShapeLayer alloc] init];
        _arrowLayer.bounds = CGRectMake(0, 0, 600, 70);
        _arrowLayer.position = CGPointMake(150, 35);
        self.layer.masksToBounds = YES;
        [self.layer addSublayer:_arrowLayer];
        
        _countlabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _countlabel.backgroundColor = [UIColor clearColor];
        _countlabel.frame = CGRectMake(margin, top, 80, 44);
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
        _countNoteLabel.frame = CGRectMake(margin+80, top, 80, 60);
        _countNoteLabel.font = [UIFont systemFontOfSize:12];
        _countNoteLabel.numberOfLines = 0;
        _countNoteLabel.text = @"words\nmarkedas\nremembered";
        [_countNoteLabel setFontColor:[UIColor colorForNormalText]];
        [_countNoteLabel setLineHeight:12];
        _countNoteLabel.textAlignment = UITextAlignmentLeft;
        [self addSubview:_countNoteLabel];
        
        _percentLabel = [[MTLabel alloc] initWithFrame:CGRectZero];
        _percentLabel.backgroundColor = [UIColor clearColor];
        _percentLabel.frame = CGRectMake(margin+160, top, 140, 22);
        _percentLabel.font = [UIFont systemFontOfSize:20];
        _percentLabel.text = @"";
        [_percentLabel setFontColor:[UIColor colorForNormalText]];
        [_percentLabel setLineHeight:22];
        [self addSubview:_percentLabel];
        
        _progress = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
        _progress.frame = CGRectMake(margin+160, top+24, 140, 24);
        [self addSubview:_progress];
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(margin, top+50, 300, 70) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self addSubview:_tableView];
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

- (void)setWordSet:(WordSet *)wordSet
{
    if (_wordSet != wordSet)
    {
        [_wordSet release];
        _wordSet = [wordSet retain];
        
        _arrowLayer.strokeColor = _wordSet.color;
        _countlabel.text = [NSString stringWithFormat:@"%d", _wordSet.markedWordCount];
        _countlabel.textColor = _wordSet.color;
        [_percentLabel setText:[NSString stringWithFormat:@"%d%% completed", _wordSet.completePercentage]];
        _progress.progress = _wordSet.completePercentage / 100.f;
        [_tableView reloadData];
        
        [_arrowLayer setNeedsDisplay];
    }
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
    
    [_wordSet release];
    [super dealloc];
}

#pragma mark - UITableViewDataSource & Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
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
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    }
    
    cell.textLabel.text = _wordSet.description;        
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WordSetController *wsc = [[WordSetController alloc] init];
    [self.dashboardController.navigationController pushViewController:wsc animated:YES];
    [wsc release];
}

@end
