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
#import "ReportSite.h"

#import "CustomNavBar.h"
#import "CustomUIButton.h"
#import "URLBar.h"
#import "Screen.h"

#import "About.h"
#import "Network.h"

@interface VC_Base : UIViewController <UINavigationBarDelegate, UIAlertViewDelegate, UISearchBarDelegate, VC_HerdometerDelegate, VC_CheckSiteDelegate, ModalTabDelegate> {
	
	// --	Nav Bar
	UIView *blackBackgroundForNavBar;
	CustomNavBar *navBar;
	UINavigationItem *navItem;
	CustomUIButton *buttonCancelTyping;
	CustomUIButton *buttonAbout;
	CustomUIButton *buttonHerdometer;
	CustomUIButton *buttonNetwork;
	
	// --	URL Bar
	URLBar *theUrlBar;
	NSString *currentUrlFixedUp;
	
	UINavigationController *theController;
	VC_Herdometer *vcHerdometer;
	VC_CheckSite *vcCheckSite;
	
	Screen *theScreen;

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
@property (nonatomic, retain) CustomUIButton *buttonHerdometer;
@property (nonatomic, retain) CustomUIButton *buttonNetwork;
@property (nonatomic, retain) URLBar *theUrlBar;
@property (nonatomic, retain) NSString *currentUrlFixedUp;

@property (nonatomic, retain) UINavigationController *theController;
@property (nonatomic, retain) VC_Herdometer *vcHerdometer;
@property (nonatomic, retain) VC_CheckSite *vcCheckSite;

@property (nonatomic, retain) Screen *theScreen;

@property (nonatomic, retain) About *aboutView;
@property (nonatomic, retain) Network *networkView;

@property (nonatomic) BOOL haveDoneCallouts;


- (BOOL) isAnyModalTabPositionedInView;
- (ModalTab*) modalTabInFront;
- (void) positionAllModalTabsOutOfViewExcept:(ModalTab *)thisModalTab;
- (void) positionAllModalTabsInViewBehind:(ModalTab*)thisModalTab;
- (void) positionAllModalTabsInViewWithYOrigin:(CGFloat)yOriginNew;

- (void) selectButtonAbout;
- (void) selectButtonNetwork;
- (void) selectButtonCancelSearch;
- (BOOL) urlTyped;
- (NSString *) fixUpTypedUrl;
- (void) launchCallouts;
- (BOOL) isModalPopupShowing;

@end
