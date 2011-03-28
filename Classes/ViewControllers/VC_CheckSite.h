//
//  VC_CheckSite.h
//  Herdict
//
//  Created by Christian Brink on 3/26/11.
//  Copyright 2011 Herdict. All rights reserved.
//

#import "VC_Base.h"
#import "SiteSummary.h"


@interface VC_CheckSite : VC_Base {

	UIWebView *theWebView;
	SiteSummary *theSiteSummary;
	NSString *lastTestedUrl;
	
}

@property (nonatomic, retain) UIWebView *theWebView;
@property (nonatomic, retain) SiteSummary *theSiteSummary;
@property (nonatomic, retain) NSString *lastTestedUrl;

- (void) loadUrl:(NSString *)urlString;
- (void) showSiteSummary;
- (void) hideSiteSummary;

- (void) getSiteSummaryCallbackHandler:(ASIHTTPRequest*)request;

@end
