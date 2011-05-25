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
@synthesize viewSplash;
@synthesize vcBase;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    

	// --	Show the window.
    [self.window makeKeyAndVisible];

	// --	Set up viewSplash.
	self.viewSplash = [[UIView alloc] initWithFrame:self.window.frame];
	UIImage *imageSplash = [UIImage imageNamed:@"splashImage.png"];
	UIImageView *imageViewSplash = [[[UIImageView alloc] initWithImage:imageSplash] autorelease];
	[imageViewSplash setFrame:CGRectMake(0, 0, self.window.frame.size.width, self.window.frame.size.width * 0.6)];
	[imageViewSplash setCenter:self.window.center];
	[self.viewSplash addSubview:imageViewSplash];
	[self.window addSubview:self.viewSplash];
	
	[NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(showVcBase) userInfo:nil repeats:NO];
	
	// --	Set up vcBase.
	self.vcBase = [[VC_Base alloc] init];
	[self.vcBase.view setFrame:CGRectMake(0, 20, 320, 460)];
	 
    return YES;
}

- (void) showVcBase {
	[self.viewSplash removeFromSuperview];
	self.viewSplash = nil;
	[self.window addSubview:self.vcBase.view];
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
	[vcBase release];
    [window release];
    [super dealloc];
}

@end

