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
@synthesize buttonHerdometer;
@synthesize buttonNetwork;

@synthesize theUrlBar;
@synthesize currentUrlFixedUp;

@synthesize theScreen;

@synthesize vcHerdometer;
@synthesize vcCheckSite;

@synthesize theController;

@synthesize aboutView;
@synthesize networkView;

@synthesize haveDoneCallouts;

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	//NSLog(@"%@ initWithNibName:%@ bundle:%@", self, nibNameOrNil, nibBundleOrNil);

	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		
		[self.view setCenter:CGPointMake(self.view.center.x, self.view.center.y - 20)];
		[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
		
		// --	Set up theController and the VCs.
		self.theController = [[UINavigationController alloc] initWithNibName:nil bundle:nil];		
		[self.theController.view setFrame:self.view.frame];
		[self.view addSubview:self.theController.view];
		self.vcHerdometer = [[VC_Herdometer alloc] initWithNibName:nil bundle:nil];
		self.vcHerdometer.delegate = self;
		self.vcCheckSite = [[VC_CheckSite alloc] initWithNibName:nil bundle:nil];
		self.vcCheckSite.theTabSiteSummary.delegate = self;
		self.vcCheckSite.theTabReportSite.delegate = self;
		self.vcCheckSite.delegate = self;
		[self.theController pushViewController:vcHerdometer animated:YES];
		
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
		self.buttonHerdometer = [CustomUIButton buttonWithType:UIButtonTypeCustom];
		[self.buttonHerdometer addTarget:self.buttonHerdometer action:@selector(setSelected) forControlEvents:UIControlEventTouchDown];
		[self.buttonHerdometer addTarget:self action:@selector(selectButtonHerdometer) forControlEvents:UIControlEventTouchUpInside];
		[self.buttonHerdometer addTarget:self.buttonHerdometer action:@selector(setNotSelected) forControlEvents:UIControlEventTouchUpOutside];
		[self.buttonHerdometer setBackgroundImage:[UIImage imageNamed:@"buttonHerdometer.png"] forState:UIControlStateNormal];
		[self.buttonHerdometer setFrame:CGRectMake(0, 0, 40, 30)];
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
		
		// --	Set up theScreen but don't show it yet
		self.theScreen = [[Screen alloc] initWithFrame:CGRectMake(0,
																  urlBar__yOrigin + urlBar__height,
																  320,
																  480 - (urlBar__yOrigin + urlBar__height) - 20)];
		self.theScreen.backgroundColor = [UIColor clearColor];
		
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
	[theController release];
	[theScreen release];
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
#pragma mark UINavigationItem

- (void) selectButtonHerdometer {	
	[self selectButtonCancelSearch];
	[self.buttonHerdometer setNotSelected];
	[self.theController popViewControllerAnimated:YES];
    [self.vcHerdometer resumeAnnotatingReport];
	self.navItem.leftBarButtonItem = nil;
	self.navItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:self.buttonAbout] autorelease];
	
}

- (void) selectButtonAbout {
	//NSLog(@"selectButtonAbout");
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
		
	// --	If they have not entered any text, stop.
	if ([self.theUrlBar.text length] == 0) {
		//[self.theUrlBarMenu hideSelectionBackground];
		UIAlertView *alertNoUrl = [[UIAlertView alloc] initWithTitle:nil message:@"Please enter a URL." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alertNoUrl show];
		[alertNoUrl release];
		return;
	}
	
    // --	Fix up theUrlBar.text
	NSURLRequest *theRequest = [self requestWithTypedUrl];
    
    // --   Load it.
    [self.vcCheckSite.theWebView loadRequest:theRequest];

    // --   Clear the screen, push vcCheckSite.view into foreground.
	[self.theUrlBar resignFirstResponder];
	[self.aboutView hide];
	[self.networkView hide];
	if ([[self.theController topViewController] isEqual:self.vcCheckSite]) {
		return;
	}
//	[self.vcHerdometer pauseAnnotatingReport];   this doesn't always work because there may be a web callout outstanding
	[self.theController pushViewController:self.vcCheckSite animated:YES];
	self.navItem.leftBarButtonItem = nil;
	self.navItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:self.buttonHerdometer] autorelease];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
	//NSLog(@"searchBarTextDidBeginEditing");
	self.navItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:self.buttonCancelTyping] autorelease];
	
	[self.aboutView hide];
	[self.networkView hide];
	
	// --	add theScreen - this catches touches on reportMapView, so user doesn't have to tap Cancel to dismiss theUrlBar.
	[self.view addSubview:self.theScreen];
	[self.view bringSubviewToFront:self.theScreen];
	
	[self.vcHerdometer pauseAnnotatingReport];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
	self.navItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:self.buttonNetwork] autorelease];
	[self.theScreen removeFromSuperview];
	
	[self.vcHerdometer resumeAnnotatingReport];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {

	if ([alertView.message isEqualToString:@"Please enter a URL."]) {
		[self.theUrlBar becomeFirstResponder];
	}
}

