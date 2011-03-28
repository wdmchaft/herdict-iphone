//
//  HerdictAppDelegate.m
//  Herdict
//
//  Created by Christian Brink on 3/7/11.
//  Copyright 2011 Herdict, Inc. All rights reserved.
//

#import "HerdictAppDelegate.h"

@implementation HerdictAppDelegate

@synthesize window;
@synthesize theController;

@synthesize currentUrl;
@synthesize selectionMadeViaBubbleMenu;
@synthesize currentTab;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
	
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
	
	[WebservicesController getIp:[NetworkInfo sharedSingleton]];
	
	self.theController = [[UITabBarController alloc] init];
	self.theController.delegate = self;
	
	/* --	Set up the VCs	-- */
	VC_Herdometer *vcHerdometer = [[VC_Herdometer alloc] init];
	UIImage *iconHerdometer = [UIImage imageNamed:@"07-map-marker.png"];
	UITabBarItem *itemHerdometer = [[[UITabBarItem alloc] initWithTitle:@"Herdometer" image:iconHerdometer tag:0] autorelease];
	vcHerdometer.tabBarItem = itemHerdometer;
	VC_CheckSite *vcCheckSite = [[VC_CheckSite alloc] init];
	UIImage *iconCheckSite = [UIImage imageNamed:@"06-magnify.png"];
	UITabBarItem *itemCheckSite = [[[UITabBarItem alloc] initWithTitle:@"Check Site" image:iconCheckSite tag:1] autorelease];
	vcCheckSite.tabBarItem = itemCheckSite;	
	VC_ReportSite *vcReportSite = [[VC_ReportSite alloc] init];
	UIImage *iconReportSite = [UIImage imageNamed:@"179-notepad.png"];
	UITabBarItem *itemReportSite = [[[UITabBarItem alloc] initWithTitle:@"Report Site" image:iconReportSite tag:2] autorelease];
	vcReportSite.tabBarItem = itemReportSite;
	NSArray *controllers = [NSArray arrayWithObjects:vcHerdometer, vcCheckSite, vcReportSite, nil];
	theController.viewControllers = controllers;

	[self.window addSubview:self.theController.view];
    [self.window makeKeyAndVisible];

	[vcHerdometer release];
	[vcCheckSite release];
	[vcReportSite release];

    return YES;
}

#pragma mark -
#pragma mark UITabBarControllerDelegate methods

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
	NSLog(@"theController.delegate says.. shouldSelectViewController");

	VC_Base *currentVc = theController.selectedViewController;
	self.currentTab = [self.theController.viewControllers indexOfObject:currentVc];
	VC_Base *selectedVc = viewController;

	/* --	Make sure they aren't selecting the current VC						-- */
	if ([selectedVc isEqual:currentVc]) {
		return NO;
	}
	
	/* --	Find out whether this selection is being made via the bubble menu	-- */
	if (currentVc.theUrlBarMenu.alpha > 0) {
		self.selectionMadeViaBubbleMenu = YES;
	} else {
		self.selectionMadeViaBubbleMenu = NO;
	}
		
	/* --	Grab theUrlBar.text													-- */
	NSString *current = [currentVc fixUpTypedUrl];
	if ([current length] == 0) {
		self.currentUrl = nil;
	} else {
		self.currentUrl = [NSString stringWithString:current];
	}
	
	/* --	If they are selecting Herdometer, just let them go there			-- */
	if ([selectedVc isKindOfClass:[VC_Herdometer class]]) {
		return YES;
	}

	/* --	Otherwise...														-- */	
	if (![currentVc urlTyped]) {
		return NO;
	}
	
	return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
	NSLog(@"theController.delegate says.. didSelectViewController");

	VC_Base *selectedVC = viewController;

	/* --	Match the dismissed VC's theUrlBar.text state						-- */
	NSString *current;
	if (self.currentUrl) {
		current = [NSString stringWithString:self.currentUrl];
	} else {
		current = [NSString stringWithString:@""];
	}
	[selectedVC.theUrlBar setText:current];

	/* --	Match the dismissed VC's menu state									-- */
	int menuOption = [self.theController.viewControllers indexOfObject:selectedVC];
	if (self.selectionMadeViaBubbleMenu && menuOption > 0) {
		[selectedVC.theUrlBarMenu showBubbleMenuWithAnimation:[NSNumber numberWithBool:NO]];
		[selectedVC.theUrlBarMenu showSelectionBackgroundForOption:menuOption];
		[selectedVC.theUrlBarMenu hideBubbleMenu];
	}
	
	/* --	Match the dismissed VC's theTabTracker state						-- */
	[selectedVC.theTabTracker moveFromTab:self.currentTab toTab:[self.theController.viewControllers indexOfObject:selectedVC]];
	
	/* --	If it's vcCheckSite...												-- */
	if ([selectedVC isKindOfClass:[VC_CheckSite class]]) {
		[selectedVC loadUrl:selectedVC.theUrlBar.text];
	}
}

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
//    [tabBarController release];
    [window release];
    [super dealloc];
}

@end

