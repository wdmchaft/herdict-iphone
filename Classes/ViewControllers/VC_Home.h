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

@interface VC_Home : UIViewController <UISearchBarDelegate, UISearchDisplayDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, MKMapViewDelegate> {

	UITableView *theTableView;
	UISearchBar *theSearchBar;
	
	UIView *siteSummaryPlate;
	UIView *siteSummaryBackground;
	UITextView *siteSummaryTextView;
	bool siteSummaryReceived;
	
	UIView *checkSiteButtonPlate;
	UIView *checkSiteButtonBackground;
	UILabel *checkSiteButtonLabel;
	
	UIView *networkInfoPlate;
	UIView *networkInfoTabBackground;
	UIView *networkInfoBodyBackground;
	UILabel *networkInfoLabel;
	UITextView *networkInfoText;
	bool networkInfoPlateIsExpanded;
	
	UIView *loadingPlate;
	UIView *loadingBackground;
	UIActivityIndicatorView *loadingActivityIndicator;
	UILabel *loadingLabel;
	
	NSString *ipString;
	NSMutableDictionary *ipInfoDict;
	NSString *ispString;
	NSMutableDictionary *countryDict;
	
	NSMutableArray *reportsFromFeed;
	int currentReportForAnnotation;
	int nextReportForAnnotation;
	MKMapView *reportMapView;
	ReportAnnotation *theAnnotation;
}

@property (nonatomic, retain) UITableView *theTableView;
@property (nonatomic, retain) UISearchBar *theSearchBar;

@property (nonatomic, retain) UIView *siteSummaryPlate;
@property (nonatomic, retain) UIView *siteSummaryBackground;
@property (nonatomic, retain) UITextView *siteSummaryTextView;
@property (nonatomic) bool siteSummaryReceived;

@property (nonatomic, retain) UIView *checkSiteButtonPlate;
@property (nonatomic, retain) UIView *checkSiteButtonBackground;
@property (nonatomic, retain) UILabel *checkSiteButtonLabel;

@property (nonatomic, retain) UIView *networkInfoPlate;
@property (nonatomic, retain) UIView *networkInfoTabBackground;
@property (nonatomic, retain) UIView *networkInfoBodyBackground;
@property (nonatomic, retain) UILabel *networkInfoLabel;
@property (nonatomic, retain) UITextView *networkInfoText;
@property (nonatomic) bool networkInfoPlateIsExpanded;

@property (nonatomic, retain) UIView *loadingPlate;
@property (nonatomic, retain) UIView *loadingBackground;
@property (nonatomic, retain) UIActivityIndicatorView *loadingActivityIndicator;
@property (nonatomic, retain) UILabel *loadingLabel;

@property (nonatomic, retain) NSString *ipString;
@property (nonatomic, retain) NSMutableDictionary *ipInfoDict;
@property (nonatomic, retain) NSString *ispString;
@property (nonatomic, retain) NSMutableDictionary *countryDict;

@property (nonatomic, retain) NSMutableArray *reportsFromFeed;
@property (nonatomic) int currentReportForAnnotation;
@property (nonatomic) int nextReportForAnnotation;
@property (nonatomic, retain) MKMapView *reportMapView;
@property (nonatomic, retain) ReportAnnotation *theAnnotation;

- (NSMutableDictionary *) initialResponseHandling:(ASIHTTPRequest *)theRequest;

- (void) setUrlSchemeHttp;
- (void) getCountriesCallbackHandler:(ASIHTTPRequest*)request;
- (void) initiateGetSiteSummary;
- (void) getSiteSummaryCallbackHandler:(ASIHTTPRequest*)request;
- (void) showHerdictButtons;



+ (CGFloat)	annotationPadding;
+ (CGFloat)	calloutHeight;

@end