- (NSURLRequest *) requestWithTypedUrl {
//	NSLog(@"requestWithTypedUrl");
	NSString *typedUrlString = self.theUrlBar.text;
	
	typedUrlString = [typedUrlString lowercaseString];

	if ([typedUrlString length] > 0) {
		NSRange rangeHttp = [typedUrlString rangeOfString:@"http"];
		if (rangeHttp.location == NSNotFound) {
			//NSLog(@"location isEqual NSNotFound");
			typedUrlString = [NSString stringWithFormat:@"%@%@", @"http://", typedUrlString];
		}
	}
	
    NSURL *theUrl = [NSURL URLWithString:typedUrlString];
    NSURLRequest *theRequest = [NSURLRequest requestWithURL:theUrl];
    
	return theRequest;
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
	//NSLog(@"vcBase began launchCallouts");
	
	if (self.haveDoneCallouts) {
		return;
	}
	
	if (![[[WebservicesController sharedSingleton] herdictReachability] isReachable]) {
		[[HerdictArrays sharedSingleton] t02SetupFromPlist];
		[[HerdictArrays sharedSingleton] t01SetupFromPlist];
		return;
	}
	
	[[WebservicesController sharedSingleton] getCategories:self.vcCheckSite.theTabReportSite];
	[[WebservicesController sharedSingleton] getCountries:[HerdictArrays sharedSingleton]]; 
	[[WebservicesController sharedSingleton] getIp:[NetworkInfo sharedSingleton]];
	[[WebservicesController sharedSingleton] getCurrentLocation:self.networkView];
	
	self.haveDoneCallouts = YES;
	
	//NSLog(@"vcBase finished launchCallouts");
}

- (BOOL) isModalPopupShowing {

	if (self.networkView.alpha > 0) {
		return TRUE;
	}
	if (self.aboutView.alpha > 0) {
		return TRUE;
	}
	return FALSE;
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	//NSLog(@"touchesBegan on %@", [self class]);
	
	UITouch *touch = [touches anyObject];
	
	if ([self.theUrlBar isFirstResponder]) {
		if (![self.theUrlBar pointInside:[touch locationInView:self.theUrlBar] withEvent:nil]) {		
			[self.theUrlBar resignFirstResponder];
		}
	}	
	
	for (UIView *aView in self.vcCheckSite.view.subviews) {
		if ([aView isKindOfClass:[ModalTab class]]) {
			ModalTab *theTab = (ModalTab*)aView;
			if ([[theTab tabLabel] pointInside:[touch locationInView:[theTab tabLabel]] withEvent:nil]) {
				if ([self isAnyModalTabPositionedInView]) {
					if ([[self modalTabInFront] isEqual:theTab]) {
						[self positionAllModalTabsOutOfViewExcept:nil];
					} else {
						[self positionAllModalTabsOutOfViewExcept:theTab];
					}
				} else {
					[self.vcCheckSite.view bringSubviewToFront:aView];
					[self positionAllModalTabsInViewBehind:theTab];
				}
			} else if ([theTab isKindOfClass:[ReportSite class]]) {
				ReportSite *theReportTab = (ReportSite*)theTab;
				if ([[theReportTab tabLabel] pointInside:[touch locationInView:[theReportTab labelAddComments]] withEvent:nil] || [[theReportTab tabLabel] pointInside:[touch locationInView:[theReportTab imageViewAddComments]] withEvent:nil]) {
					[theReportTab configureToAddComments];
				}
				if ([[theReportTab tabLabel] pointInside:[touch locationInView:[theReportTab labelSelectCategory]] withEvent:nil] || [[theReportTab tabLabel] pointInside:[touch locationInView:[theReportTab imageViewSelectCategory]] withEvent:nil]) {
					[theReportTab configureToSelectCategory];
				}
			}
		}
	}	
}

