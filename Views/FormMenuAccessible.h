//
//  FormMenuAccessible.h
//  Herdict
//
//  Created by Christian Brink on 4/4/11.
//  Copyright 2011 Herdict. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Constants.h"
#import "Screen.h"


@interface FormMenuAccessible : UIView {

	UIView *backgroundPlate1;
	UILabel *button1;
	UIView *backgroundPlate2;
	UILabel *button2;
	
	UIView *selectionBackground;
	CGFloat cornerRad;
	
	Screen *theScreen;
}


@property (nonatomic, retain) UIView *backgroundPlate1;
@property (nonatomic, retain) UILabel *button1;
@property (nonatomic, retain) UIView *backgroundPlate2;
@property (nonatomic, retain) UILabel *button2;

@property (nonatomic, retain) UIView *selectionBackground;
@property (nonatomic) CGFloat cornerRad;

@property (nonatomic, retain) Screen *theScreen;

@end
