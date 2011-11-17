//
//  InfoScrollController.h
//  WordTotalFrequency
//
//  Created by Perry on 11-11-17.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface InfoScrollController : UIViewController<UIScrollViewDelegate> {
    UIButton *_closeButton;
}

@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UIPageControl *pageControl;
@property (nonatomic, retain) NSMutableArray *pageImages;

@end
