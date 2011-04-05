//
//  VC_Herdometer.m
//  Herdict
//
//  Created by Christian Brink on 3/5/11.
//  Copyright 2011 Herdict. All rights reserved.
//

#import "VC_Herdometer.h"

@implementation VC_Herdometer

@synthesize reportMapView;
@synthesize reportsFromFeed;
@synthesize indexOfCurrentReportToBeAnnotated;
@synthesize theAnnotation;
@synthesize timerInititiateAnnotateReport;


#pragma mark UIViewController lifecycle

- (void) viewDidLoad {
	NSLog(@"VC_Herdometer viewDidLoad");

	[super viewDidLoad];
		
	self.view.backgroundColor = [UIColor colorWithRed:barThemeRed green:barThemeGreen blue:barThemeBlue alpha:1];

	self.title = @"Herdometer";
	
	// --	Set up reportMapView.
	self.reportMapView = [[MKMapView alloc] initWithFrame:CGRectMake(0,
																	 heightForNavBar - yOverhangForNavBar + heightForURLBar,
																	 320,
																	 480 - heightForStatusBar_nonBaseViews - (heightForNavBar - yOverhangForNavBar + heightForURLBar) - 49)];
	self.reportMapView.delegate = self;
	self.reportMapView.userInteractionEnabled = YES;
	self.reportMapView.scrollEnabled = NO;
	self.reportMapView.zoomEnabled = NO;
	[self.view addSubview:self.reportMapView];	
	self.indexOfCurrentReportToBeAnnotated = 0;	

	[self fetchTickerFeed];

}

- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	if ([self.timerInititiateAnnotateReport isValid]) {
		return;
	}
	[self initiateAnnotateReport];

}

- (void) viewWillDisappear:(BOOL)animated {

	[self.timerInititiateAnnotateReport invalidate];
}

- (void) dealloc {
	[timerInititiateAnnotateReport release];
	[theAnnotation release];
	[reportMapView release];	
	[super dealloc];
}

#pragma mark -
#pragma mark Herdometer

