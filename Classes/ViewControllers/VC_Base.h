//
//  VC_Base.h
//  Herdict
//
//  Created by Christian Brink on 3/26/11.
//  Copyright 2011 Herdict. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "ASIHTTPRequest.h"

#import "WebservicesController.h"
#import "NetworkInfo.h"
#import "Countries.h"

#import "CustomNavBar.h"
#import "CustomUIButton.h"
#import "URLBar.h"
#import "BubbleMenu.h"
#import "Screen.h"
#import "TabTracker.h"


@interface VC_Base : UIViewController <UINavigationBarDelegate, UIAlertViewDelegate, UISearchBarDelegate> {

	/* --	Nav Bar	-- */
	UIView *blackBackgroundForNavBar;
	CustomNavBar *navBar;
	UINavigationItem *navItem;
	CustomUIButton *buttonCancelTyping;
	CustomUIButton *buttonInfo;
	CustomUIButton *buttonWiFi;
	
	/* --	URL Bar	-- */
	URLBar *theUrlBar;	
	BubbleMenu *theUrlBarMenu;
	
	Screen *theScreen;
	TabTracker *theTabTracker;
	
}

@property (nonatomic, retain) UIView *blackBackgroundForNavBar;
@property (nonatomic, retain) CustomNavBar *navBar;
@property (nonatomic, retain) UINavigationItem *navItem;
@property (nonatomic, retain) CustomUIButton *buttonCancelTyping;
@property (nonatomic, retain) CustomUIButton *buttonInfo;
@property (nonatomic, retain) CustomUIButton *buttonWiFi;

@property (nonatomic, retain) URLBar *theUrlBar;
@property (nonatomic, retain) BubbleMenu *theUrlBarMenu;

@property (nonatomic, retain) Screen *theScreen;
@property (nonatomic, retain) TabTracker *theTabTracker;


- (BOOL) urlTyped;
- (NSString *) fixUpTypedUrl;
- (void) selectBubbleMenuOption:(UITextView *)selectedSubview;

@end
