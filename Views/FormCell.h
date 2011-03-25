//
//  FormCell.h
//  Herdict
//
//  Created by Christian Brink on 3/24/11.
//  Copyright 2011 Herdict. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


@interface FormCell : UITableViewCell {

	CGFloat floatRed;
	CGFloat floatGreen;
	CGFloat floatBlue;	

	UIView *iconBackground;
	UIView *mainBackground;
	
	UIImageView *theIconView;
	
	UILabel *cellLabel;
	UILabel *cellDetailLabel;
	
	UIView *whiteScreen;
	
}

@property (nonatomic) CGFloat floatRed;
@property (nonatomic) CGFloat floatGreen;
@property (nonatomic) CGFloat floatBlue;

@property (nonatomic, retain) UIView *iconBackground;
@property (nonatomic, retain) UIView *mainBackground;

@property (nonatomic, retain) UIImageView *theIconView;

@property (nonatomic, retain) UILabel *cellLabel;
@property (nonatomic, retain) UILabel *cellDetailLabel;

@property (nonatomic, retain) UIView *whiteScreen;


@end
