//
//  HerdictAppDelegate.h
//  Herdict
//
//  Created by Christian Brink on 3/7/11.
//  Copyright 2011 Herdict, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WebservicesController.h"
#import "NetworkInfo.h"

#import "VC_Herdometer.h"
#import "VC_CheckSite.h"
#import "VC_ReportSite.h"

#import "TabTracker.h"

@interface HerdictAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {

    UIWindow *window;
    UITabBarController *theController;

	NSString *currentUrl;
	BOOL selectionMadeViaBubbleMenu;
	int currentTab;
	
	TabTracker *theTabTracker;
	
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *theController;

@property (nonatomic, retain) NSString *currentUrl;
@property (nonatomic) BOOL selectionMadeViaBubbleMenu;
@property (nonatomic) int currentTab;

@property (nonatomic, retain) TabTracker *theTabTracker;


@end
