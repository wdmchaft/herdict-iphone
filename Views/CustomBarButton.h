//
//  CustomBarButton.h
//  Herdict
//
//  Created by Christian Brink on 3/23/11.
//  Copyright 2011 Herdict. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "GradientBackground.h"


@interface CustomBarButton : UIButton {
	
	UILabel *theTitle;
	GradientBackground *notSelectedBackground;
	GradientBackground *selectedBackground;
}

@property (nonatomic, retain) UILabel *theTitle;
@property (nonatomic, retain) GradientBackground *notSelectedBackground;
@property (nonatomic, retain) GradientBackground *selectedBackground;

- (void)setSelected;
- (void)setNotSelected;

@end
