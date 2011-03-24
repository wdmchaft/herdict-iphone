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
#import "URLMenu.h"
#import "SiteView.h"
#import "CustomBarButton.h"
#import "Constants.h"
#import "WebservicesController.h"
#import "ReportForm.h"
#import "URLBar.h"

@interface VC_Home : UIViewController <UIAlertViewDelegate, UISearchBarDelegate, MKMapViewDelegate, UITableViewDelegate, UITableViewDataSource> {

	CustomBarButton *buttonMyIsp;
	CustomBarButton *buttonCancelSearch;
	
	URLBar *theUrlBar;	
	MKMapView *reportMapView;
	URLMenu *theUrlMenu;
	SiteView *theSiteView;	
	ReportForm *theReportForm;
	UIView *theScreen;
	
	NSString *ipAddress;
	NSMutableArray *reportsFromFeed;
	int indexOfCurrentReportToBeAnnotated;
	ReportAnnotation *theAnnotation;
	NSTimer *timerInititiateAnnotateReport;	

}

@property (nonatomic, retain) CustomBarButton *buttonMyIsp;
@property (nonatomic, retain) CustomBarButton *buttonCancelSearch;

@property (nonatomic, retain) URLBar *theUrlBar;
@property (nonatomic, retain) MKMapView *reportMapView;
@property (nonatomic, retain) URLMenu *theUrlMenu;
@property (nonatomic, retain) SiteView *theSiteView;
@property (nonatomic, retain) ReportForm *theReportForm;
@property (nonatomic, retain) UIView *theScreen;

@property (nonatomic, retain) NSString *ipAddress;
@property (nonatomic, retain) NSMutableArray *reportsFromFeed;
@property (nonatomic) int indexOfCurrentReportToBeAnnotated;
@property (nonatomic, retain) ReportAnnotation *theAnnotation;
@property (nonatomic, retain) NSTimer *timerInititiateAnnotateReport;


- (NSMutableDictionary *) initialResponseHandling:(ASIHTTPRequest *)theRequest;

- (void) fetchTickerFeed;

- (void) setUrlSchemeHttp;

- (void) getCountriesCallbackHandler:(ASIHTTPRequest*)request;
- (void) getCategoriesCallbackHandler:(ASIHTTPRequest *)request;
- (void) getInterestsCallbackHandler:(ASIHTTPRequest *)request;
- (void) getReasonsCallbackHandler:(ASIHTTPRequest *)request;
- (void) getLocationsCallbackHandler:(ASIHTTPRequest *)request;

- (void) initiateGetSiteSummary;
- (void) getSiteSummaryCallbackHandler:(ASIHTTPRequest*)request;
- (void) showHerdictButtons;

+ (CGFloat)	annotationPadding;
+ (CGFloat)	calloutHeight;

- (void) annotateReport;
- (void) markAllReportsNotShown;
- (void) setCountryDataWhereKnown;
- (int) indexOfReportToBeAnnotatedNext;

- (NSString *)getAnnotationTitleString:(NSMutableDictionary *)reportDict;
- (NSString *)getAnnotationSubtitleString:(NSMutableDictionary *)reportDict; 
- (int)getSheepColorInt:(NSMutableDictionary *)reportDict;

- (void) urlMenuOptionSelected:(NSNumber *)optionNumber;

@end
