//
//  VC_Herdometer.h
//  Herdict
//
//  Created by Christian Brink on 3/5/11.
//  Copyright 2011 Herdict. All rights reserved.
//

#import "Constants.h"
#import "WebservicesController.h"

#import <MapKit/MapKit.h>
#import "ReportAnnotation.h"
#import "ASIHTTPRequest.h"
#import "TouchXML.h"
#import "Reachability.h"

@class VC_Herdometer;
@protocol VC_HerdometerDelegate
@optional
- (BOOL) isModalPopupShowing;
@end


@interface VC_Herdometer : UIViewController <MKMapViewDelegate> {

	// -- Herdometer
	MKMapView *reportMapView;
	NSMutableArray *reportsFromFeed;
	int indexOfCurrentReportToBeAnnotated;
	ReportAnnotation *theAnnotation;
	NSTimer *timerInititiateAnnotateReport;
	BOOL haveFetchedReportFeed;
	
	id <VC_HerdometerDelegate> delegate;
}

@property (nonatomic, retain) MKMapView *reportMapView;
@property (nonatomic, retain) NSMutableArray *reportsFromFeed;
@property (nonatomic) int indexOfCurrentReportToBeAnnotated;
@property (nonatomic, retain) ReportAnnotation *theAnnotation;
@property (nonatomic, retain) NSTimer *timerInititiateAnnotateReport;
@property (nonatomic) BOOL haveFetchedReportFeed;

@property (nonatomic, retain) id <VC_HerdometerDelegate> delegate;


+ (CGFloat)	annotationPadding;
+ (CGFloat)	calloutHeight;
- (void) fetchTickerFeed;
- (void) initiateAnnotateReport;
- (void) pauseAnnotatingReport;
- (void) resumeAnnotatingReport;
- (void) getRoughGeocodeForCountryCallbackHandler:(ASIHTTPRequest *)request;
- (void) annotateReport;
- (void) markAllReportsNotShown;
- (void) setCountryGeodataWhereKnown;
- (int) indexOfReportToBeAnnotatedNext;
- (NSString *)getAnnotationTitleString:(NSMutableDictionary *)reportDict;
- (NSString *)getAnnotationSubtitleString:(NSMutableDictionary *)reportDict; 
- (int)getSheepColorInt:(NSMutableDictionary *)reportDict;


@end
