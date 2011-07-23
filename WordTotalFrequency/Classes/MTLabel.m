//
//  MTLabel.m
//  WordTotalFrequency
//
//  Created by OCS on 11-7-23.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "MTLabel.h"
#import <CoreText/CoreText.h>


#define DEFAULT_FONT_SIZE 12

@interface MTLabel ()

-(void)drawTransparentBackground;

@end

@implementation MTLabel

@synthesize _text;
@synthesize _lineHeight, _textHeight;
@synthesize _numberOfLines;
@synthesize _font;
@synthesize _fontColor;
@synthesize _limitToNumberOfLines, _shouldResizeToFit;
@synthesize _textAlignment;

#pragma mark - Setters

-(void)setNumberOfLines:(int)numberOfLines {
    
    
    if (numberOfLines != _numberOfLines) {
        
        _numberOfLines = numberOfLines;
        [self setNeedsDisplay];
        
    }
}

-(void)setLineHeight:(CGFloat)lineHeight {
    
    if (lineHeight != _lineHeight) {
        
        _lineHeight = lineHeight;
        [self setNeedsDisplay];
        
    }
}

-(void)setText:(NSString *)text {
    
    if (text != _text) {
        
        if (_text) {
            
            [_text release];
            _text = nil;
        }
        
        _text = [text retain];
        [self setNeedsDisplay];
        
    }
}


-(void)setFont:(UIFont *)font {
    
    if (font != _font) {
        
        if (_font) {
            
            [_font release];
            _font = nil;
            
        }
        
        _font = [font retain];
        self._lineHeight = _font.lineHeight;
        [self setNeedsDisplay];
        
    }
}


-(void)setFontColor:(UIColor *)fontColor {
    
    if (fontColor != _fontColor) {
        
        if (_fontColor) {
            
            [_fontColor release];
            _fontColor = nil;
            
        }
        
        _fontColor = [fontColor retain];
        [self setNeedsDisplay];
    }
    
}

-(void)setLimitToNumberOfLines:(BOOL)limitToNumberOfLines {
    
    if (_limitToNumberOfLines != limitToNumberOfLines) {
        
        _limitToNumberOfLines = limitToNumberOfLines;
        [self setNeedsDisplay];
        
    }
    
}


-(void)setResizeToFitText:(BOOL)resizeToFitText {
    
    
    if (_shouldResizeToFit != resizeToFitText) {
        
        _shouldResizeToFit = resizeToFitText;
        [self setNeedsDisplay];
    }
    
}


-(void)setTextAlignment:(MTLabelTextAlignment)textAlignment {
    
    if (_textAlignment != textAlignment) {
        
        _textAlignment = textAlignment;
        [self setNeedsDisplay];
        
    }
    
}


#pragma mark - Getters


-(NSString *)text {
    
    return _text;
    
}

-(UIFont *)font {
    
    return _font;
}

-(CGFloat)lineHeight {
    
    return _lineHeight;
}


-(int)numberOfLines {
    
    return _numberOfLines;
}

-(UIColor *)fontColor {
    
    return _fontColor;
}

-(BOOL)limitToNumberOfLines {
    
    return _limitToNumberOfLines;
}

-(BOOL)resizeToFitText {
    
    return _shouldResizeToFit;
}

-(MTLabelTextAlignment)textAlignment {
    
    return _textAlignment;
}

#pragma mark - Object lifecycle


-(id)init {
    
    self = [super init];
    
    if (self) {
        
        _textHeight = 0;
        self._font = [UIFont systemFontOfSize:DEFAULT_FONT_SIZE];
        self._lineHeight = _font.lineHeight;
        self._textAlignment = MTLabelTextAlignmentLeft;
        
    }
    
    return self;
    
}

-(id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _textHeight = 0;
        self._font = [UIFont systemFontOfSize:DEFAULT_FONT_SIZE];
        self._lineHeight = _font.lineHeight;
        self._textAlignment = MTLabelTextAlignmentLeft;
        
    }
    
    return self;
    
}

- (id)initWithFrame:(CGRect)frame andText:(NSString *)text {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _textHeight = 0;
        self._font = [UIFont systemFontOfSize:DEFAULT_FONT_SIZE];
        self._lineHeight = _font.lineHeight;
        self._text = text;
        self._textAlignment = MTLabelTextAlignmentLeft;
        
    }
    return self;
}


-(id)initWithText:(NSString *)text {
    
    self = [super init];
    
    if (self) {
        
        _textHeight = 0;
        self._font = [UIFont systemFontOfSize:DEFAULT_FONT_SIZE];
        self._lineHeight = _font.lineHeight;
        self._text = text;
        self._textAlignment = MTLabelTextAlignmentLeft;
        
    }
    
    return self;
    
}


