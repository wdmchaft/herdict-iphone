//
//  FormMenuComments.h
//  Herdict
//
//  Created by Christian Brink on 3/19/11.
//  Copyright 2011 Herdict. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Constants.h"

@interface FormMenuComments : UIView {
	
	UITextView *theMessage;
	UITextView *theComments;
	
	NSMutableArray *menuOptions;
	UIView *selectionBackground;
	
	CGFloat selfwidth;
	CGFloat selfheight;
	
	CGFloat xPaddingLeft;
	CGFloat xPaddingRight;
	CGFloat yPaddingForMessage;
	
	CGFloat messageHeight;
	CGFloat tailHeight;
	CGFloat tailWidth;
	CGFloat tailxOffsetForBase;
	CGFloat tailxOffsetForTip;
	
	CGFloat cutoutCornerRad;
	CGFloat cutoutOriginX;
	CGFloat cutoutOriginY;
	CGFloat cutoutSizeWidth;
	CGFloat cutoutSizeHeight;	
	
	CGFloat stroke;
	CGFloat cornerRad;
}

@property (nonatomic, retain) UITextView *theMessage;
@property (nonatomic, retain) UITextView *theComments;

@property (nonatomic, retain) NSMutableArray *menuOptions;
@property (nonatomic, retain) UIView *selectionBackground;

@property (nonatomic) CGFloat selfwidth;
@property (nonatomic) CGFloat selfheight;

@property (nonatomic) CGFloat xPaddingLeft;
@property (nonatomic) CGFloat xPaddingRight;
@property (nonatomic) CGFloat yPaddingForMessage;

@property (nonatomic) CGFloat messageHeight;
@property (nonatomic) CGFloat tailHeight;
@property (nonatomic) CGFloat tailWidth;
@property (nonatomic) CGFloat tailxOffsetForBase;
@property (nonatomic) CGFloat tailxOffsetForTip;

@property (nonatomic) CGFloat cutoutCornerRad;
@property (nonatomic) CGFloat cutoutOriginX;
@property (nonatomic) CGFloat cutoutOriginY;
@property (nonatomic) CGFloat cutoutSizeWidth;
@property (nonatomic) CGFloat cutoutSizeHeight;	

@property (nonatomic) CGFloat stroke;
@property (nonatomic) CGFloat cornerRad;



- (id)initWithMessageHeight:(CGFloat)theMessageHeight withFrame:(CGRect)theFrame tailHeight:(CGFloat)theTailHeight;

- (CGPathRef) getPath;
- (void) addShadow;

- (void)showSelectionBackgroundForOption:(int)optionNumber;
- (void)hideSelectionBackground;

@end