//
//  VC_CheckSite.m
//  Herdict
//
//  Created by Christian Brink on 3/26/11.
//  Copyright 2011 Herdict. All rights reserved.
//

#import "VC_CheckSite.h"


@implementation VC_CheckSite

@synthesize delegate;
// --	theWebView
@synthesize theWebView;
@synthesize lastTestedUrl;
@synthesize theLoadingBar;
@synthesize theErrorView;
// --	ModalTabs
@synthesize theTabSiteSummary;
@synthesize theTabReportSite;

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	//NSLog(@"%@ initWithNibName:%@ bundle:%@", self, nibNameOrNil, nibBundleOrNil);

	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {

		self.view.backgroundColor = [UIColor colorWithRed:themeColorRed green:themeColorGreen blue:themeColorBlue alpha:1];
		
		[self resetCheckSite];
						
		self.theTabReportSite = [[ReportSite alloc] initWithFrame:CGRectMake(0,
																			   vcCheckSite__height - modalTab__tabLabel__heightDefault,
																			   320,
																			   modalTab__heightTotal)];
		[self.view addSubview:self.theTabReportSite];
		
		self.theTabSiteSummary = [[SiteSummary alloc] initWithFrame:CGRectMake(0,
																			   vcCheckSite__height - modalTab__tabLabel__heightDefault,
																			   320,
																			   modalTab__heightTotal)];
		[self.view addSubview:self.theTabSiteSummary];
		
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
	NSLog(@"getSiteSummaryCallbackHandler:request >> ENTERING");
	
    // --   Pull out and prepare the site summary data.
	NSDictionary *siteSummaryDictionary = [[WebservicesController sharedSingleton] getDictionaryFromJSONData:[request responseData]];
    NSLog(@"getSiteSummaryCallbackHandler:request >> siteSummaryDictionary: %@", siteSummaryDictionary);
	int countryInaccessibleCount = [[siteSummaryDictionary objectForKey:@"countryInaccessibleCount"] intValue];
	int globalInaccessibleCount = [[siteSummaryDictionary objectForKey:@"globalInaccessibleCount"] intValue];
	int sheepColor = [[siteSummaryDictionary objectForKey:@"sheepColor"] intValue];
	NSString *messageString = [NSString stringWithFormat:@"%d   times in %@\n%d   times around the world", countryInaccessibleCount, [[HerdictArrays sharedSingleton] detected_countryString], globalInaccessibleCount];
	
    // --   Tell theTabSiteSummary what to do.  TODO: if this logic gets any more complicated, put it in SiteSummary.
    [self.theTabSiteSummary setStateLoaded:messageString theColor:sheepColor domainOnly:YES];
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

- (NSString*) urlWithoutScheme:(NSString *)theUrl {
    NSLog(@"urlWithoutScheme:theUrl >> ENTERING");
    NSLog(@"urlWithoutScheme:theUrl >> theUrl: %@", theUrl);
    
    NSString *theUrlString = [theUrl stringByReplacingOccurrencesOfString:@"http://www." withString:@""];
    theUrlString = [theUrlString stringByReplacingOccurrencesOfString:@"http://" withString:@""];

    NSLog(@"urlWithoutScheme:theUrl >> RETURNING %@", theUrlString);
    return theUrlString;
}

- (NSString *) domainOfUrl:(NSString *)theUrl {
    NSLog(@"domainOfUrl:theUrl >> ENTERING");
    NSLog(@"domainOfUrl:theUrl >> theUrl: %@",theUrl);
          
	NSString *theString = [self urlWithoutScheme:theUrl];

    // --   Make sure this is a URL and not something like "about:blank"
    NSRange rangeOfDot = [theString rangeOfString:@"."];
    if (rangeOfDot.location) {
        // --	Drop the first "/" and anything following it.  If there is no "/", drop nothing.
        NSRange rangeOfFirstSlash = [theString rangeOfString:@"/"];
        NSLog(@"domainOfUrl:theUrl >> using substring with range: %@", NSStringFromRange(NSMakeRange(0, rangeOfFirstSlash.location)));
        theString = [theString substringWithRange:NSMakeRange(0, rangeOfFirstSlash.location)];        
    }
    
    NSLog(@"domainOfUrl:theUrl >> RETURNING %@", theString);

    return theString;
}

#pragma mark -
#pragma mark UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	NSLog(@"webView:self.theWebView shouldStartLoadWithRequest:%@ navigationType:%i >> ENTERING", request, navigationType);

	// --   Show that we have started working.
    [self resetCheckSite];
    [self.theLoadingBar show];	
    NSString *theUrlString = [NSString stringWithFormat:@"%@", request.URL];
	[[self.delegate theUrlBar] setText:theUrlString];

    // --	Check for reachability.  If there is none: stop working, and show vcBase.networkView.
	if (![[[WebservicesController sharedSingleton] herdictReachability] isReachable]) {
		[[self.delegate theUrlBar] resignFirstResponder];
		[self.delegate selectButtonNetwork];
		return;
	}

    // --   Let the tabs know we have a new URL.
	[self.theTabReportSite resetData];

	theUrlString = [self domainOfUrl:theUrlString];
    [self.theTabSiteSummary configureDefault];
    
	[self.view bringSubviewToFront:self.theTabSiteSummary];
	[self.theTabSiteSummary.delegate positionAllModalTabsInViewBehind:self.theTabSiteSummary];
	[[WebservicesController sharedSingleton] getSiteSummary:theUrlString forCountry:[[HerdictArrays sharedSingleton] detected_countryCode] urlEncoding:@"none" callbackDelegate:self];
	
	return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView {
	//NSLog(@"webViewDidStartLoad:%@", webView);
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
	[self.theLoadingBar hide];
	//NSLog(@"webViewDidFinishLoad:%@", webView);	
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	NSLog(@"webView:%@ didFailLoadWithError:%@ >> ENTERING", webView, error);
	[self.theLoadingBar hide];
	[self.theErrorView setErrorMessage:[error localizedDescription]];
    [self.theTabSiteSummary.delegate positionAllModalTabsOutOfViewExcept:nil];
	[self.view addSubview:self.theErrorView];
}

@end
