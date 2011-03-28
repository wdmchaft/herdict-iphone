    //
//  VC_CheckSite.m
//  Herdict
//
//  Created by Christian Brink on 3/26/11.
//  Copyright 2011 Herdict. All rights reserved.
//

#import "VC_CheckSite.h"


@implementation VC_CheckSite

@synthesize theWebView;
@synthesize theSiteSummary;
@synthesize lastTestedUrl;


- (void)viewDidLoad {
    [super viewDidLoad];

	self.title = @"Check Site";
	
	self.theWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0,
																  heightForNavBar - overlapOnBars + heightForURLBar,
																  320,
																  480 - 20 - (heightForNavBar - overlapOnBars + heightForURLBar) - 49)];
	self.theWebView.backgroundColor = [UIColor whiteColor];
	self.theWebView.scalesPageToFit = YES;
	self.theWebView.userInteractionEnabled = YES;
	[self.view insertSubview:self.theWebView atIndex:2];
	
	self.theSiteSummary = [[SiteSummary alloc] initWithFrame:CGRectMake(0,
																		480 - 20 - 49,
																		320,
																		heightForSiteSummary)];
	self.theSiteSummary.userInteractionEnabled = YES;
	[self.view insertSubview:self.theSiteSummary atIndex:2];
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
	
	[theWebView release];
	[theSiteSummary release];

    [super dealloc];
}


- (void) getSiteSummaryCallbackHandler:(ASIHTTPRequest*)request {
	
	NSDictionary *siteSummaryDictionary = [WebservicesController getDictionaryFromJSONData:[request responseData]];
	
	// --	We handle the site summary content right here - theSiteView and theSiteView.SiteSummary never have to know about it.
	NSString *countryCode = [siteSummaryDictionary objectForKey:@"countryCode"];
	NSString *countryString = [NSString string];
	for (id item in [[Countries sharedSingleton] t02arrayCountries]) {
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
	self.theSiteSummary.textView2.text = messageString;
	
	if (sheepColor == 0) {
		self.theSiteSummary.theBackground.backgroundColor = UIColorFromRGB(0x98D428);
	} else if (sheepColor == 1) {
		self.theSiteSummary.theBackground.backgroundColor = UIColorFromRGB(0x98D428);
	} else if (sheepColor == 2) {
		self.theSiteSummary.theBackground.backgroundColor = UIColorFromRGB(0xFF6600);
	}
	
	[self showSiteSummary];
}

#pragma mark -
#pragma mark UITouch

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[super touchesBegan:touches withEvent:event];
	
	UITouch *touch = [touches anyObject];
	
	if ([self.theSiteSummary.hideLabel pointInside:[touch locationInView:self.theSiteSummary.hideLabel] withEvent:nil]) {
		[self hideSiteSummary];
		return;
	}
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
	[WebservicesController getSiteSummary:theUrlString forCountry:@"US" urlEncoding:@"none" apiVersion:@"FF1.0" callbackDelegate:self];
	
	NSURL *theUrl = [NSURL URLWithString:urlString];
	NSURLRequest *theRequest = [NSURLRequest requestWithURL:theUrl];
	[self.theWebView loadRequest:theRequest];
}

- (void) showSiteSummary {
	
	// --	Haul the theSiteSummary up into view.
	[UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut
					 animations:^{
						 [self.theSiteSummary setFrame:CGRectMake(0,
																  480 - 20 - 49 - heightForSiteSummary,
																  320,
																  heightForSiteSummary)];
					 } completion:^(BOOL finished){
					 }
	 ];	
}

- (void) hideSiteSummary {
	
	// --	Shove the theSiteSummary down out of view.
	[UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseOut
					 animations:^{
						 [self.theSiteSummary setFrame:CGRectMake(0,
																  480 - 20 - 49,
																  320,
																  heightForSiteSummary)];
					 } completion:^(BOOL finished){
					 }
	 ];
}

@end
