//
//  VC_CheckSite.m
//  Herdict
//
//  Created by Christian Brink on 3/26/11.
//  Copyright 2011 Herdict. All rights reserved.
//

#import "VC_CheckSite.h"


@implementation VC_CheckSite

// --	theWebView
@synthesize theWebView;
@synthesize lastTestedUrl;
@synthesize theLoadingBar;
@synthesize theErrorView;
// --	ModalTabs
@synthesize theTabSiteSummary;
@synthesize theTabReportSite;

@synthesize delegate;

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	//NSLog(@"%@ initWithNibName:%@ bundle:%@", self, nibNameOrNil, nibBundleOrNil);

	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {

		self.view.backgroundColor = [UIColor colorWithRed:themeColorRed green:themeColorGreen blue:themeColorBlue alpha:1];
		
		[self resetCheckSite];
				
		self.theTabSiteSummary = [[SiteSummary alloc] initWithFrame:CGRectMake(0,
																			vcCheckSite__height - modalTab__tabLabel__heightDefault,
																			320,
																			modalTab__heightTotal)];
		[self.view addSubview:self.theTabSiteSummary];
		
		self.theTabReportSite = [[ReportSite alloc] initWithFrame:CGRectMake(0,
																			   vcCheckSite__height - modalTab__tabLabel__heightDefault,
																			   320,
																			   modalTab__heightTotal)];
		[self.view addSubview:self.theTabReportSite];
		
		self.theLoadingBar = [[LoadingBar alloc] initWithFrame:CGRectMake(loadingBar__xOrigin, loadingBar__yOrigin__stateHide, loadingBar__width, loadingBar__height)];
		[self.view addSubview:self.theLoadingBar];
		
		self.theErrorView = [[ErrorView alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 0.15,
																		self.view.frame.size.height * 0.3,
																		self.view.frame.size.width * 0.7,
																		self.view.frame.size.height * 0.4)];		
	}
	return self;
}

- (void) viewWillAppear:(BOOL)animated {
//	[self.view bringSubviewToFront:self.theTabSiteSummary];
//	[self.view bringSubviewToFront:self.theTabReportSite];
//	[self.view bringSubviewToFront:self.theLoadingBar];
//	[self.view sendSubviewToBack:self.theWebView];
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
	// --	theWebView
	[theWebView release];
	[lastTestedUrl release];
	[theLoadingBar release];
	// --	ModalTabs
	[theTabSiteSummary release];
	[theTabReportSite release];
    [super dealloc];
}

- (void) getSiteSummaryCallbackHandler:(ASIHTTPRequest*)request {
	NSLog(@"getSiteSummaryCallbackHandler");
	
	NSDictionary *siteSummaryDictionary = [[WebservicesController sharedSingleton] getDictionaryFromJSONData:[request responseData]];
	
	// --	We handle the site summary content right here - theTabSiteSummary never knows about it.
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
	
	[self.theTabSiteSummary setStateLoaded:messageString theColor:sheepColor];
}

- (void) resetCheckSite {
//	NSLog(@"called resetCheckSite");
	
	if (self.theWebView) {
		[self.theWebView removeFromSuperview];
		self.theWebView = nil;
		[self.theWebView release];
	}
	self.theWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0,
																  controllerVc__yOrigin,
																  320,
																  controllerVc__height)];
	self.theWebView.backgroundColor = [UIColor clearColor];
	self.theWebView.scalesPageToFit = YES;
	self.theWebView.userInteractionEnabled = YES;
	self.theWebView.delegate = self;
	[self.view addSubview:self.theWebView];
	[self.view sendSubviewToBack:self.theWebView];
}

- (void) loadUrl:(NSString *)urlString {
	
	// --	Note.. We are supposed to check for reachability before calling this method.  As of the writing of this comment, we do.

	NSLog(@"loadUrl: %@", urlString);
	
	NSString *theUrlString = urlString;
	theUrlString = [theUrlString stringByReplacingOccurrencesOfString:@"http://" withString:@""];
	theUrlString = [theUrlString stringByReplacingOccurrencesOfString:@"www." withString:@""];
	theUrlString = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)theUrlString, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8);
	
	if ([theUrlString isEqualToString:self.lastTestedUrl]) {
		NSLog(@"[self.theUrlString isEqualToString:self.lastTestedUrl]");
		[theUrlString release];
		return;
	}
	if ([theUrlString length] == 0) {
		NSLog(@"[self.theUrlString length] == 0");
		[theUrlString release];
		return;
	}
	self.lastTestedUrl = theUrlString;
	
	[self resetCheckSite];
	[self.theTabReportSite configureDefault];
	[self.theTabReportSite.delegate positionAllModalTabsOutOfViewExcept:nil];
	[self.theTabSiteSummary setStateLoading];
	[[WebservicesController sharedSingleton] getSiteSummary:theUrlString forCountry:[[HerdictArrays sharedSingleton] detected_countryCode] urlEncoding:@"none" callbackDelegate:self];
		
	NSURL *theUrl = [NSURL URLWithString:urlString];
	NSURLRequest *theRequest = [NSURLRequest requestWithURL:theUrl];
	[self.theWebView loadRequest:theRequest];

	[theUrlString release];
}

#pragma mark -
#pragma mark UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	[self.theLoadingBar show];
	
	NSString *requestedUrl = [NSString stringWithFormat:@"%@", request.URL];
	[[self.delegate theUrlBar] setText:requestedUrl];
	
	NSLog(@"webView:%@ shouldStartLoadWithRequest:%@ navigationType:%i", webView, request, navigationType);
	return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView {
//	[self.theLoadingBar show];
	NSLog(@"webViewDidStartLoad:%@", webView);
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
	[self.theLoadingBar hide];
	NSLog(@"webViewDidFinishLoad:%@", webView);	
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	[self.theLoadingBar hide];
	[self.theErrorView setErrorMessage:[error localizedDescription]];
	[self.view addSubview:self.theErrorView];
	NSLog(@"webView:%@ didFailLoadWithError:%@", webView, error);
}

@end
