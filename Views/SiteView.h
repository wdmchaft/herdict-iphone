//
//  SiteView.h
//  Herdict
//
//  Created by Christian Brink on 3/21/11.
//  Copyright 2011 Herdict. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FooterBar.h"
#import "SiteSummary.h"


@interface SiteView : UIView {

	UIWebView *theWebView;
	FooterBar *webViewFooter;
	SiteSummary *theSiteSummary;
	NSString *lastTestedUrl;
	
}

@property (nonatomic, retain) UIWebView *theWebView;
@property (nonatomic, retain) FooterBar *webViewFooter;
@property (nonatomic, retain) SiteSummary *theSiteSummary;
@property (nonatomic, retain) NSString *lastTestedUrl;

@end
