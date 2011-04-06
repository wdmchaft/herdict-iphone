//
//  BubbleMenu.h
//  Herdict
//
//  Created by Christian Brink on 3/19/11.
//  Copyright 2011 Herdict. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Constants.h"

@interface BubbleMenu : UIView {

	UITextView *theMessage;
	NSMutableArray *menuOptions;
	UIView *selectionBackground;

	CGFloat selfWidth;
	CGFloat selfHeight;

	CGRect frameForShowMenu;
	CGFloat tailHeight;
	CGFloat tailWidth;
	CGFloat tailOffset;
	
	CGFloat stroke;
	CGFloat cornerRad;
	CATransform3D rotationWhenHidden;
	
	CAKeyframeAnimation *animationRotateForUse;
	CAKeyframeAnimation *animationRotateTuckedAway;
}

@property (nonatomic, retain) UITextView *theMessage;
@property (nonatomic, retain) NSMutableArray *menuOptions;
@property (nonatomic, retain) UIView *selectionBackground;

@property (nonatomic) CGRect frameForShowMenu;

@property (nonatomic) CATransform3D rotationWhenHidden;

@property (nonatomic, retain) CAKeyframeAnimation *animationRotateForUse;
@property (nonatomic, retain) CAKeyframeAnimation *animationRotateTuckedAway;

@property (nonatomic) CGFloat stroke;
@property (nonatomic) CGFloat tailHeight;
@property (nonatomic) CGFloat tailWidth;
@property (nonatomic) CGFloat tailOffset;
@property (nonatomic) CGFloat cornerRad;
@property (nonatomic) CGFloat selfWidth;
@property (nonatomic) CGFloat selfHeight;


- (id)initWithMessageHeight:(CGFloat)theMessageHeight withFrame:(CGRect)theFrame menuOptionsArray:(NSMutableArray *)theOptionsArray tailHeight:(CGFloat)theTailHeight anchorPoint:(CGPoint)theAnchorPoint;

- (CGPathRef) getPath;

- (void)showBubbleMenu;
- (void)hideBubbleMenu;
- (void)setUpAnimationRotateForUse;
- (void)setUpAnimationRotateTuckedAway;

- (void) showSelectionBackgroundForOption:(int)optionNumber;
- (void)hideSelectionBackground;

@end