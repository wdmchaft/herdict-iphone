//
//  TabTracker.h
//  Herdict
//
//  Created by Christian Brink on 3/28/11.
//  Copyright 2011 Herdict. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "Constants.h"

@interface TabTracker : UIView {

}

- (TabTracker *) initAtTab:(int)tabNumber;
- (CGFloat) xOffset:(int)tabNumber;
- (void) moveFromTab:(int)currentTabNum toTab:(int)selectedTabNum;
- (CGPathRef) getPath;

@end