#pragma mark -
#pragma mark ModalTabDelegate


- (BOOL) isAnyModalTabPositionedInView {
	for (UIView *aView in self.vcCheckSite.view.subviews) {
		if ([aView isKindOfClass:[ModalTab class]]) {
			if ([(ModalTab*)aView isPositionedInView]) {
				return YES;
			}
		}
	}
	return NO;
}

- (ModalTab *) modalTabInFront {
	ModalTab *tabInFront = nil;
	for (UIView *aView in self.vcCheckSite.view.subviews) {
		if ([aView isKindOfClass:[ModalTab class]] && (!tabInFront || [self.vcCheckSite.view.subviews indexOfObject:aView] > [self.vcCheckSite.view.subviews indexOfObject:tabInFront])) {
			tabInFront = (ModalTab*)aView;
		}
	}
	return tabInFront;
}

- (void) positionAllModalTabsOutOfViewExcept:(ModalTab*)thisModalTab {

	NSMutableArray *allModalTabs = [NSMutableArray array];
	for (UIView *aView in self.vcCheckSite.view.subviews) {
		if ([aView isKindOfClass:[ModalTab class]] && ![aView isEqual:thisModalTab]) {
			[allModalTabs addObject:(ModalTab*)aView];
		}
	}
	
	for (ModalTab *aModalTab in allModalTabs) {
		if (![aModalTab isEqual:thisModalTab]) {
			if (thisModalTab && [aModalTab isEqual:[allModalTabs lastObject]]) {
				[aModalTab positionTabOutOfViewForDelegate:self forNewForegroundTab:thisModalTab];
			} else {
				[aModalTab positionTabOutOfViewForDelegate:nil forNewForegroundTab:nil];
			}
		}
	}
}

- (void) positionAllModalTabsInViewBehind:(ModalTab*)thisModalTab {
	//NSLog(@"positionAllModalTabsInViewBehind:%@",[thisModalTab class]);
	
	NSMutableArray *allModalTabs = [NSMutableArray array];
	for (UIView *aView in self.vcCheckSite.view.subviews) {
		if ([aView isKindOfClass:[ModalTab class]]) {
			[allModalTabs addObject:(ModalTab*)aView];
		}
	}
	if (thisModalTab) {
		[self.vcCheckSite.view bringSubviewToFront:thisModalTab];
		[allModalTabs insertObject:thisModalTab atIndex:0];
		for (ModalTab *aTab in allModalTabs) {
			[aTab positionTabInViewWithYOrigin:(thisModalTab.yOrigin__current - (2.0 * [allModalTabs indexOfObject:aTab]))];
		}
	} else {
		for (ModalTab *aTab in allModalTabs) {
			aTab.yOrigin__current = aTab.yOrigin__default;
			[aTab positionTabInViewWithYOrigin:aTab.yOrigin__current];
		}
	}
}

- (void) positionAllModalTabsInViewWithYOrigin:(CGFloat)yOriginNew {
	for (UIView *aView in self.vcCheckSite.view.subviews) {
		if ([aView isKindOfClass:[ModalTab class]]) {
			[(ModalTab*)aView positionTabInViewWithYOrigin:yOriginNew];
		}
	}	
}

@end
