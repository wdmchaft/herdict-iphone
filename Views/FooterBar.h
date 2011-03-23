//
//  FooterBar.h
//  Herdict
//
//  Created by Christian Brink on 3/21/11.
//  Copyright 2011 Herdict. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


@interface FooterBar : UIView {

	UIView *theBackground;
	UITextView *textViewLeft;
	UITextView *textViewRight;
}

@property (nonatomic, retain) UIView *theBackground;
@property (nonatomic, retain) UITextView *textViewLeft;
@property (nonatomic, retain) UITextView *textViewRight;

@end
