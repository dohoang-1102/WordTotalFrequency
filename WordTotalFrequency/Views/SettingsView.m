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
#import "NSDate+Ext.h"
#import "Constant.h"
#import <sqlite3.h>

@interface SettingsView ()

- (void)markAll:(UIButton *)button;
- (void)unmarkAll:(UIButton *)button;

@end

@implementation SettingsView

@synthesize wordSetController = _wordSetController;

#define BTN_CLEAN_HISTORY 1;

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
        cell.textLabel.text = @"Clean history of words";

        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = BTN_CLEAN_HISTORY;
        UIImage *buttonBackground = [UIImage imageNamed:@"button-bg"];
        UIImage *newImage = [buttonBackground stretchableImageWithLeftCapWidth:7.f topCapHeight:0.f];
        [btn setBackgroundImage:newImage forState:UIControlStateNormal];
        
        btn.frame = CGRectMake(200, 0, 94, 30);
        [btn setTitle:@"Clean" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(unmarkAll:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:14.f];
        cell.accessoryView = btn;
    }
    else if (indexPath.row == 2){
        cell.textLabel.text = @"Only test unmarked words";
        UISwitch *toggle = [[UISwitch alloc] initWithFrame:CGRectMake(200, 0, 94, 30)];
        NSDictionary *dict = [[DataController sharedDataController] dictionaryForCategoryId:_wordSetController.wordSet.categoryId];
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
    sqlite3 *database;
    NSString *dbPath = [[DataController sharedDataController] dbPath];
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {
        NSString *sql = [NSString stringWithFormat:@"UPDATE ZWORD SET ZMARKSTATUS=2, ZMARKDATE='%@' WHERE ZCATEGORY=%d AND ZMARKSTATUS=0",
                         [[NSDate date] formatLongDate],
                         _wordSetController.wordSet.categoryId];
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            sqlite3_step(statement);
        }
        sqlite3_finalize(statement);
	} else {
		NSLog(@"failed open db");
	}
    sqlite3_close(database);
    database = NULL;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:HISTORY_CHANGED_NOTIFICATION object:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:BATCH_MARKED_NOTIFICATION object:self];
}

- (void)unmarkAll:(UIButton *)button
{
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@""
                                                     message:@"Are you sure you want to clean history?"
                                                    delegate:self
                                           cancelButtonTitle:@"Yes, I'm Sure"
                                           otherButtonTitles:@"No, thanks", nil] autorelease];
    [alert show];
}

- (void)toggleMarkedOnly:(UISwitch *)toggle
{
    NSDictionary *dict = [[DataController sharedDataController] dictionaryForCategoryId:_wordSetController.wordSet.categoryId];
    [dict setValue:[NSNumber numberWithBool:toggle.on] forKey:@"testMarked"];
    [[DataController sharedDataController] saveSettingsDictionary];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:TEST_SETTING_CHANGED_NOTIFICATION object:self];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0) {
        sqlite3 *database;
        NSString *dbPath = [[DataController sharedDataController] dbPath];
        if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {
            NSString *sql = [NSString stringWithFormat:@"UPDATE ZWORD SET ZMARKSTATUS=0, ZMARKDATE='' WHERE ZCATEGORY=%d AND ZMARKSTATUS>0", _wordSetController.wordSet.categoryId];
            sqlite3_stmt *statement;
            if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                sqlite3_step(statement);
            }
            sqlite3_finalize(statement);
        } else {
            NSLog(@"failed open db");
        }
        sqlite3_close(database);
        database = NULL;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:HISTORY_CHANGED_NOTIFICATION object:self];
        [[NSNotificationCenter defaultCenter] postNotificationName:BATCH_MARKED_NOTIFICATION object:self];
	}
}

@end
