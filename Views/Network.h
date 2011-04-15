//
//  Network.h
//  Herdict
//
//  Created by Christian Brink on 4/5/11.
//  Copyright 2011 Herdict. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "Reachability.h"
#import "HerdictArrays.h"
#import "CustomUIButton.h"

@interface Network : UIView {

	UIImageView *networkImageView;
	UIWebView *messageView;
	NSString *messageText;
	CustomUIButton *buttonDone;
	UIActivityIndicatorView *loadingIndicator;
	UILabel *loadingText;
	Reachability *latestNotification;
	
}

@property (nonatomic, retain) UIImageView *networkImageView;
@property (nonatomic, retain) UIWebView *messageView;
@property (nonatomic, retain) NSString *messageText;
@property (nonatomic, retain) CustomUIButton *buttonDone;
@property (nonatomic, retain) UIActivityIndicatorView *loadingIndicator;
@property (nonatomic, retain) UILabel *loadingText;
@property (nonatomic, retain) Reachability *latestNotification;

- (void) show;
- (void) hide;
- (void) networkReachabilityEvent:(NSNotification *)notification;
- (void) noConnectivity;
- (void) configureViewForConnectionVia:(NSString *)connectionType requiresPassword:(BOOL)requiresPassword;
- (void) selectButtonDone;

@end