//
//  BubbleMenu.h
//  Herdict
//
//  Created by Christian Brink on 3/19/11.
//  Copyright 2011 Herdict. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface BubbleMenu : UIView {

	NSString *menuName;
	
	UITextView *menuOption1;
	UITextView *menuOption2;
	UITextView *menuOption3;

	CGRect selectionBackgroundBasicFrame;
	UIView *selectionBackground;

	CATransform3D rotationWhenHidden;
	
}

@property (nonatomic, retain) UITextView *menuOption1;
@property (nonatomic, retain) UITextView *menuOption2;
@property (nonatomic, retain) UITextView *menuOption3;

@property (nonatomic) CGRect selectionBackgroundBasicFrame;
@property (nonatomic, retain) UIView *selectionBackground;

@property (nonatomic) CATransform3D rotationWhenHidden;

- (void)show;
- (void)hide;
- (void)rotateForUse;
- (void)rotateTuckedAway;

- (BOOL) point:(CGPoint)thePoint isInFrame:(CGRect)theFrame;
- (void)removeSelectionBackground;

@end