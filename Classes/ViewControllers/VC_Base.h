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

#import "VC_Herdometer.h"
#import "VC_CheckSite.h"
#import "VC_ReportSite.h"
#import "TabTracker.h"

#import "CustomNavBar.h"
#import "CustomUIButton.h"
#import "URLBar.h"
#import "BubbleMenu.h"
#import "Screen.h"

@interface VC_Base : UIViewController <UITabBarControllerDelegate, UINavigationBarDelegate, UIAlertViewDelegate, UISearchBarDelegate> {

	// --	About
	
	// --	Nav Bar
	UIView *blackBackgroundForNavBar;
	CustomNavBar *navBar;
	UINavigationItem *navItem;
	CustomUIButton *buttonCancelTyping;
	CustomUIButton *buttonInfo;
	CustomUIButton *buttonWiFi;
	
	// --	URL Bar
	URLBar *theUrlBar;	
	BubbleMenu *theUrlBarMenu;
	NSString *currentUrlFixedUp;
	BOOL selectionMadeViaBubbleMenu;
	
	Screen *theScreen;

	TabTracker *theTabTracker;

	// --	tab bar controller
	UITabBarController *theController;
	VC_Herdometer *vcHerdometer;
	VC_CheckSite *vcCheckSite;
	VC_ReportSite *vcReportSite;
	int currentTab;
}

@property (nonatomic, retain) UIView *blackBackgroundForNavBar;
@property (nonatomic, retain) CustomNavBar *navBar;
@property (nonatomic, retain) UINavigationItem *navItem;
@property (nonatomic, retain) CustomUIButton *buttonCancelTyping;
@property (nonatomic, retain) CustomUIButton *buttonInfo;
@property (nonatomic, retain) CustomUIButton *buttonWiFi;

@property (nonatomic, retain) URLBar *theUrlBar;
@property (nonatomic, retain) BubbleMenu *theUrlBarMenu;
@property (nonatomic, retain) NSString *currentUrlFixedUp;
@property (nonatomic) BOOL selectionMadeViaBubbleMenu;

@property (nonatomic, retain) Screen *theScreen;

@property (nonatomic, retain) TabTracker *theTabTracker;

@property (nonatomic, retain) IBOutlet UITabBarController *theController;
@property (nonatomic, retain) VC_Herdometer *vcHerdometer;
@property (nonatomic, retain) VC_CheckSite *vcCheckSite;
@property (nonatomic, retain) VC_ReportSite *vcReportSite;
@property (nonatomic) int currentTab;

- (BOOL) urlTyped;
- (NSString *) fixUpTypedUrl;
- (void) selectBubbleMenuOption:(UITextView *)selectedSubview;

@end
