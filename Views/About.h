//
//  About.h
//  Herdict
//
//  Created by Christian Brink on 4/5/11.
//  Copyright 2011 Herdict. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Constants.h"
#import "CustomUIButton.h"


@interface About : UIView <UIWebViewDelegate> {

	UIImageView *berkmanLogoImageView;
	UIWebView *message;
	CustomUIButton *buttonLearnMore;	
	CustomUIButton *buttonDone;
}

@property (nonatomic, retain) UIImageView *berkmanLogoImageView;
@property (nonatomic, retain) UIWebView *message;
@property (nonatomic, retain) CustomUIButton *buttonLearnMore;
@property (nonatomic, retain) CustomUIButton *buttonDone;

- (void) show;
- (void) hide;
- (void) selectButtonLearnMore;
- (void) selectButtonDone;

@end
