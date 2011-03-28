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
	
//	UILabel *theTitle;
}

@property (nonatomic, retain) UIView *selectionScreen;

//@property (nonatomic, retain) UILabel *theTitle;

- (void)setSelected;
- (void)setNotSelected;

@end
