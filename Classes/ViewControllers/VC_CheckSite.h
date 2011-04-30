//
//  VC_CheckSite.h
//  Herdict
//
//  Created by Christian Brink on 3/26/11.
//  Copyright 2011 Herdict. All rights reserved.
//

#import "Constants.h"
#import "WebservicesController.h"
#import "HerdictArrays.h"
#import "SiteSummary.h"
#import "ReportSite.h"
#import "LoadingBar.h"
#import "ErrorView.h"

@class VC_CheckSite;
@protocol VC_CheckSiteDelegate
@optional
@end


@interface VC_CheckSite : UIViewController <UIWebViewDelegate> {

	// --	theWebView
	UIWebView *theWebView;
	NSString *lastTestedUrl;
	LoadingBar *theLoadingBar;
	ErrorView *theErrorView;

	// --	ModalTabs
	SiteSummary *theTabSiteSummary;
	ReportSite *theTabReportSite;
	
	id <VC_CheckSiteDelegate> delegate;

}

// --	theWebView
@property (nonatomic, retain) UIWebView *theWebView;
@property (nonatomic, retain) NSString *lastTestedUrl;
@property (nonatomic, retain) LoadingBar *theLoadingBar;
@property (nonatomic, retain) ErrorView *theErrorView;

// --	ModalTabs
@property (nonatomic, retain) SiteSummary *theTabSiteSummary;
@property (nonatomic, retain) ReportSite *theTabReportSite;

@property (nonatomic, retain) id <VC_CheckSiteDelegate> delegate;

- (void) setUploadingBarMessage;
- (void) resetCheckSite;
- (void) loadUrl:(NSString *)urlString;
- (void) getSiteSummaryCallbackHandler:(ASIHTTPRequest*)request;

@end