- (void) fetchTickerFeed {

	self.reportsFromFeed = [NSMutableArray array];

	// TODO: See about the feed being available in multiple languages.	
	NSURL *feedUrl = [NSURL URLWithString:@"http://www.herdict.org/web/rss/en"];
	CXMLDocument *feedParser = [[[CXMLDocument alloc] initWithContentsOfURL:feedUrl options:0 error:nil] autorelease];
	NSArray *feedNodes = [feedParser nodesForXPath:@"//item" error:nil];
	
	for (CXMLElement *feedNode in feedNodes) {
		// --	Have touchXML handle everything but the CDATA blocks.
		NSMutableDictionary *reportDict = [NSMutableDictionary dictionary];
		int counter;
		for (counter = 0; counter < [feedNode childCount]; counter++) {
			NSString *name = [[[feedNode childAtIndex:counter] name] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
			NSString *stringValue = [[[feedNode childAtIndex:counter] stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
			if ([stringValue length] != 0){
				[reportDict setObject:stringValue forKey:name];				
			}
		}
		// --	Self rolled parser for CDATA block.
		NSMutableDictionary *cDataDict = [NSMutableDictionary dictionary];
		NSString *cDataString = [reportDict objectForKey:@"description"];
		cDataString = [cDataString stringByReplacingOccurrencesOfString:@"\n                      " withString:@""];
		
		for (int i = 0; i < 5; i++) {			
			NSRange keyDelimiterRange = [cDataString rangeOfString:@":"];
			NSRange pairDelimiterRange = [cDataString rangeOfString:@"<br/>"];
			
			NSRange keyRange = NSMakeRange(0, keyDelimiterRange.location);
			NSRange valueRange = NSMakeRange(keyDelimiterRange.location + 2, pairDelimiterRange.location - (keyDelimiterRange.location + 2));
			
			NSString *keyString = [cDataString substringWithRange:keyRange];
			NSString *valueString = [cDataString substringWithRange:valueRange];
			
			[cDataDict setObject:valueString forKey:keyString];
			
			NSRange remainingRange = NSMakeRange(pairDelimiterRange.location + 5, [cDataString length] - (pairDelimiterRange.location + 5));
			cDataString = [cDataString substringWithRange:remainingRange];
		}
		[reportDict setObject:cDataDict forKey:@"description"];
		[self.reportsFromFeed addObject:reportDict];
	}
	
	NSLog(@"[reportsFromFeed count]: %i", [self.reportsFromFeed count]);

	// --	Get reportsFromFeed ready for Herdometer action.
	[self markAllReportsNotShown];
	[self setCountryGeodataWhereKnown];
	
	[self.timerInititiateAnnotateReport invalidate];
	self.timerInititiateAnnotateReport = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(initiateAnnotateReport) userInfo:nil repeats:NO];
}

- (void) initiateAnnotateReport {
	
	BOOL shouldContinue = ([self.reportsFromFeed count] > 0);
	if (!shouldContinue) {
		//NSLog(@"[self initiateAnnotateReport] found: !shouldContinue");
		[self.reportMapView deselectAnnotation:self.theAnnotation animated:YES];
		[self.timerInititiateAnnotateReport invalidate];
		self.timerInititiateAnnotateReport = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(initiateAnnotateReport) userInfo:nil repeats:NO];
		return;
	}
		
	NSString *countryOfCurrentReportToBeAnnotated = [[[self.reportsFromFeed objectAtIndex:self.indexOfCurrentReportToBeAnnotated] objectForKey:@"description"] objectForKey:@"Reporter Country"];
	
	if ([[self.reportsFromFeed objectAtIndex:self.indexOfCurrentReportToBeAnnotated] objectForKey:@"geodata"] == nil) {
		[WebservicesController getRoughGeocodeForCountry:countryOfCurrentReportToBeAnnotated callbackDelegate:self];
	} else {
		[self annotateReport];
	}
}

- (void) annotateReport {
	// --	Get the report info ready.
	NSMutableDictionary *geometryDict = [[self.reportsFromFeed objectAtIndex:self.indexOfCurrentReportToBeAnnotated] objectForKey:@"geodata"];
	NSMutableDictionary *reportDict = [self.reportsFromFeed objectAtIndex:self.indexOfCurrentReportToBeAnnotated];
	
	// --	Add the annotation.
	if (self.theAnnotation != nil) {
		[self.reportMapView removeAnnotation:self.theAnnotation];
		self.theAnnotation = nil;
		[self.theAnnotation release];
	}
	self.theAnnotation = [[ReportAnnotation alloc] initWithBasics:[[[geometryDict objectForKey:@"location"] objectForKey:@"lng"] doubleValue]
														 latitude:[[[geometryDict objectForKey:@"location"] objectForKey:@"lat"] doubleValue]
															title:[self getAnnotationTitleString:reportDict]
														 subtitle:[self getAnnotationSubtitleString:reportDict]
													   sheepColor:[self getSheepColorInt:reportDict]];
	[self.reportMapView addAnnotation:self.theAnnotation];
	[self.reportMapView selectAnnotation:self.theAnnotation animated:YES];

//	NSString *logAnnotatingReport = [NSString stringWithFormat:@"Annotating report at index %i, URL %@, country %@, lat %f, lng %f",
//									self.indexOfCurrentReportToBeAnnotated,
//									[[reportDict objectForKey:@"description"] objectForKey:@"URL"],
//									[[reportDict objectForKey:@"description"] objectForKey:@"Reporter Country"],
//									self.theAnnotation.coordinate.latitude,
//									self.theAnnotation.coordinate.longitude];
//	NSLog(@"%@", logAnnotatingReport);
	
	// --	Mark this report as 'shown'.
	[[self.reportsFromFeed objectAtIndex:self.indexOfCurrentReportToBeAnnotated] setObject:@"true" forKey:@"shown"];
	
	// --	Get ready to annotate the next report...
	self.indexOfCurrentReportToBeAnnotated = [self indexOfReportToBeAnnotatedNext];
	[self.timerInititiateAnnotateReport invalidate];
	self.timerInititiateAnnotateReport = [NSTimer scheduledTimerWithTimeInterval:4.5 target:self selector:@selector(initiateAnnotateReport) userInfo:nil repeats:NO];
}

- (NSString *) getAnnotationTitleString:(NSMutableDictionary *) reportDict {

	// --	Process the report URL.
	NSString *reportUrl = [[reportDict objectForKey:@"description"] objectForKey:@"URL"];
	return reportUrl;
}

- (NSString *) getAnnotationSubtitleString:(NSMutableDictionary *)reportDict {

	// --	Process the 'reported' string
	NSString *providedTitle = [reportDict objectForKey:@"title"];
	NSRange reportedRange = [providedTitle rangeOfString:@"reported"];
	NSString *reportedString = [providedTitle substringWithRange:NSMakeRange(reportedRange.location, [providedTitle length] - reportedRange.location)];

	// --	Process the report time.
	NSString *unformattedDateString = [[reportDict objectForKey:@"description"] objectForKey:@"Report Date"];
	NSDateFormatter *inputFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[inputFormatter setDateFormat:@"MMM dd, yyyy hh:mm:ss a"];	
	NSDate *reportDate = [inputFormatter dateFromString:unformattedDateString];
	NSTimeInterval secondsSinceReport = [[NSDate date] timeIntervalSinceDate:reportDate];
	NSString *timeString;
	if (((int)(secondsSinceReport / (60*60))) > 1) {
		timeString = [NSString stringWithFormat:@"%i hrs ago", (int)(secondsSinceReport / (60*60))];
	} else if (((int)(secondsSinceReport / 60)) > 1) {
		timeString = [NSString stringWithFormat:@"%i min ago", (int)(secondsSinceReport / (60))];
	}  else {
		timeString = [NSString stringWithFormat:@"%i sec ago", (int)(secondsSinceReport)];
	}
	
	// --	Combine.
	NSString *subtitleString = [NSString stringWithFormat:@"%@ (%@)", reportedString, timeString];
	
	return subtitleString;
}

- (int) getSheepColorInt:(NSMutableDictionary *)reportDict {

	int sheepColorInt = 2;
	NSRange rangeOfSubstringInaccessible = [[reportDict objectForKey:@"title"] rangeOfString:@"inaccessible"];
	if (rangeOfSubstringInaccessible.length == 0) {
		sheepColorInt = 0;
	}
	return sheepColorInt;
}

- (void) setCountryGeodataWhereKnown {

	// --	Build an array of country/geodata dicts using our plist.
	NSString *plistPath = [[NSBundle mainBundle] bundlePath];
	NSString *finalPlistPath = [plistPath stringByAppendingPathComponent:@"country_locations.plist"];
	NSArray *countriesWithCoordinates = [NSArray arrayWithContentsOfFile:finalPlistPath];

	// --	For each report in reportsFromFeed: if the report's country is found in our new array, grab its geodata from the array.	
	for (NSMutableDictionary *reportDict in self.reportsFromFeed) {
		NSString *countryInReport = [[reportDict objectForKey:@"description"] objectForKey:@"Reporter Country"];
		for (NSDictionary *country in countriesWithCoordinates) {
			if ([countryInReport isEqualToString:[country objectForKey:@"country_name"]]) {
				NSString *lng = [[country objectForKey:@"lng"] stringValue];
				NSString *lat = [[country objectForKey:@"lat"] stringValue];
				NSMutableDictionary *location = [NSMutableDictionary dictionary];
				[location setObject:lng forKey:@"lng"];
				[location setObject:lat forKey:@"lat"];
				NSMutableDictionary *geodata = [NSMutableDictionary dictionary];
				[geodata setObject:location forKey:@"location"];
				[reportDict setObject:geodata forKey:@"geodata"];
			}
		}
	}
}


- (void) getRoughGeocodeForCountryCallbackHandler:(ASIHTTPRequest *)request {
	
	NSDictionary *responseDictionary = [WebservicesController getDictionaryFromJSONData:[request responseData]];
	
	// --	Store the received info in the report dictionary.
	NSMutableDictionary *geometryDict = [[[responseDictionary objectForKey:@"results"] objectAtIndex:0] objectForKey:@"geometry"];
	NSMutableDictionary *reportDict = [self.reportsFromFeed objectAtIndex:self.indexOfCurrentReportToBeAnnotated];
	[reportDict setObject:geometryDict forKey:@"geodata"];
	
	[self annotateReport];
}

- (BOOL) allReportsAreShown {

	for (NSDictionary *report in self.reportsFromFeed) {
		if (![[report objectForKey:@"shown"] isEqualToString:@"true"]) {
			return FALSE;
		}
	}
	return TRUE;
}

- (void) markAllReportsNotShown {
	NSLog(@"entered markAllReportsNotShown"); 
	
	for (NSMutableDictionary *report in self.reportsFromFeed) {
		[report setObject:@"false" forKey:@"shown"];
	}
}

- (BOOL) reportShouldBeNext:(NSMutableDictionary *)report doesCountryMatter:(BOOL)countryMatters {
	// --	Make sure it hasn't been shown.
	if ([[report objectForKey:@"shown"] isEqualToString:@"true"]) {
		return FALSE;
	}
	// --	(only if countryMatters is YES ...) Check whether the country is the same as the country of the currently annotated report.
	if (countryMatters) {
		// --	Make sure the country isn't same as the current report's country.
		NSString *candidateReportCountry = [[report objectForKey:@"description"] objectForKey:@"Reporter Country"];
		NSString *currentReportCountry = [[[self.reportsFromFeed objectAtIndex:self.indexOfCurrentReportToBeAnnotated] objectForKey:@"description"] objectForKey:@"Reporter Country"];
		if ([candidateReportCountry isEqualToString:currentReportCountry]) {
			return FALSE;
		}
	}
	return TRUE;
}

- (int) indexOfReportToBeAnnotatedNext {
	// --	If all reports are marked 'shown', change them all to 'unshown'.
	if ([self allReportsAreShown]) {
		[self markAllReportsNotShown];
	}
	// --	Look for a report that satisfies all criteria.
	for (NSMutableDictionary *report in self.reportsFromFeed) {
		if ([self reportShouldBeNext:report doesCountryMatter:YES]) {
			return [self.reportsFromFeed indexOfObject:report];
		}
	}
	// --	If that didn't return, just pick one that hasn't been shown, even in the same country.
	for (NSMutableDictionary *report in self.reportsFromFeed) {
		if ([self reportShouldBeNext:report doesCountryMatter:NO]) {
			return [self.reportsFromFeed indexOfObject:report];
		}
	}
	
	return 0;
}

+ (CGFloat)annotationPadding {
	NSLog(@"annotationPAdding");
	return 10.0f;
}
+ (CGFloat)calloutHeight {
	NSLog(@"calloutHeight");
	return 40.0f;
}


#pragma mark -
#pragma mark self as MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation {
	MKAnnotationView *reportAnnotationView = [[[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"reportAnnotation"] autorelease];
	ReportAnnotation *thisAnnotation = annotation;
	UIImage *sheepPin;
	if (thisAnnotation.sheepColor == 0) {
		sheepPin = [UIImage imageNamed:@"icon_herdometer_sheep_green_smaller"];
	} else if (thisAnnotation.sheepColor == 2) {
		sheepPin = [UIImage imageNamed:@"icon_herdometer_sheep_orange_smaller"];
	}
	reportAnnotationView.image = sheepPin;
	reportAnnotationView.canShowCallout = YES;

	return reportAnnotationView;
}
				

@end
