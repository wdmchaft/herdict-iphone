//
//  LoadingBar.h
//  Herdict
//
//  Created by Christian Brink on 4/29/11.
//  Copyright 2011 Herdict. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import <QuartzCore/QuartzCore.h>


@interface LoadingBar : UIView {
	
	UIActivityIndicatorView *loadingIndicator;
	UILabel *loadingText;
	
	// color components
	CGFloat componentRed;
	CGFloat componentGreen;
	CGFloat componentBlue;
	CGFloat componentAlpha;	
}

@property (nonatomic, retain) UIActivityIndicatorView *loadingIndicator;
@property (nonatomic, retain) UILabel *loadingText;

@property (nonatomic) CGFloat componentRed;
@property (nonatomic) CGFloat componentGreen;
@property (nonatomic) CGFloat componentBlue;
@property (nonatomic) CGFloat componentAlpha;	

- (CGPathRef) newPath;

- (void) show;
- (void) hide;

@end
