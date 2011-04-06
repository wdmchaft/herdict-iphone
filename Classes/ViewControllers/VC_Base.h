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
#import "Reachability.h"

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

#import "About.h"
#import "Network.h"

@interface VC_Base : UIViewController <UITabBarControllerDelegate, UINavigationBarDelegate, UIAlertViewDelegate, UISearchBarDelegate> {
	
	// --	Nav Bar
	UIView *blackBackgroundForNavBar;
	CustomNavBar *navBar;
	UINavigationItem *navItem;
	CustomUIButton *buttonCancelTyping;
	CustomUIButton *buttonAbout;
	CustomUIButton *buttonNetwork;
	
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
	
	// --	About, Network
	About *aboutView;
	Network *networkView;
	
	BOOL haveDoneCallouts;
}

@property (nonatomic, retain) UIView *blackBackgroundForNavBar;
@property (nonatomic, retain) CustomNavBar *navBar;
@property (nonatomic, retain) UINavigationItem *navItem;
@property (nonatomic, retain) CustomUIButton *buttonCancelTyping;
@property (nonatomic, retain) CustomUIButton *buttonAbout;
@property (nonatomic, retain) CustomUIButton *buttonNetwork;

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

@property (nonatomic, retain) About *aboutView;
@property (nonatomic, retain) Network *networkView;

@property (nonatomic) BOOL haveDoneCallouts;


- (void) selectButtonAbout;
- (void) selectButtonNetwork;
- (void) selectButtonCancelSearch;
- (void) selectBubbleMenuOption:(UITextView *)selectedSubview;
- (BOOL) urlTyped;
- (NSString *) fixUpTypedUrl;
- (void) initiateGetCurrentLocation;

@end
