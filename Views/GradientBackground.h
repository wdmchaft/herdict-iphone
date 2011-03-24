//
//  GradientBackground.h
//  Herdict
//
//  Created by Christian Brink on 3/23/11.
//  Copyright 2011 Herdict. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface GradientBackground : UIView {

	CGFloat floatRed;
	CGFloat floatGreen;
	CGFloat floatBlue;
	UIColor *highColor;
	
}

@property (nonatomic) CGFloat floatRed;
@property (nonatomic) CGFloat floatGreen;
@property (nonatomic) CGFloat floatBlue;
@property (nonatomic, retain) UIColor *highColor;

@end
