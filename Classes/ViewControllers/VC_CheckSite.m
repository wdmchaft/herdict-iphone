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
	NSLog(@"ENTERING getSiteSummaryCallbackHandler");
	
    // --   Pull out and prepare the site summary data.
	NSDictionary *siteSummaryDictionary = [[WebservicesController sharedSingleton] getDictionaryFromJSONData:[request responseData]];
    NSLog(@"    siteSummaryDictionary: %@", siteSummaryDictionary);
	int countryInaccessibleCount = [[siteSummaryDictionary objectForKey:@"countryInaccessibleCount"] intValue];
	int globalInaccessibleCount = [[siteSummaryDictionary objectForKey:@"globalInaccessibleCount"] intValue];
	int sheepColor = [[siteSummaryDictionary objectForKey:@"sheepColor"] intValue];
	NSString *messageString = [NSString stringWithFormat:@"%d   times in %@\n%d   times around the world", countryInaccessibleCount, [[HerdictArrays sharedSingleton] detected_countryString], globalInaccessibleCount];
	
    // --   Tell theTabSiteSummary what to do.  TODO: might want to have this logic in theTabSiteSummary, with a simpler interface.
    NSString *theUrlDomainWithPath = [self urlWithoutScheme:[[self.delegate theUrlBar] text]];
    NSString *theUrlDomain = [self domainOfUrl:theUrlDomainWithPath];
    NSLog(@"    theUrlDomain: %@", theUrlDomain);
    NSLog(@"    theUrlWithPath: %@", theUrlDomainWithPath);
    if ([theUrlDomain isEqualToString:theUrlDomainWithPath]) {
        [self.theTabSiteSummary setStateLoaded:messageString theColor:sheepColor domainOnly:YES];
    } else {
        [self.theTabSiteSummary setStateLoaded:messageString theColor:sheepColor domainOnly:NO];
        
        // --   Fire off the second callout, getting the site summary for the domain this time.
        [[WebservicesController sharedSingleton] getSiteSummary:theUrlDomain forCountry:[[HerdictArrays sharedSingleton] detected_countryCode] urlEncoding:@"none" callbackDelegate:self];
    }    
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
    
    NSString *theUrlString = [theUrl stringByReplacingOccurrencesOfString:@"http://www." withString:@""];
    theUrlString = [theUrlString stringByReplacingOccurrencesOfString:@"http://" withString:@""];

    return theUrlString;
}

- (NSString *) domainOfUrl:(NSString *)theUrl {
    NSLog(@"ENTERING domainOfUrl:theUrl");
    NSLog(@"    theUrl: %@",theUrl);
          
	NSString *theUrlString = [self urlWithoutScheme:theUrl];
    
    // --	Drop the first "/" and anything following it.
	NSRange rangeOfFirstSlash = [theUrlString rangeOfString:@"/"];
	NSString *domainFromUrl = [theUrlString substringWithRange:NSMakeRange(0, rangeOfFirstSlash.location + 1)];
    NSLog(@"    domain: %@", domainFromUrl);

    return domainFromUrl;
}

#pragma mark -
#pragma mark UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	NSLog(@"ENTERING webView:self.theWebView shouldStartLoadWithRequest:%@ navigationType:%i", webView, request, navigationType);

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

	theUrlString = [self urlWithoutScheme:theUrlString];
    if ([[self domainOfUrl:theUrlString] isEqualToString:theUrlString]) {
        NSLog(@"    [[self domainOfUrl:theUrlString] isEqualToString:theUrlString]");
        [self.theTabSiteSummary configureDefault];
    } else {
        NSLog(@"    NOT [[self domainOfUrl:theUrlString] isEqualToString:theUrlString]");
        [self.theTabSiteSummary configureForDomainAndPath];
    }
    
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
	NSLog(@"ENTERING webView:%@ didFailLoadWithError:%@", webView, error);
	[self.theLoadingBar hide];
	[self.theErrorView setErrorMessage:[error localizedDescription]];
    [self.theTabSiteSummary.delegate positionAllModalTabsOutOfViewExcept:nil];
	[self.view addSubview:self.theErrorView];
}

@end
