    //
//  VC_Base.m
//  Herdict
//
//  Created by Christian Brink on 3/26/11.
//  Copyright 2011 Herdict. All rights reserved.
//

#import "VC_Base.h"

@implementation VC_Base

@synthesize blackBackgroundForNavBar;
@synthesize navBar;
@synthesize navItem;
@synthesize buttonCancelTyping;
@synthesize buttonAbout;
@synthesize buttonNetwork;

@synthesize theUrlBar;
@synthesize theUrlBarMenu;
@synthesize currentUrlFixedUp;
@synthesize selectionMadeViaBubbleMenu;

@synthesize theScreen;

@synthesize theTabTracker;

@synthesize theController;
@synthesize vcHerdometer;
@synthesize vcCheckSite;
@synthesize vcReportSite;
@synthesize currentTab;

@synthesize aboutView;
@synthesize networkView;

@synthesize haveDoneCallouts;

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	//NSLog(@"%@ initWithNibName:%@ bundle:%@", self, nibNameOrNil, nibBundleOrNil);

	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {

		// --	Init all our VCs now... gets us better performance when they appear.
		[self.view setCenter:CGPointMake(self.view.center.x, self.view.center.y - 20)];
		[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
		
		// --	Set up theController
		self.theController = [[UITabBarController alloc] init];
		self.theController.delegate = self;
		self.vcHerdometer = [[VC_Herdometer alloc] init];
		UIImage *iconHerdometer = [UIImage imageNamed:@"07-map-marker.png"];
		UITabBarItem *itemHerdometer = [[[UITabBarItem alloc] initWithTitle:@"Herdometer" image:iconHerdometer tag:0] autorelease];
		self.vcHerdometer.tabBarItem = itemHerdometer;
		self.vcCheckSite = [[VC_CheckSite alloc] init];
		UIImage *iconCheckSite = [UIImage imageNamed:@"06-magnify.png"];
		UITabBarItem *itemCheckSite = [[[UITabBarItem alloc] initWithTitle:@"Check Site" image:iconCheckSite tag:1] autorelease];
		self.vcCheckSite.tabBarItem = itemCheckSite;	
		self.vcReportSite = [[VC_ReportSite alloc] init];
		UIImage *iconReportSite = [UIImage imageNamed:@"179-notepad.png"];
		UITabBarItem *itemReportSite = [[[UITabBarItem alloc] initWithTitle:@"Report Site" image:iconReportSite tag:2] autorelease];
		self.vcReportSite.tabBarItem = itemReportSite;
		NSArray *controllers = [NSArray arrayWithObjects:self.vcHerdometer, self.vcCheckSite, self.vcReportSite, nil];
		theController.viewControllers = controllers;
		[self.theController.view setFrame:CGRectMake(0, 0, 320, 460)];
		[self.view addSubview:self.theController.view];
		
		// --	Set up theUrlBar (do this first just because the navBar stuff should be on top of it).
		self.theUrlBar = [[URLBar alloc] initWithFrame:CGRectMake(0, urlBar__yOrigin, 320, urlBar__height)];
		for (UIView *view in self.theUrlBar.subviews) {
			if ([view isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
				[view removeFromSuperview];
			}
		}
		[self.theUrlBar setBarStyle:UIBarStyleBlackTranslucent];
		[self.theUrlBar setDelegate:self];
		[self.view addSubview:self.theUrlBar];
		
		// --	Set up blackBackgroundForNavBar, navBar, navItem
		self.blackBackgroundForNavBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, urlBar__yOrigin + urlBar__height)];
		self.blackBackgroundForNavBar.backgroundColor = [UIColor blackColor];
		[self.view insertSubview:self.blackBackgroundForNavBar belowSubview:self.theUrlBar];	
		self.navBar = [[CustomNavBar alloc] initWithFrame:CGRectMake(0, 0, 320, navBar__height)];
		self.navBar.delegate = self;
		[self.view addSubview:self.navBar];		
		self.navItem = [[UINavigationItem alloc] initWithTitle:@"Herdict"];
		[self.navBar pushNavigationItem:navItem animated:NO];
		UIImage *herdictBadgeImage = [UIImage imageNamed:@"herdict_badge"];
		UIImageView *herdictBadgeImageView = [[[UIImageView alloc] initWithImage:herdictBadgeImage] autorelease];
		[herdictBadgeImageView setFrame:CGRectMake(95, -1, 130, 48)];
		navItem.titleView = herdictBadgeImageView;
		
		// --	Set up navBar buttons
		self.buttonAbout = [CustomUIButton buttonWithType:UIButtonTypeCustom];
		[self.buttonAbout addTarget:self.buttonAbout action:@selector(setSelected) forControlEvents:UIControlEventTouchDown];
		[self.buttonAbout addTarget:self action:@selector(selectButtonAbout) forControlEvents:UIControlEventTouchUpInside];
		[self.buttonAbout addTarget:self.buttonAbout action:@selector(setNotSelected) forControlEvents:UIControlEventTouchUpOutside];
		[self.buttonAbout setBackgroundImage:[UIImage imageNamed:@"buttonInfo.png"] forState:UIControlStateNormal];
		[self.buttonAbout setFrame:CGRectMake(0, 0, 40, 30)];
		navItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:self.buttonAbout] autorelease];
		self.buttonNetwork = [CustomUIButton buttonWithType:UIButtonTypeCustom];
		[self.buttonNetwork addTarget:self.buttonNetwork action:@selector(setSelected) forControlEvents:UIControlEventTouchDown];
		[self.buttonNetwork addTarget:self action:@selector(selectButtonNetwork) forControlEvents:UIControlEventTouchUpInside];
		[self.buttonNetwork addTarget:self.buttonNetwork action:@selector(setNotSelected) forControlEvents:UIControlEventTouchUpOutside];
		[self.buttonNetwork setBackgroundImage:[UIImage imageNamed:@"buttonWiFi.png"] forState:UIControlStateNormal];
		[self.buttonNetwork setFrame:CGRectMake(0, 0, 40, 30)];
		navItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:self.buttonNetwork] autorelease];
		
		// --	Set up buttonCancelTyping but don't use it here
		self.buttonCancelTyping = [CustomUIButton buttonWithType:UIButtonTypeCustom];
		[self.buttonCancelTyping setTitle:@"Cancel" forState:UIControlStateNormal];
		[self.buttonCancelTyping addTarget:self.buttonCancelTyping action:@selector(setSelected) forControlEvents:UIControlEventTouchDown];
		[self.buttonCancelTyping addTarget:self action:@selector(selectButtonCancelSearch) forControlEvents:UIControlEventTouchUpInside];
		[self.buttonCancelTyping addTarget:self.buttonCancelTyping action:@selector(setNotSelected) forControlEvents:UIControlEventTouchUpOutside];
		[self.buttonCancelTyping setFrame:CGRectMake(0,0,57,30)];
		
		// --	Set up theUrlBarMenu
		NSMutableArray *urlMenuOptions = [NSMutableArray array];
		[urlMenuOptions addObject:[NSString stringWithString:@"Check Site"]];
		[urlMenuOptions addObject:[NSString stringWithString:@"Submit a Report"]];
		self.theUrlBarMenu = [[BubbleMenu alloc] initWithMessageHeight:0
															 withFrame:CGRectMake(-60, urlBar__yOrigin - 20, 170, 0)
													  menuOptionsArray:urlMenuOptions
															tailHeight:22
														   anchorPoint:CGPointMake(0, 0)];
		[self.view addSubview:self.theUrlBarMenu];
		
		// --	Set up theScreen but don't show it yet
		self.theScreen = [[Screen alloc] initWithFrame:CGRectMake(0,
																  urlBar__yOrigin + urlBar__height,
																  320,
																  480 - (urlBar__yOrigin + urlBar__height) - 20)];
		self.theScreen.backgroundColor = [UIColor clearColor];
		
		// --	Set up theTabTracker
		self.theTabTracker = [[TabTracker alloc] initAtTab:0];
		[self.view addSubview:self.theTabTracker];
		[self.view bringSubviewToFront:self.theTabTracker];	
		
		// --	Set up aboutView.
		self.aboutView = [[About alloc] initWithFrame:CGRectMake((320 - aboutView__width) / 2.0,
																 (480 - aboutView__height) / 2.0,
																 aboutView__width,
																 aboutView__height)];
		
		// --	Set up networkView.
		self.networkView = [[Network alloc] initWithFrame:CGRectMake((320 - networkView__width) / 2.0,
																 (480 - networkView__height__stateLoading) / 2.0,
																 networkView__width,
																 networkView__height__stateLoading)];
		
		// --	Get Reachability notifications.
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkReachabilityEvent:) name:kReachabilityChangedNotification object:nil];

		self.haveDoneCallouts = NO;
		[self launchCallouts];
	}
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void) viewWillAppear:(BOOL)animated {
	//NSLog(@"%@ viewWillAppear", self);

	[super viewWillAppear:animated];
	
	[self.view bringSubviewToFront:self.theUrlBar];
	[self.view bringSubviewToFront:self.navBar];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}
