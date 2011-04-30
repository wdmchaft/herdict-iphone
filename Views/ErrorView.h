//
//  ErrorView.h
//  Herdict
//
//  Created by Christian Brink on 4/30/11.
//  Copyright 2011 Herdict. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Constants.h"
#import "CustomUIButton.h"

@interface ErrorView : UIView {

	NSString *errorString;
	UIWebView *errorWebView;
	
	CustomUIButton *buttonOk;

}

@property (nonatomic, retain) NSString *errorString;
@property (nonatomic, retain) UIWebView *errorWebView;
@property (nonatomic, retain) CustomUIButton *buttonOk;

- (void) setErrorMessage:(NSString *)theString;
- (void) selectButtonOk;

@end
