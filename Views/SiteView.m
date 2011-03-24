//
//  SiteView.m
//  Herdict
//
//  Created by Christian Brink on 3/21/11.
//  Copyright 2011 Herdict. All rights reserved.
//

#import "SiteView.h"

@implementation SiteView

@synthesize theWebView;
@synthesize webViewFooter;
@synthesize theSiteSummary;
@synthesize lastTestedUrl;

- (id)initWithFrame:(CGRect)frame {
	
    self = [super initWithFrame:frame];
	
	if (self) {

		self.userInteractionEnabled = YES;
		self.backgroundColor = [UIColor clearColor];
		
		self.theWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 378)];
		self.theWebView.backgroundColor = [UIColor whiteColor];
		self.theWebView.scalesPageToFit = YES;
		[self addSubview:self.theWebView];
		
		self.theSiteSummary = [[SiteSummary alloc] initWithFrame:CGRectMake(0, 378, 320, 160)];
		self.theSiteSummary.userInteractionEnabled = YES;
		[self addSubview:self.theSiteSummary];
		
		self.webViewFooter = [[FooterBar alloc] initWithFrame:CGRectMake(0, 338, 320, 40)];
		self.webViewFooter.textViewLeft.text = @"Get or";
		self.webViewFooter.textViewRight.text = @"Submit a Report";
		self.webViewFooter.userInteractionEnabled = YES;
		[self addSubview:self.webViewFooter];
				
	}
    return self;
}

- (void)dealloc {
	[theWebView release];
	[webViewFooter release];
    [super dealloc];
}

- (void) showWebView {
	NSLog(@"SiteView showWebView");
	
	[UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut
					 animations:^{
						 [self setFrame:CGRectMake(0,38,320,378)];
					 } completion:^(BOOL finished){
					 }
	 ];
}

- (void) hideWebView {
	
	[UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut
					 animations:^{
						 [self setFrame:CGRectMake(0,416,320,378)];
					 } completion:^(BOOL finished){
					 }
	 ];
}

- (void) loadUrl:(NSString *)urlString {

	if ([self.lastTestedUrl isEqualToString:urlString]) {
		NSLog(@"[self.lastTestedUrl isEqualToString:urlString]");
		return;
	}
	
	[self hideSiteSummary];
	
	NSURL *theUrl = [NSURL URLWithString:urlString];
	NSURLRequest *theRequest = [NSURLRequest requestWithURL:theUrl];
	NSLog(@"theRequest: %@", theRequest);
	[self.theWebView loadRequest:theRequest];
	
	if (self.frame.origin.y > 300) {
		[self showWebView];
	}
	
	self.lastTestedUrl = urlString;
}

- (void) showSiteSummary {

	// --	In case theSiteView isn't on the screen at all yet... 
	if (self.frame.origin.y > 300) {
		[self showWebView];
	}
	
	// --	Haul the theSiteSummary up into view.
	[UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut
					 animations:^{
						 [self.theSiteSummary setFrame:CGRectMake(0, 218, 320, 160)];
						 // --	Hide the footer text 'Get or'.
						 if (self.webViewFooter.textViewLeft.alpha == 1) {
							 self.webViewFooter.textViewLeft.alpha = 0;
						 }
					 } completion:^(BOOL finished){
					 }
	 ];
	
	// --	In parallel... slide 'Submit a Report' over into its place.
	[UIView animateWithDuration:0.1 delay:0.125 options:UIViewAnimationOptionCurveEaseOut
					 animations:^{
						 [self.webViewFooter.textViewRight setFrame:CGRectMake(26, 3, 170, 30)];
					 } completion:^(BOOL finished){
					 }
	 ];
	
}

- (void) hideSiteSummary {
	
	// --	Shove the theSiteSummary down out of view.
	[UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseOut
					 animations:^{
						 [self.theSiteSummary setFrame:CGRectMake(0, 378, 320, 180)];
					 } completion:^(BOOL finished){
						 // --	Slide 'Submit a Report' over into its place.
						 if (self.webViewFooter.textViewLeft.center.x != 1) {
							 [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut
											  animations:^{
												  [self.webViewFooter.textViewRight setFrame:CGRectMake(79, 3, 170, 30)];
											  } completion:^(BOOL finished){
												  // --	Show the footer text 'Get or'.
												  [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveEaseOut
																   animations:^{
																	   self.webViewFooter.textViewLeft.alpha = 1;
																   } completion:^(BOOL finished){
																   }
												   ];
											  }
							  ];
							 
							 
						 }						 
					 }
	 ];
	
}

@end