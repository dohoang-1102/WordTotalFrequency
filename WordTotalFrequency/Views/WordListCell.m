//
//  WordListCell.m
//  WordTotalFrequency
//
//  Created by Perry on 11-9-3.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "WordListCell.h"
#import "UIColor+WTF.h"
#import "DataController.h"
#import "NSManagedObjectContext+insert.h"
#import "History.h"

@implementation WordListCell

@synthesize word = _word;
@synthesize history = _history;

@synthesize wordSetController = _wordSetController;
@synthesize ownerTable = _ownerTable;
@synthesize rowIndex = _rowIndex;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGRect rect = self.bounds;
        
        self.selectedBackgroundView = [[[UIView alloc] initWithFrame:rect] autorelease];
        self.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:148.0/255 green:199.0/255 blue:231.0/255 alpha:1.0];

        _markIcon = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        _markIcon.frame = CGRectMake(0, 0, 30, CGRectGetHeight(rect));
        _markIcon.userInteractionEnabled = NO;
        [self addSubview:_markIcon];
        
        _spell = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 114, CGRectGetHeight(rect))];
        _spell.backgroundColor = [UIColor clearColor];
        _spell.adjustsFontSizeToFitWidth = YES;
        _spell.textColor = [UIColor colorForNormalText];
        _spell.font = [UIFont systemFontOfSize:18];
        _spell.shadowColor = [UIColor whiteColor];
        _spell.shadowOffset = CGSizeMake(.5, 1);
        [self addSubview:_spell];
        
        _translate = [[UILabel alloc] initWithFrame:CGRectMake(144, 0, CGRectGetWidth(rect)-144, CGRectGetHeight(rect))];
        _translate.backgroundColor = [UIColor clearColor];
        _translate.adjustsFontSizeToFitWidth = NO;
        _translate.textColor = [UIColor colorForNormalText];
        _translate.font = [UIFont systemFontOfSize:18];
        _translate.shadowColor = [UIColor whiteColor];
        _translate.shadowOffset = CGSizeMake(.5, 1);
        [self addSubview:_translate];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)dealloc
{
    [_word release];
    [_history release];
    
    [_markIcon release];
    [_spell release];
    [_translate release];
    [super dealloc];
}

/*
- (void)drawRect:(CGRect)rect
{
    [[UIColor whiteColor] set];
    [_word.translate drawAtPoint:CGPointMake(144.5, 11) withFont:[UIFont systemFontOfSize:18]];
    [[UIColor colorForNormalText] set];
    [_word.translate drawAtPoint:CGPointMake(144, 10) withFont:[UIFont systemFontOfSize:18]];
}
 */

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (_word != nil){
        if ([_word.marked boolValue])
            [_markIcon setImage:[UIImage imageNamed:@"mark-circle"] forState:UIControlStateNormal];
        else
            [_markIcon setImage:nil forState:UIControlStateNormal];
        
        _spell.text = _word.spell;
        _translate.text = _word.translate;
        
    //    const char *cstr = [_word.translate UTF8String];
    //    _translate.text = [NSString stringWithCString:cstr encoding:NSUTF8StringEncoding];
    }
    else if (_history != nil){
        [_markIcon setImage:[UIImage imageNamed:@"mark-circle"] forState:UIControlStateNormal];
        _spell.text = _history.spell;
        _translate.text = _history.translate;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_word == nil)
    {
        [self.nextResponder touchesBegan:touches withEvent:event];
        return;
    }
         
    CGSize size = [_spell.text sizeWithFont:_spell.font
                          constrainedToSize:CGSizeMake(CGRectGetWidth(_spell.bounds), CGRectGetHeight(_spell.bounds))];
    CGRect rect = CGRectMake(0, 0, 30+size.width, CGRectGetHeight(self.bounds));
    if (CGRectContainsPoint(rect, _lastHitPoint))
    {
        BOOL marked = [_word.marked boolValue];
        _word.marked = [NSNumber numberWithBool:!marked];
        
        // save NSManagedObject
        if ([_word.marked boolValue]){
            [[DataController sharedDataController] markWord:_word];
        }
        else{
            [[DataController sharedDataController] unmarkWord:_word.spell];
        }
        
        [self setNeedsLayout];
        
        if (_wordSetController)
            [_wordSetController updateMarkedCount];
    }
    else
    {
        [self.nextResponder touchesBegan:touches withEvent:event];
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    _lastHitPoint = point;
    return [super hitTest:point withEvent:event];
}

@end
