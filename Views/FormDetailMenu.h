//
//  FormDetailMenu.h
//  Herdict
//
//  Created by Christian Brink on 3/19/11.
//  Copyright 2011 Herdict. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Constants.h"

@interface FormDetailMenu : UIView {
	
	UITextView *theMessage;
	NSMutableArray *menuOptions;
	UIView *selectionBackground;
	
	CGFloat selfwidth;
	CGFloat selfheight;
	
	CGFloat tailHeight;
	CGFloat tailWidth;
	CGFloat tailxOffsetForBase;
	CGFloat tailxOffsetForTip;
	
	CGFloat stroke;
	CGFloat cornerRad;
}

@property (nonatomic, retain) UITextView *theMessage;
@property (nonatomic, retain) NSMutableArray *menuOptions;
@property (nonatomic, retain) UIView *selectionBackground;

@property (nonatomic) CGFloat stroke;
@property (nonatomic) CGFloat tailHeight;
@property (nonatomic) CGFloat tailWidth;
@property (nonatomic) CGFloat tailxOffsetForBase;
@property (nonatomic) CGFloat tailxOffsetForTip;
@property (nonatomic) CGFloat cornerRad;
@property (nonatomic) CGFloat selfwidth;
@property (nonatomic) CGFloat selfheight;


- (id)initWithMessageHeight:(CGFloat)theMessageHeight withFrame:(CGRect)theFrame menuOptionsArray:(NSMutableArray *)theOptionsArray tailHeight:(CGFloat)theTailHeight anchorPoint:(CGPoint)theAnchorPoint;

- (CGPathRef) getPath;
- (void) addShadow;

- (void)showSelectionBackgroundForOption:(int)optionNumber;
- (void)hideSelectionBackground;

@end