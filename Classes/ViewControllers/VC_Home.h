//
//  VC_Home.h
//  Herdict
//
//  Created by Christian Brink on 3/5/11.
//  Copyright 2011 Herdict. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <MapKit/MapKit.h>
#import "ASIHTTPRequest.h"
#import "TouchXML.h"
#import "ReportAnnotation.h"
#import "SearchMenu.h"
#import "SiteView.h"
#import "CustomBarButton.h"

@interface VC_Home : UIViewController <UIAlertViewDelegate, UISearchBarDelegate, MKMapViewDelegate> {

	CustomBarButton *searchButtonCancel;
	UISearchBar *theSearchBar;	
	SearchMenu *theSearchMenu;
	
	NSMutableArray *reportsFromFeed;
	int indexOfCurrentReportToBeAnnotated;
	MKMapView *reportMapView;
	ReportAnnotation *theAnnotation;
	NSTimer *timerInititiateAnnotateReport;
	
	SiteView *theSiteView;
	
	bool stateHome;
	
//	UIView *networkInfoPlate;
//	UIView *networkInfoTabBackground;
//	UIView *networkInfoBodyBackground;
//	UILabel *networkInfoLabel;
//	UITextView *networkInfoText;
//	bool networkInfoPlateIsExpanded;
	
	UIView *loadingPlate;
	UIView *loadingBackground;
	UIActivityIndicatorView *loadingActivityIndicator;
	UILabel *loadingLabel;
	
	NSString *ipString;
	NSMutableDictionary *ipInfoDict;
	NSString *ispString;
	NSMutableDictionary *countryDict;	
}

@property (nonatomic, retain) CustomBarButton *searchButtonCancel;
@property (nonatomic, retain) UISearchBar *theSearchBar;
@property (nonatomic, retain) SearchMenu *theSearchMenu;

@property (nonatomic, retain) NSMutableArray *reportsFromFeed;
@property (nonatomic) int indexOfCurrentReportToBeAnnotated;
@property (nonatomic, retain) MKMapView *reportMapView;
@property (nonatomic, retain) ReportAnnotation *theAnnotation;
@property (nonatomic, retain) NSTimer *timerInititiateAnnotateReport;

@property (nonatomic, retain) SiteView *theSiteView;

@property (nonatomic) bool stateHome;

//@property (nonatomic, retain) UIView *networkInfoPlate;
//@property (nonatomic, retain) UIView *networkInfoTabBackground;
//@property (nonatomic, retain) UIView *networkInfoBodyBackground;
//@property (nonatomic, retain) UILabel *networkInfoLabel;
//@property (nonatomic, retain) UITextView *networkInfoText;
//@property (nonatomic) bool networkInfoPlateIsExpanded;

@property (nonatomic, retain) UIView *loadingPlate;
@property (nonatomic, retain) UIView *loadingBackground;
@property (nonatomic, retain) UIActivityIndicatorView *loadingActivityIndicator;
@property (nonatomic, retain) UILabel *loadingLabel;

@property (nonatomic, retain) NSString *ipString;
@property (nonatomic, retain) NSMutableDictionary *ipInfoDict;
@property (nonatomic, retain) NSString *ispString;
@property (nonatomic, retain) NSMutableDictionary *countryDict;

- (NSMutableDictionary *) initialResponseHandling:(ASIHTTPRequest *)theRequest;

- (void) setUrlSchemeHttp;
- (void) getCountriesCallbackHandler:(ASIHTTPRequest*)request;
- (void) initiateGetSiteSummary;
- (void) getSiteSummaryCallbackHandler:(ASIHTTPRequest*)request;
- (void) showHerdictButtons;

+ (CGFloat)	annotationPadding;
+ (CGFloat)	calloutHeight;

- (void) annotateReport;
- (void) markAllReportsNotShown;
- (void) setCountryDataWhereKnown;
- (int) indexOfReportToBeAnnotatedNext;

- (void) searchMenuOptionSelected:(int)optionNumber;

@end
