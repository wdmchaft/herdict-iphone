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

	NSMutableArray *menuOptions;
	
	CGRect selectionBackgroundBasicFrame;
	UIView *selectionBackground;

	CATransform3D rotationWhenHidden;
	
	CGFloat tailHeight;
	CGFloat tailWidth;
	CGFloat stroke;
	CGFloat tailBaseOffset;
	CGFloat tailTipOffset;
	CGFloat cornerRad;
	CGFloat selfwidth;
	CGFloat selfheight;
	
}

@property (nonatomic, retain) NSMutableArray *menuOptions;

@property (nonatomic) CGRect selectionBackgroundBasicFrame;
@property (nonatomic, retain) UIView *selectionBackground;

@property (nonatomic) CATransform3D rotationWhenHidden;

@property (nonatomic) CGFloat stroke;
@property (nonatomic) CGFloat tailHeight;
@property (nonatomic) CGFloat tailWidth;
@property (nonatomic) CGFloat tailBaseOffset;
@property (nonatomic) CGFloat tailTipOffset;
@property (nonatomic) CGFloat cornerRad;
@property (nonatomic) CGFloat selfwidth;
@property (nonatomic) CGFloat selfheight;


- (id)initWithFrame:(CGRect)frame menuOptionsArray:(NSMutableArray *)theOptionsArray tailHeight:(CGFloat)theTailHeight anchorPoint:(CGPoint)theAnchorPoint;

- (void)show;
- (void)hide;
- (void)rotateForUse;
- (void)rotateTuckedAway;

- (void) showSelectionBackgroundForOption:(int)optionNumber;
- (void)removeSelectionBackground;

@end