+(id)label {
    
    return [[[MTLabel alloc] init] autorelease];
    
}

+(id)labelWithFrame:(CGRect)frame andText:(NSString *)text {
    
    return [[[MTLabel alloc] initWithFrame:frame andText:text] autorelease];
    
}


+(id)labelWithText:(NSString *)text {
    
    return [[[MTLabel alloc] initWithText:text] autorelease];
    
}


#pragma mark - Drawing

-(void)drawTransparentBackground {
    
    [self setBackgroundColor:[UIColor clearColor]];
    
}

- (void)drawRect:(CGRect)rect {
    
    //Create a CoreText font object with name and size from the UIKit one
    CTFontRef font = CTFontCreateWithName((CFStringRef)_font.fontName , 
                                          _font.pointSize, 
                                          NULL);
    
    
    //Setup the attributes dictionary with font and color
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                (id)font, (id)kCTFontAttributeName,
                                _fontColor.CGColor, kCTForegroundColorAttributeName, nil];
    
    NSAttributedString *attributedString = [[[NSAttributedString alloc] 
                                             initWithString:_text 
                                             attributes:attributes] autorelease];
    
    CFRelease(font);
    
    //Grab the drawing context and flip it to prevent drawing upside-down
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    //Create a TypeSetter object with the attributed text created earlier on
    CTTypesetterRef typeSetter = CTTypesetterCreateWithAttributedString((CFAttributedStringRef)attributedString);
    CFIndex currentIndex = 0;
    
    //Start drawing from the upper side of view (the context is flipped, so we need to grab the height to do so)
    CGFloat y = self.bounds.size.height - _lineHeight;
    
    BOOL shouldDrawAlong = YES;
    int count = 0;
    
    _textHeight = 0;
    
    //Start drawing lines until we run out of text
    while (shouldDrawAlong) {
        
        //Get CoreText to suggest a proper place to place the line break
        CFIndex lineBreakIndex = CTTypesetterSuggestLineBreak(typeSetter, 
                                                              currentIndex, 
                                                              rect.size.width);
        //Create a new line with from current index to line-break index
        CTLineRef line = CTTypesetterCreateLine(typeSetter, 
                                                CFRangeMake(currentIndex, lineBreakIndex));
        
        //Create a new CTLine if we want to justify the text
        if (_textAlignment == MTLabelTextAlignmentJustify) {
            
            CTLineRef justifiedLine = CTLineCreateJustifiedLine(line, 1.0, rect.size.width);
            CFRelease(line); line = nil;
            
            line = justifiedLine;
        }
        
        CGFloat x;
        
        switch (_textAlignment) {
                
            case MTLabelTextAlignmentLeft: {
                
                double offset = CTLineGetPenOffsetForFlush(line, 0, rect.size.width);
                x = offset;
                
            }
                
                break;
                
            case MTLabelTextAlignmentCenter: {
                
                double offset = CTLineGetPenOffsetForFlush(line, 0.5, rect.size.width);
                x = offset;
            }
                break;
                
            case MTLabelTextAlignmentRight: {
                
                double offset = CTLineGetPenOffsetForFlush(line, 2, rect.size.width);
                x = offset;
                
            }
                
                break;
                
            default:
                
                x = 0;
                
                break;
        }
        
        //Setup the line position
        CGContextSetTextPosition(context, x, y);
        
        CTLineDraw(line, context);
        
        y -= _lineHeight;
        
        currentIndex += lineBreakIndex;
        _textHeight  += _lineHeight;
        
        
        //Check to see if our index didn't exceed the text, and if should limit to number of lines
        if ((currentIndex >= [_text length]) &&
            !(_limitToNumberOfLines && count < _numberOfLines-1) )        
            shouldDrawAlong = NO;
        
        count++;
        CFRelease(line);
        
    }
    
    CFRelease(typeSetter);
    
    if (_shouldResizeToFit) 
        [self setFrame:CGRectMake(self.frame.origin.x, 
                                  self.frame.origin.y, 
                                  self.frame.size.width, 
                                  _textHeight)];
    
    //Core Text draws black background, found no other way to make it get my own background.
    [self performSelector:@selector(drawTransparentBackground) 
               withObject:nil 
               afterDelay:0.01];
    
} 


#pragma mark - Memory managment

- (void)dealloc {
    
    [_text release]; _text = nil;
    [_fontColor release]; _fontColor = nil;
    [_font release]; _font = nil;
    
    [super dealloc];
}

@end