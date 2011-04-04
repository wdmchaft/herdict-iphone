//
//  VC_CheckSite.h
//  Herdict
//
//  Created by Christian Brink on 3/26/11.
//  Copyright 2011 Herdict. All rights reserved.
//

#import "Constants.h"
#import "WebservicesController.h"
#import "Countries.h"
#import "SiteSummary.h"


@interface VC_CheckSite : UIViewController {

	UIView *loadingView;
	UIWebView *theWebView;
	SiteSummary *theSiteSummary;
	NSString *lastTestedUrl;
	
	UIActivityIndicatorView *loadingIndicator;
	UILabel *loadingText;	
	
}

@property (nonatomic, retain) UIView *loadingView;
@property (nonatomic, retain) UIWebView *theWebView;
@property (nonatomic, retain) SiteSummary *theSiteSummary;
@property (nonatomic, retain) NSString *lastTestedUrl;

@property (nonatomic, retain) UIActivityIndicatorView *loadingIndicator;
@property (nonatomic, retain) UILabel *loadingText;

- (void) setUpSiteLoadingMessage;
- (void) resetCheckSite;

- (void) loadUrl:(NSString *)urlString;

- (void) getSiteSummaryCallbackHandler:(ASIHTTPRequest*)request;

@end
