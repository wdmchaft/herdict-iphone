//
//  CustomUIButton.h
//  Herdict
//
//  Created by Christian Brink on 3/23/11.
//  Copyright 2011 Herdict. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


@interface CustomUIButton : UIButton {
	
	UIView *selectionScreen;
	CGFloat componentRed;
	CGFloat componentGreen;
	CGFloat componentBlue;
	CGFloat componentAlpha;
}

@property (nonatomic, retain) UIView *selectionScreen;
@property (nonatomic) CGFloat componentRed;
@property (nonatomic) CGFloat componentGreen;
@property (nonatomic) CGFloat componentBlue;
@property (nonatomic) CGFloat componentAlpha;

- (void)setColorComponentsWithRed:(CGFloat)theRed withGreen:(CGFloat)theGreen withBlue:(CGFloat)theBlue withAlpha:(CGFloat)theAlpha;
- (void)setSelected;
- (void)setNotSelected;

@end