- (void)viewDidUnload {
    [super viewDidUnload];
}
- (void)dealloc {
	[aboutView release];
	[vcHerdometer release];
	[vcCheckSite release];
	[vcReportSite release];
	[theTabTracker release];
	[theController release];
	[theScreen release];
	[theUrlBarMenu release];
	[theUrlBar release];
	[buttonNetwork release];
	[buttonAbout release];
	[buttonCancelTyping release];
	[navItem release];
	[navBar release];
	[blackBackgroundForNavBar release];
    [super dealloc];
}

#pragma mark -
#pragma mark UITabBarControllerDelegate methods

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
	//	NSLog(@"theController.delegate.. shouldSelectViewController");
	
	UIViewController *currentVc = theController.selectedViewController;
	self.currentTab = [self.theController.viewControllers indexOfObject:currentVc];
	UIViewController *selectedVc = viewController;
		
	// --	Fix up theUrlBar.text
	self.theUrlBar.text = [self fixUpTypedUrl];	
	
	// --	If they are selecting Herdometer, just let them go there
	if ([selectedVc isKindOfClass:[VC_Herdometer class]]) {
		return YES;
	}
	
	// --	If they have not entered a URL, [self urlTyped] will handle it, and after that we don't proceed.
	if (![self urlTyped]) {
		return NO;
	}
	
	// --	Check for reachability.. this will bring up self.networkView if there is none.
	if (![[[WebservicesController sharedSingleton] herdictReachability] isReachable]) {
		[self selectButtonNetwork];
		return NO;
	}

	// --	Bring vcReportSite to its top menu level.
	if ([currentVc isEqual:self.vcReportSite]) {
		[self.vcReportSite selectFormMenuOption:nil];
	}
	return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
	//	NSLog(@"theController.delegate says.. didSelectViewController");
	
	[self.aboutView hide];
	
	UIViewController *selectedVC = viewController;
		
	// --	Slide theTabTracker
	[self.theTabTracker moveFromTab:self.currentTab toTab:[self.theController.viewControllers indexOfObject:selectedVC]];
	
	// --	If it's vcCheckSite...									
	if ([selectedVC isKindOfClass:[VC_CheckSite class]]) {
		[selectedVC loadUrl:self.theUrlBar.text];
	}
}

