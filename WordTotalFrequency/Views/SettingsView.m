//
//  SettingView.m
//  WordTotalFrequency
//
//  Created by Perry on 11-10-16.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "SettingsView.h"
#import "UIColor+WTF.h"
#import "DataController.h"
#import "WordSetController.h"
#import "DataUtil.h"

@interface SettingsView ()

- (void)markAll:(UIButton *)button;
- (void)unmarkAll:(UIButton *)button;

@end

@implementation SettingsView

@synthesize wordSetController = _wordSetController;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGRect rect = CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame));
        
        UITableView *table = [[UITableView alloc] initWithFrame:rect];
        table.backgroundColor = [UIColor clearColor];
        table.separatorColor = [UIColor colorWithWhite:1.f alpha:.5f];
        table.allowsSelection = NO;
        table.scrollEnabled = NO;
        table.delegate = self;
        table.dataSource = self;
        [self addSubview:table];
        [table release];
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)setWordSetController:(WordSetController *)wordSetController
{
    _wordSetController = wordSetController;
    
    
    
}

#pragma mark - table view datasource & delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 44.f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"myCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
        cell.textLabel.font = [UIFont systemFontOfSize:14.f];
        cell.textLabel.textColor = [UIColor colorForNormalText];
        cell.textLabel.shadowColor = [UIColor whiteColor];
        cell.textLabel.shadowOffset = CGSizeMake(.5, 1);
    }
    
    if (indexPath.row == 0){
        cell.textLabel.text = @"Mark all words as remembered";
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *buttonBackground = [UIImage imageNamed:@"button-bg"];
        UIImage *newImage = [buttonBackground stretchableImageWithLeftCapWidth:7.f topCapHeight:0.f];
        [btn setBackgroundImage:newImage forState:UIControlStateNormal];
        
        btn.frame = CGRectMake(200, 0, 94, 30);
        [btn setTitle:@"Mark All" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(markAll:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:14.f];
        cell.accessoryView = btn;
    }
    else if (indexPath.row == 1){
        cell.textLabel.text = @"Unmark all words";

        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *buttonBackground = [UIImage imageNamed:@"button-bg"];
        UIImage *newImage = [buttonBackground stretchableImageWithLeftCapWidth:7.f topCapHeight:0.f];
        [btn setBackgroundImage:newImage forState:UIControlStateNormal];
        
        btn.frame = CGRectMake(200, 0, 94, 30);
        [btn setTitle:@"Unmark All" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(unmarkAll:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:14.f];
        cell.accessoryView = btn;
    }
    else if (indexPath.row == 2){
        cell.textLabel.text = @"Only test unmarked words";
        UISwitch *toggle = [[UISwitch alloc] initWithFrame:CGRectMake(200, 0, 94, 30)];
        NSArray *array = [[DataUtil readDictionaryFromFile:@"WordSets"] objectForKey:@"WordSets"];
        NSDictionary *dict = [array objectAtIndex:_wordSetController.wordSet.categoryId];
        toggle.on = [[dict valueForKey:@"testMarked"] boolValue];
        [toggle addTarget:self action:@selector(toggleMarkedOnly:) forControlEvents:UIControlEventValueChanged];
        
        cell.accessoryView = toggle;
        [toggle release];
    }
    return cell;
}


#pragma mark - private message

- (void)markAll:(UIButton *)button
{
    button.enabled = NO;
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    dispatch_queue_t main_queue = dispatch_get_main_queue();
    dispatch_queue_t request_queue = dispatch_queue_create("com.app.biterice", NULL);
    
    dispatch_async(request_queue, ^{
        [_wordSetController.testWords setValue:[NSNumber numberWithBool:YES] forKey:@"marked"];
        [[DataController sharedDataController] saveFromSource:@"mark all"];
        
        dispatch_sync(main_queue, ^{
            [_wordSetController updateMarkedCount];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            dispatch_release(request_queue);
            button.enabled = YES;
        });
    });
}

- (void)unmarkAll:(UIButton *)button
{
    button.enabled = NO;
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    dispatch_queue_t main_queue = dispatch_get_main_queue();
    dispatch_queue_t request_queue = dispatch_queue_create("com.app.biterice", NULL);
    
    dispatch_async(request_queue, ^{
        [_wordSetController.testWords setValue:[NSNumber numberWithBool:NO] forKey:@"marked"];
        [[DataController sharedDataController] saveFromSource:@"unmark all"];
        
        dispatch_sync(main_queue, ^{
            [_wordSetController updateMarkedCount];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            dispatch_release(request_queue);
            button.enabled = YES;
        });
    });
}

- (void)toggleMarkedOnly:(UISwitch *)toggle
{
    NSDictionary *alldict = [DataUtil readDictionaryFromFile:@"WordSets"];
    NSArray *array = [alldict objectForKey:@"WordSets"];
    NSDictionary *dict = [array objectAtIndex:_wordSetController.wordSet.categoryId];
    [dict setValue:[NSNumber numberWithBool:toggle.on] forKey:@"testMarked"];
    [DataUtil writeDictionary:alldict toDataFile:@"WordSets"];
}

@end
