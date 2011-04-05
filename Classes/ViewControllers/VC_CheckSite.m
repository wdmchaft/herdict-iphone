    //
//  VC_CheckSite.m
//  Herdict
//
//  Created by Christian Brink on 3/26/11.
//  Copyright 2011 Herdict. All rights reserved.
//

#import "VC_CheckSite.h"


@implementation VC_CheckSite

@synthesize loadingView;
@synthesize theWebView;
@synthesize theSiteSummary;
@synthesize lastTestedUrl;

@synthesize loadingIndicator;
@synthesize loadingText;


- (void)viewDidLoad {
    [super viewDidLoad];

	self.title = @"Check Site";
	
	self.view.backgroundColor = [UIColor colorWithRed:barThemeRed green:barThemeGreen blue:barThemeBlue alpha:1];

	[self setUpSiteLoadingMessage];
	[self resetCheckSite];
	
	self.theSiteSummary = [[SiteSummary alloc] initWithFrame:CGRectMake(0,
																		480 - heightForStatusBar_real - 49 - heightForSiteSummaryHideTab,
																		320,
																		heightForSiteSummary + 5)];
	[self.view insertSubview:self.theSiteSummary aboveSubview:self.theWebView];	
}

- (void) viewWillAppear:(BOOL)animated {
	[self.view bringSubviewToFront:self.theWebView];
	[self.view bringSubviewToFront:self.theSiteSummary];
	[super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}
- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (void)dealloc {
	[loadingText release];
	[loadingIndicator release];
	[theSiteSummary release];
	[theWebView release];
	[loadingView release];
    [super dealloc];
}

- (void) getSiteSummaryCallbackHandler:(ASIHTTPRequest*)request {
	
	NSDictionary *siteSummaryDictionary = [WebservicesController getDictionaryFromJSONData:[request responseData]];
	
	// --	We handle the site summary content right here - theSiteView and theSiteView.SiteSummary never have to know about it.
	NSString *countryCode = [siteSummaryDictionary objectForKey:@"countryCode"];
	NSString *countryString = [NSString string];
	for (id item in [[HerdictArrays sharedSingleton] t02arrayCountries]) {
		NSString *countryCodeFromArray = [item objectForKey:@"value"];
		if ([countryCodeFromArray isEqualToString:countryCode]) {
			countryString = [item objectForKey:@"label"];
		}
	}
	int countryInaccessibleCount = [[siteSummaryDictionary objectForKey:@"countryInaccessibleCount"] intValue];
	int globalInaccessibleCount = [[siteSummaryDictionary objectForKey:@"globalInaccessibleCount"] intValue];
	int sheepColor = [[siteSummaryDictionary objectForKey:@"sheepColor"] intValue];
	int siteId = [[siteSummaryDictionary objectForKey:@"siteId"] intValue];
	
	NSString *messageString = [NSString stringWithFormat:@"%d   times in %@\n%d   times around the world", countryInaccessibleCount, countryString, globalInaccessibleCount];
	
	[self.theSiteSummary setStateLoaded:messageString theColor:sheepColor];	
	[self.theSiteSummary positionSiteSummaryInView];
}


- (void) setUpSiteLoadingMessage {

	/* --	Set up loadingView	-- */
	self.loadingView = [[UIView alloc] initWithFrame:CGRectMake(0,
																heightForNavBar - yOverhangForNavBar + heightForURLBar,
																320,
																480 - heightForStatusBar_nonBaseViews - (heightForNavBar - yOverhangForNavBar + heightForURLBar) - 49)];
	self.loadingView.backgroundColor = [UIColor colorWithRed:barThemeRed green:barThemeGreen blue:barThemeBlue alpha:1];
	[self.view addSubview:self.loadingView];

	/* --	Set up loadingIndicator	-- */
	self.loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	[self.loadingIndicator setFrame:CGRectMake(0.5 * (320.0 - (diameterForSiteLoadingAnimation + widthForSiteLoadingText)),
											   3 + (0.5 * (self.loadingView.frame.size.height - heightForSiteSummary - diameterForSiteLoadingAnimation)),
											   diameterForSiteLoadingAnimation,
											   diameterForSiteLoadingAnimation)];
	[self.loadingIndicator startAnimating];
	[self.loadingView addSubview:self.loadingIndicator];

	/* --	Set up loadingText	-- */
	self.loadingText = [[UILabel alloc] initWithFrame:CGRectMake(self.loadingIndicator.frame.origin.x + diameterForSiteLoadingAnimation,
																 3 + (0.5 * (self.loadingView.frame.size.height - heightForSiteSummary - heightForSiteLoadingText)),
																 widthForSiteLoadingText,
																 heightForSiteLoadingText)];
	self.loadingText.backgroundColor = [UIColor clearColor];
	self.loadingText.text = @"Trying Site...";
	self.loadingText.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
	self.loadingText.textColor = [UIColor blackColor];
	self.loadingText.textAlignment = UITextAlignmentCenter;
	[self.loadingView addSubview:self.loadingText];
}

- (void) resetCheckSite {
//	NSLog(@"called resetCheckSite");
	
	if (self.theWebView) {
		[self.theWebView removeFromSuperview];
		self.theWebView = nil;
		[self.theWebView release];
	}
	self.theWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0,
																  heightForNavBar - yOverhangForNavBar + heightForURLBar,
																  320,
																  480 - heightForStatusBar_nonBaseViews - (heightForNavBar - yOverhangForNavBar + heightForURLBar) - 49)];
	self.theWebView.backgroundColor = [UIColor clearColor];
	self.theWebView.scalesPageToFit = YES;
	self.theWebView.userInteractionEnabled = YES;
	[self.view insertSubview:self.theWebView belowSubview:self.theSiteSummary];
	
}

- (void) loadUrl:(NSString *)urlString {
	NSLog(@"loadUrl: %@", urlString);
	
	NSString *theUrlString = urlString;
	theUrlString = [theUrlString stringByReplacingOccurrencesOfString:@"http://" withString:@""];
	theUrlString = [theUrlString stringByReplacingOccurrencesOfString:@"www." withString:@""];
	
	if ([theUrlString isEqualToString:self.lastTestedUrl]) {
		NSLog(@"[self.theUrlString isEqualToString:self.lastTestedUrl]");
		return;
	}
	if ([theUrlString length] == 0) {
		NSLog(@"[self.theUrlString length] == 0");
		return;
	}
	self.lastTestedUrl = theUrlString;
	
	[self resetCheckSite];
	[self.theSiteSummary setStateLoading];

	[WebservicesController getSiteSummary:theUrlString forCountry:@"US" urlEncoding:@"none" apiVersion:@"FF1.0" callbackDelegate:self];
		
	NSURL *theUrl = [NSURL URLWithString:urlString];
	NSURLRequest *theRequest = [NSURLRequest requestWithURL:theUrl];
	[self.theWebView loadRequest:theRequest];
}

@end