#pragma mark -
#pragma mark UINavigationItem

- (void) selectButtonAbout {
	NSLog(@"selectButtonAbout");
	[self selectButtonCancelSearch];
	[self.buttonAbout setNotSelected];
	[self.view addSubview:self.aboutView];
	[self.networkView hide];
	[self.aboutView show];
}

- (void) selectButtonNetwork {
	NSLog(@"selectButtonNetwork");
	[self.buttonNetwork setNotSelected];
	[self.view addSubview:self.networkView];
	[self.aboutView hide];
	[self.networkView show];
}

- (void) selectButtonCancelSearch {
	[self.buttonCancelTyping setNotSelected];
	[NSTimer scheduledTimerWithTimeInterval:0.0 target:self.theUrlBar selector:@selector(resignFirstResponder) userInfo:nil repeats:NO];
}

#pragma mark -
#pragma mark self as UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	[self selectBubbleMenuOption:[self.theUrlBarMenu viewWithTag:1]];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
	//NSLog(@"searchBarTextDidBeginEditing");
	self.navItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:self.buttonCancelTyping] autorelease];
	
	[self.aboutView hide];
	[self.networkView hide];
	
	[self.theUrlBarMenu showBubbleMenu];	
	
	// --	add theScreen - this catches touches on reportMapView, so user doesn't have to tap Cancel to dismiss theUrlBar.
	[self.view addSubview:self.theScreen];
	[self.view bringSubviewToFront:self.theScreen];

	[self.vcHerdometer.timerInititiateAnnotateReport invalidate];
	[self.vcHerdometer.reportMapView removeAnnotation:self.vcHerdometer.theAnnotation];
	
	[self.vcCheckSite.theSiteSummary positionSiteSummaryOutOfView];	
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
	self.navItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:self.buttonNetwork] autorelease];
	[NSTimer scheduledTimerWithTimeInterval:0.0 target:self.theUrlBarMenu selector:@selector(hideBubbleMenu) userInfo:nil repeats:NO];
	[self.theScreen removeFromSuperview];

	[self.vcHerdometer.timerInititiateAnnotateReport invalidate];
	self.vcHerdometer.timerInititiateAnnotateReport = [NSTimer scheduledTimerWithTimeInterval:1 target:self.vcHerdometer selector:@selector(initiateAnnotateReport) userInfo:nil repeats:NO];
}


- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	//NSLog(@"touchesBegan on %@", self);
	
	UITouch *touch = [touches anyObject];
	
	// --	If it's in any of our BubbleMenu views....
	for (UIView *theMenu in [self.view subviews]) {
		if ([theMenu isKindOfClass:[BubbleMenu class]]) {
			if ([theMenu pointInside:[touch locationInView:theMenu] withEvent:nil]) {
				
				// --	If it 's in any of this BubbleMenu's tagged views...
				for (UIView *theSubview in [theMenu subviews]) {
					if (theSubview.tag > 0) {
						if ([theSubview pointInside:[touch locationInView:theSubview] withEvent:nil]) {
							[self performSelector:@selector(selectBubbleMenuOption:) withObject:theSubview afterDelay:0];
							return;
						}
					}
				}
			}
		}
	}
	if ([self.vcCheckSite.theSiteSummary pointInside:[touch locationInView:self.vcCheckSite.theSiteSummary] withEvent:nil]) {
		if (self.vcCheckSite.theSiteSummary.frame.origin.y < 300) {
			[self.vcCheckSite.theSiteSummary positionSiteSummaryOutOfView];
		} else {
			[self.vcCheckSite.theSiteSummary positionSiteSummaryInView];
		}
		return;
	}	
	if ([self.theUrlBar isFirstResponder]) {
		if (![self.theUrlBar pointInside:[touch locationInView:self.theUrlBar] withEvent:nil]) {		
			[self.theUrlBar resignFirstResponder];
		}
	}	
}

- (void) selectBubbleMenuOption:(UITextView *)selectedSubview {
//	NSLog(@"selectBubbleMenuOption: %i", selectedSubview.tag);
	
	BubbleMenu *theMenu = [selectedSubview superview];
		
	// --	Have the menu show the selection background (and schedule its removal as well as the menu's).
	[theMenu showSelectionBackgroundForOption:selectedSubview.tag];
	[NSTimer scheduledTimerWithTimeInterval:0.75 target:theMenu selector:@selector(hideSelectionBackground) userInfo:nil repeats:NO];				
	
	if ([theMenu isEqual:self.theUrlBarMenu]) {
		if ([self urlTyped]) {
			[NSTimer scheduledTimerWithTimeInterval:0.0 target:self.theUrlBar selector:@selector(resignFirstResponder) userInfo:nil repeats:NO];		

			// --	Use self.tabBarController to manage the switch... have to hand-hold it a little
			if ([self tabBarController:self.theController shouldSelectViewController:[self.theController.viewControllers objectAtIndex:selectedSubview.tag]]) {
				[self performSelector:@selector(switchToTab:) withObject:[NSNumber numberWithInt:selectedSubview.tag] afterDelay:0.4];
			}
		}
	}
}

- (void) switchToTab:(NSNumber *)tabIndex {
	self.theController.selectedIndex = [tabIndex intValue];
	[self tabBarController:self.theController didSelectViewController:[self.theController.viewControllers objectAtIndex:[tabIndex intValue]]];
}

- (BOOL) urlTyped {
//	NSLog(@"entered urlTyped");

	if ([self.theUrlBar.text length] == 0) {
		//[self.theUrlBarMenu hideSelectionBackground];
		UIAlertView *alertNoUrl = [[UIAlertView alloc] initWithTitle:nil message:@"Please enter a URL." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alertNoUrl show];
		[alertNoUrl release];
		return NO;
	}
	return YES;
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {

	if ([alertView.message isEqualToString:@"Please enter a URL."]) {
		[self.theUrlBar becomeFirstResponder];
	}
}

- (NSString *) fixUpTypedUrl {
//	NSLog(@"fixUpTypedUrl");
	NSString *typedUrl = self.theUrlBar.text;
	
	typedUrl = [typedUrl lowercaseString];

	if ([typedUrl length] > 0) {
		NSRange rangeHttp = [typedUrl rangeOfString:@"http"];
		if (rangeHttp.location == NSNotFound) {
			//NSLog(@"location isEqual NSNotFound");
			typedUrl = [NSString stringWithFormat:@"%@%@", @"http://", typedUrl];
		}
	}
	
	return typedUrl;
}

- (void) networkReachabilityEvent: (NSNotification *) notification {
	Reachability *r = [notification object];
	if ([r isReachable]) {
		[self launchCallouts];
	} else {
		[self selectButtonNetwork];
	}
}

- (void) launchCallouts {
	NSLog(@"vcBase finished launchCallouts");

	if (self.haveDoneCallouts) {
		return;
	}
	
	if (![[[WebservicesController sharedSingleton] herdictReachability] isReachable]) {
		[[HerdictArrays sharedSingleton] t02SetupFromPlist];
		[[HerdictArrays sharedSingleton] t01SetupFromPlist];
		return;
	}
	
	[[WebservicesController sharedSingleton] getCategories:self.vcReportSite];
	[[WebservicesController sharedSingleton] getCountries:[HerdictArrays sharedSingleton]]; 
	[[WebservicesController sharedSingleton] getIp:[NetworkInfo sharedSingleton]];
	[[WebservicesController sharedSingleton] getCurrentLocation:self.networkView];
	
	self.haveDoneCallouts = YES;
}

@end
