//
//  VC_Home.m
//  Herdict
//
//  Created by Christian Brink on 3/5/11.
//  Copyright 2011 Herdict. All rights reserved.
//

#import "VC_Home.h"

@implementation VC_Home

@synthesize buttonCancelSearch;

@synthesize theUrlBar;
@synthesize reportMapView;
@synthesize theUrlBarMenu;
@synthesize theSiteView;
@synthesize theReportForm;
@synthesize theScreen;

@synthesize reportsFromFeed;
@synthesize indexOfCurrentReportToBeAnnotated;
@synthesize theAnnotation;
@synthesize timerInititiateAnnotateReport;

@synthesize ipAddress;


#pragma mark UIViewController lifecycle

- (void) viewDidLoad {
	[super viewDidLoad];
		
	self.view.userInteractionEnabled = YES;
	
	self.view.backgroundColor = [UIColor grayColor];

	self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
	self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.893 green:0.903 blue:0.923 alpha:0.9]; // UIColorFromRGB(0xe4eaec);
	UIImage *herdictBadgeImage = [UIImage imageNamed:@"herdict_badge"];
	UIImageView *herdictBadgeImageView = [[[UIImageView alloc] initWithImage:herdictBadgeImage] autorelease];
	[herdictBadgeImageView setFrame:CGRectMake(
											   herdictBadgeImageView.frame.origin.x,
											   herdictBadgeImageView.frame.origin.y,
											   herdictBadgeImageView.frame.size.width * 0.8,
											   herdictBadgeImageView.frame.size.height * 0.8)];
	self.navigationItem.titleView = herdictBadgeImageView;
	[herdictBadgeImageView release];

	[self setButtonInfoNotSelected];
	[self setButtonWifiNotSelected];
	
	// --	Set up buttonCancelSearch.
	self.buttonCancelSearch = [CustomBarButton buttonWithType:UIButtonTypeCustom];
	self.buttonCancelSearch.notSelectedBackground.floatRed = 0.935;
	self.buttonCancelSearch.notSelectedBackground.floatGreen = 0.945;
	self.buttonCancelSearch.notSelectedBackground.floatBlue = 0.965;
	self.buttonCancelSearch.theTitle.text = @"Cancel";
	[self.buttonCancelSearch addTarget:self action:@selector(selectedCancelSearch) forControlEvents:UIControlEventTouchUpInside];
	
	// --	Set up theUrlBar.
	self.theUrlBar = [[URLBar alloc] initWithFrame:CGRectMake(0,0,320,38)];
	[self.theUrlBar setDelegate:self];
	[self.view addSubview:self.theUrlBar];
	
	// --	Set up reportMapView.
	self.reportMapView = [[MKMapView alloc] initWithFrame:CGRectMake(0,38,320,378)];
	self.reportMapView.delegate = self;
	self.reportMapView.userInteractionEnabled = YES;
	self.reportMapView.scrollEnabled = NO;
	self.reportMapView.zoomEnabled = NO;
	[self.view addSubview:self.reportMapView];	
	self.indexOfCurrentReportToBeAnnotated = 0;
	
	// --	Set up theSiteView.
	self.theSiteView = [[SiteView alloc] initWithFrame:CGRectMake(0,416,320,378)];
	self.theSiteView.theDelegate = self;
	[self.view addSubview:self.theSiteView];
	
	// --	Set up theReportForm.
	self.theReportForm = [[ReportForm alloc] initWithFrame:CGRectMake(0, 416, 320, 378)];
	self.theReportForm.formTable.delegate = self;
	self.theReportForm.formTable.dataSource = self;
	[self.view addSubview:self.theReportForm];

	// --	Set up theUrlBarMenu.  (adding this subview after adding reportMapView, theSiteView, and theReportForm.. for z-ordering)
	self.theUrlBarMenu = [[BubbleMenu alloc] initWithFrame:CGRectMake(-65, -235, 150, 129)];
	self.theUrlBarMenu.menuOption1.text = @"Test Site";
	self.theUrlBarMenu.menuOption2.text = @"Get a Report";
	self.theUrlBarMenu.menuOption3.text = @"Submit a Report";
	[self.view addSubview:self.theUrlBarMenu];
	
	// --	Put up 'The Screen'.  (to catch all touches below theUrlBar.. forwards to [self touchesBegan--]) 
	self.theScreen = [[UIView alloc] initWithFrame:CGRectMake(0, 38, 320, 378)];
	[self.view addSubview:self.theScreen];
	[self.view bringSubviewToFront:self.theScreen];
	
	// --	Hit the 5 endpoints of the Herdict API to get up-to-date Report Form options.  
	[WebservicesController getHerdictDicts:self];	
}

- (BOOL) canBecomeFirstResponder {
	return YES;
}

- (void) viewWillAppear:(BOOL)animated {
	NSLog(@"VC_Home viewWillApppear");
	[self fetchTickerFeed];
	[WebservicesController getIp:self];
	[self becomeFirstResponder];
	
	[self.theUrlBarMenu touchesBegan:nil withEvent:nil];
}

- (void) viewWillDisappear:(BOOL)animated {

	[self.timerInititiateAnnotateReport invalidate];
}

- (void) dealloc {
	[theUrlBar release];
		
	[ipAddress release];
	
	[reportsFromFeed release];
	[reportMapView release];
	[theAnnotation release];
	
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
	[self setCountryDataWhereKnown];
	
	self.timerInititiateAnnotateReport = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(initiateAnnotateReport) userInfo:nil repeats:NO];
}

- (void) initiateAnnotateReport {
	
	BOOL shouldContinue = YES;
	shouldContinue = shouldContinue && ([self.reportsFromFeed count] > 0);
	shouldContinue = shouldContinue && (self.theSiteView.frame.origin.y > 300);
	shouldContinue = shouldContinue && (self.theReportForm.frame.origin.y > 300);
	if (!shouldContinue) {
		//NSLog(@"[self initiateAnnotateReport] found: !shouldContinue");
		[self.reportMapView deselectAnnotation:self.theAnnotation animated:YES];
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

	NSString *logAnnotatingReport = [NSString stringWithFormat:@"Annotating report at index %i, URL %@, country %@, lat %f, lng %f",
									self.indexOfCurrentReportToBeAnnotated,
									[[reportDict objectForKey:@"description"] objectForKey:@"URL"],
									[[reportDict objectForKey:@"description"] objectForKey:@"Reporter Country"],
									self.theAnnotation.coordinate.latitude,
									self.theAnnotation.coordinate.longitude];
//	NSLog(@"%@", logAnnotatingReport);
	
	// --	Mark this report as 'shown'.
	[[self.reportsFromFeed objectAtIndex:self.indexOfCurrentReportToBeAnnotated] setObject:@"true" forKey:@"shown"];
	
	// --	Get ready to annotate the next report...
	self.indexOfCurrentReportToBeAnnotated = [self indexOfReportToBeAnnotatedNext];
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

- (void) setCountryDataWhereKnown {
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

#pragma mark -
#pragma mark self as UISearchBarDelegate

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	[self urlBarMenuOptionSelected:[NSNumber numberWithInt:1]];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
	NSLog(@"searchBarTextDidBeginEditing");
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:self.buttonCancelSearch] autorelease];
	
	[self.timerInititiateAnnotateReport invalidate];
	[self.reportMapView removeAnnotation:self.theAnnotation];
	
	[self.theUrlBarMenu show];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
	[self setButtonWifiNotSelected];

	self.timerInititiateAnnotateReport = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(initiateAnnotateReport) userInfo:nil repeats:NO];

	[NSTimer scheduledTimerWithTimeInterval:0.075 target:self.theUrlBarMenu selector:@selector(hide) userInfo:nil repeats:NO];
}


#pragma mark -
#pragma mark Some callback handlers

- (void) getRoughGeocodeForCountryCallbackHandler:(ASIHTTPRequest *)request {
	// --	Outsource the basic request callback handling to (initialResponseHandling:).
	NSDictionary *responseDictionary = [self initialResponseHandling:request];
	
	// --	Store the received info in the report dictionary.
	NSMutableDictionary *geometryDict = [[[responseDictionary objectForKey:@"results"] objectAtIndex:0] objectForKey:@"geometry"];
	NSMutableDictionary *reportDict = [self.reportsFromFeed objectAtIndex:self.indexOfCurrentReportToBeAnnotated];
	[reportDict setObject:geometryDict forKey:@"geodata"];
	
	[self annotateReport];
}
	
- (void) getIpCallbackHandler:(ASIHTTPRequest *)theRequest {
	NSDictionary *ipDict = [WebservicesController getDictionaryFromJSONData:[theRequest responseData]];
	self.ipAddress = [ipDict objectForKey:@"ip"];
	[WebservicesController getInfoForIpAddress:self.ipAddress callbackDelegate:self];

}

- (void) getInfoForIpAddressCallbackHandler:(ASIHTTPRequest*)request {
	// --	Fix the response string, which may contain invalid JSON.
	NSString *responseString = [request responseString];
	responseString = [responseString stringByReplacingOccurrencesOfString:@"\"valuta_rate\":," withString:@""];
	NSData *fixedResponseData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
	self.theReportForm.ipInfoDict = [WebservicesController getDictionaryFromJSONData:fixedResponseData];
	self.theReportForm.detected_ispName = [NSString stringWithString:[[self.theReportForm.ipInfoDict objectForKey:@"isp"] objectForKey:@"name"]];
	self.theReportForm.accordingToUser_ispName = self.theReportForm.detected_ispName;
	self.theReportForm.detected_countryCode = [NSString stringWithString:[[self.theReportForm.ipInfoDict objectForKey:@"country"] objectForKey:@"code"]];
	self.theReportForm.accordingToUser_countryCode = self.theReportForm.detected_countryCode;
}

#pragma mark -
#pragma mark Herdict API callbacks
- (NSMutableDictionary *) dictionaryFromArrayOfPairs:(NSArray *)theArray {
	NSMutableDictionary *aDict = [NSMutableDictionary dictionary];
	// --	Convert array of dicts into a single dict (and where necessary remove quotation marks from 'label' strings).
	for (int i = 0; i < [theArray count]; i++) {
		NSString *labelWithoutQuotes = [[theArray objectAtIndex:i] objectForKey:@"label"];
		labelWithoutQuotes = [labelWithoutQuotes stringByReplacingOccurrencesOfString:@"\"" withString:@""];
		[aDict setObject:labelWithoutQuotes forKey:[[theArray objectAtIndex:i] objectForKey:@"value"]];
	}
	[aDict setObject:@"Tap to Select" forKey:@"blank"];
	return aDict;
}
- (void) getCategoriesCallbackHandler:(ASIHTTPRequest*)request {
	NSMutableArray *responseArray = [NSMutableArray array];
	responseArray = [WebservicesController getArrayFromJSONData:[request responseData]];
	self.theReportForm.t01dictCategories = [self dictionaryFromArrayOfPairs:responseArray];
}
- (void) getCountriesCallbackHandler:(ASIHTTPRequest*)request {
	NSMutableArray *responseArray = [NSMutableArray array];
	responseArray = [WebservicesController getArrayFromJSONData:[request responseData]];
	self.theReportForm.t02dictCountries = [self dictionaryFromArrayOfPairs:responseArray];
}
- (void) getLocationsCallbackHandler:(ASIHTTPRequest*)request {
	NSMutableArray *responseArray = [NSMutableArray array];
	responseArray = [WebservicesController getArrayFromJSONData:[request responseData]];
	self.theReportForm.t03dictLocations = [self dictionaryFromArrayOfPairs:responseArray];
}
- (void) getInterestsCallbackHandler:(ASIHTTPRequest*)request {
	NSMutableArray *responseArray = [NSMutableArray array];
	responseArray = [WebservicesController getArrayFromJSONData:[request responseData]];
	self.theReportForm.t04dictInterests = [self dictionaryFromArrayOfPairs:responseArray];
}
- (void) getReasonsCallbackHandler:(ASIHTTPRequest*)request {
	NSMutableArray *responseArray = [NSMutableArray array];
	responseArray = [WebservicesController getArrayFromJSONData:[request responseData]];
	self.theReportForm.t05dictReasons = [self dictionaryFromArrayOfPairs:responseArray];
}

#pragma mark getSiteSummary

- (void) getSiteSummaryCallbackHandler:(ASIHTTPRequest*)request {
	
	// --	Outsource the basic request callback handling to (initialResponseHandling:).
	NSDictionary *siteSummaryDictionary = [self initialResponseHandling:request];

	// --	We handle the site summary content right here - theSiteView and theSiteView.SiteSummary never have to know about it.
	NSString *countryCode = [siteSummaryDictionary objectForKey:@"countryCode"];
	NSString *countryString = [self.theReportForm.t02dictCountries objectForKey:countryCode];
	int countryInaccessibleCount = [[siteSummaryDictionary objectForKey:@"countryInaccessibleCount"] intValue];
	int globalInaccessibleCount = [[siteSummaryDictionary objectForKey:@"globalInaccessibleCount"] intValue];
	int sheepColor = [[siteSummaryDictionary objectForKey:@"sheepColor"] intValue];
	int siteId = [[siteSummaryDictionary objectForKey:@"siteId"] intValue];
	
	NSString *messageString = [NSString stringWithFormat:@"%d   times in %@\n%d   times around the world", countryInaccessibleCount, countryString, globalInaccessibleCount];
	self.theSiteView.theSiteSummary.textView2.text = messageString;

	if (sheepColor == 0) {
		self.theSiteView.theSiteSummary.theBackground.backgroundColor = UIColorFromRGB(0x98D428);
	} else if (sheepColor == 1) {
		self.theSiteView.theSiteSummary.theBackground.backgroundColor = UIColorFromRGB(0x98D428);
	} else if (sheepColor == 2) {
		self.theSiteView.theSiteSummary.theBackground.backgroundColor = UIColorFromRGB(0xFF6600);
	}
	
	[self.theSiteView showSiteSummary];
}

#pragma mark -
#pragma mark Utilities

- (NSMutableDictionary *) initialResponseHandling:(ASIHTTPRequest *)theRequest {
	//	Have responseData converted to a responseDictionary and pull out requestOutcome.
	NSMutableDictionary *responseDictionary = [NSMutableDictionary dictionary];
	[responseDictionary addEntriesFromDictionary:[WebservicesController getDictionaryFromJSONData:[theRequest responseData]]];	
	return responseDictionary;
}

- (NSString *) fixUpTypedUrl {

	NSString *typedUrl = [[[self.theUrlBar subviews] objectAtIndex:1] text];

	typedUrl = [typedUrl lowercaseString];
	
	NSRange rangeHttp = [typedUrl rangeOfString:@"http"];
	if (rangeHttp.location == NSNotFound) {
		NSLog(@"location isEqual NSNotFound");
		typedUrl = [NSString stringWithFormat:@"%@%@", @"http://", typedUrl];
	}
	
	return typedUrl;
}


- (void) urlBarMenuOptionSelected:(NSNumber *)optionNumber {
	NSString *theUrl = [[[self.theUrlBar subviews] objectAtIndex:1] text];

	// --	Check whether the entry is blank.
	if ([theUrl length] == 0) {
		[self.theUrlBarMenu removeSelectionBackground];				
		UIAlertView *alertNoUrl = [[UIAlertView alloc] initWithTitle:nil message:@"Please enter a complete URL." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alertNoUrl show];
		[alertNoUrl release];
		return;
	}
	// --	Fix up the Url.
	theUrl = [self fixUpTypedUrl];
	self.theUrlBar.text = theUrl;

	// --	Get the search bar and menu out of the way.
	[NSTimer scheduledTimerWithTimeInterval:0.0 target:self.theUrlBar selector:@selector(resignFirstResponder) userInfo:nil repeats:NO];
	[NSTimer scheduledTimerWithTimeInterval:1.5 target:self.theUrlBarMenu selector:@selector(removeSelectionBackground) userInfo:nil repeats:NO];				

	if ([optionNumber intValue] == 1) {
		// --	Show selection background.
		self.theUrlBarMenu.selectionBackground.backgroundColor = [UIColor blueColor];
		[self.theUrlBarMenu.selectionBackground setFrame:CGRectMake(5, 31, 139, 30)];
		
		// --	Do appropriate stuff.
		[self.theSiteView loadUrl:theUrl];
		return;
	}
	if ([optionNumber intValue] == 2) {
		// --	Show selection background.
		self.theUrlBarMenu.selectionBackground.backgroundColor = [UIColor blueColor];
		[self.theUrlBarMenu.selectionBackground setFrame:CGRectMake(5, 61, 139, 30)];

		// --	Do appropriate stuff.
		[self.theSiteView loadUrl:theUrl];
		theUrl = [theUrl stringByReplacingOccurrencesOfString:@"http://" withString:@""];
		theUrl = [theUrl stringByReplacingOccurrencesOfString:@"www." withString:@""];		
		[WebservicesController getSummaryForUrl:theUrl forCountry:@"US" urlEncoding:@"none" apiVersion:@"FF1.0" callbackDelegate:self];
		return;
	}
	if ([optionNumber intValue] == 3) {
		// --	Show selection background.
		self.theUrlBarMenu.selectionBackground.backgroundColor = [UIColor blueColor];
		[self.theUrlBarMenu.selectionBackground setFrame:CGRectMake(5, 91, 139, 30)];
		
		// --	Do appropriate stuff.
		[self.theSiteView loadUrl:theUrl];
		[self.theReportForm showForm];
		return;
	}		
}

#pragma mark -
#pragma mark BarButtonItems


- (void) setButtonInfoNotSelected {
	UIImage *infoImage = [UIImage imageNamed:@"buttonInfo.png"];
	UIImageView *infoImageView = [[[UIImageView alloc] initWithImage:infoImage] autorelease];
	[infoImageView setFrame:CGRectMake(0, 0, 57, 30)];
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:infoImageView] autorelease];
	[self.navigationItem.leftBarButtonItem setTarget:self]; 
	[self.navigationItem.leftBarButtonItem setAction:@selector(selectButtonInfo)];	
}

- (void) setButtonInfoSelected {	
	UIImage *imageInfoSelected = [UIImage imageNamed:@"buttonInfoSelected.png"];
	UIImageView *imageInfoSelectedView = [[[UIImageView alloc] initWithImage:imageInfoSelected] autorelease];
	[imageInfoSelectedView setFrame:CGRectMake(0, 0, 57, 30)];
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:imageInfoSelectedView] autorelease];
}

- (void) setButtonWifiNotSelected {
	NSLog(@"setButtonWifiNotSelected");
	UIImage *wifiImage = [UIImage imageNamed:@"buttonWiFi.png"];
	UIImageView *wifiImageView = [[[UIImageView alloc] initWithImage:wifiImage] autorelease];
	[wifiImageView setFrame:CGRectMake(0, 0, 57, 30)];
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:wifiImageView] autorelease];
	[self.navigationItem.rightBarButtonItem setTarget:self];
	[self.navigationItem.rightBarButtonItem setAction:@selector(selectButtonWifi)];
}	

- (void) setButtonWifiSelected {
	
}

- (void) selectButtonInfo {
	[self setButtonInfoSelected];
//	[self performSelector:setButtonInfoNotSelected withObject:nil afterDelay:0.15];
	
	// TODO: actually load the 'About' view...
}

- (void) selectedHome {
	
}

- (void) selectButtonWifi {

}

- (void) dismissMyIsp {
	
}

- (void) selectedCancelSearch {
	[self.buttonCancelSearch setSelected];
	[NSTimer scheduledTimerWithTimeInterval:0.05 target:self.buttonCancelSearch selector:@selector(setNotSelected) userInfo:nil repeats:NO];
	[NSTimer scheduledTimerWithTimeInterval:0.05 target:self.theUrlBar selector:@selector(resignFirstResponder) userInfo:nil repeats:NO];
}

#pragma mark -
#pragma mark UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if (self.theReportForm.siteIsAccessible) {
		return 7;
	}
	return 8;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section == 0)
        return 6;
    return 1.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return 1.0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	return [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)] autorelease];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	return [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)] autorelease];
}	
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

	FormCell *cell = [[[FormCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"] autorelease];
	
	int indexPathSection = indexPath.section;
	
	// --	'Is the Site Accessible?'.
	if (indexPathSection == 0) {
		UIImage *iconImage = [UIImage imageNamed:@"146-gavel@2x.png"];
		cell.theIconView.image = iconImage;
		cell.cellLabel.text = @"Site Accessible";
		if (self.theReportForm.siteIsAccessible) {
			cell.cellDetailLabel.text = @"Yes";
		} else {
			cell.cellDetailLabel.text = @"No";
		}
		return cell;
	}
	if (indexPathSection == 1) {
		if (self.theReportForm.siteIsAccessible) {
			indexPathSection++;																			// remember we're using this trick 
		} else {
			UIImage *iconImage = [UIImage imageNamed:@"20-gear2@2x.png"];
			cell.theIconView.image = iconImage;
			cell.cellLabel.text = @"Reason";
			cell.cellDetailLabel.text = [self.theReportForm.t05dictReasons objectForKey:self.theReportForm.keyReason];
			return cell;
		}
	}
	if (indexPathSection == 2) {
		UIImage *iconImage = [UIImage imageNamed:@"15-tags@2x.png"];
		cell.theIconView.image = iconImage;
		cell.cellLabel.text = @"Category";
		cell.cellDetailLabel.text = [self.theReportForm.t01dictCategories objectForKey:self.theReportForm.keyCategory];
		return cell;
	}
	if (indexPathSection == 3) {
		UIImage *iconImage = [UIImage imageNamed:@"186-ruler@2x.png"];
		cell.theIconView.image = iconImage;
		cell.cellLabel.text = @"Usefulness";
		cell.cellDetailLabel.text = [self.theReportForm.t04dictInterests objectForKey:self.theReportForm.keyInterest];
		return cell;
	}
	if (indexPathSection == 4) {
		UIImage *iconImage = [UIImage imageNamed:@"59-flag@2x.png"];
		cell.theIconView.image = iconImage;
		[cell.theIconView setFrame:CGRectMake(10, 6, 20, 28)];
		cell.cellLabel.text = @"Country";
		cell.cellDetailLabel.text = [self.theReportForm.t02dictCountries objectForKey:self.theReportForm.accordingToUser_countryCode];
		return cell;
	}
	if (indexPathSection == 5) {
		UIImage *iconImage = [UIImage imageNamed:@"193-location-arrow@2x.png"];
		cell.theIconView.image = iconImage;
		cell.cellLabel.text = @"Location";
		cell.cellDetailLabel.text = [self.theReportForm.t03dictLocations objectForKey:self.theReportForm.keyLocation];
		return cell;
	}
	if (indexPathSection == 6) {
		UIImage *iconImage = [UIImage imageNamed:@"55-wifi@2x.png"];
		cell.theIconView.image = iconImage;
		[cell.theIconView setFrame:CGRectMake(6, 10, 28, 20)];
		cell.cellLabel.text = @"ISP";
		cell.cellDetailLabel.text = self.theReportForm.accordingToUser_ispName;
		return cell;
	}
	if (indexPathSection == 7) {
		UIImage *iconImage = [UIImage imageNamed:@"09-chat-2@2x.png"];
		cell.theIconView.image = iconImage;
		cell.cellLabel.text = @"Comments";
		cell.cellDetailLabel.text = self.theReportForm.comments;
		return cell;
	}
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	// --	Disable form interaction.
	self.theReportForm.formTable.userInteractionEnabled = NO;

	// --	Cancel button.
	
	
	// --	Apply white screen.
	[UIView animateWithDuration:0.2 delay:0 options:nil
					 animations:^{						 
						 // --	theReportForm.formBackground
						 self.theReportForm.formBackground.backgroundColor = [UIColor whiteColor];
						 self.theReportForm.formBackground.alpha = 1;
						
						 // --	cells
 						 int countCells = [self.theReportForm.formTable numberOfSections];
 						 for (int i = 0; i < countCells; i++) {	
							 FormCell *nonSelectedCell = [self.theReportForm.formTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:i]];							
							 if (i != indexPath.section) {
								 nonSelectedCell.whiteScreen.alpha = 1;
							 }
						 }
					 } completion:^(BOOL finished){
					 }
	 ];
	
	// --	Slide the whole tableView up so the selected cell is at the top.
	[UIView animateWithDuration:0.15 delay:0.1 options:UIViewAnimationOptionCurveEaseOut
					 animations:^{						 
						 [self.view bringSubviewToFront:self.theUrlBar];
						 int rowSpan = [self.theReportForm.formTable.delegate tableView:self.theReportForm.formTable heightForRowAtIndexPath:indexPath];
						 rowSpan = rowSpan + [self.theReportForm.formTable.delegate tableView:self.theReportForm.formTable heightForFooterInSection:indexPath.section];
						 int slideSpan = rowSpan * indexPath.section;						 
						 [self.theReportForm.formTable setCenter:CGPointMake(
																			 self.theReportForm.formTable.center.x,
																			 self.theReportForm.formTable.center.y - slideSpan)];						 
					  } completion:^(BOOL finished){
					  }
	 ];
}

- (void) returnToFormTable {

	// --	Enable form interaction.
	self.theReportForm.formTable.userInteractionEnabled = YES;

	// --	Slide the tableView back to its normal frame.
	[UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveEaseOut
					 animations:^{
						 [self.theReportForm.formTable setFrame:self.theReportForm.formTableNormalFrame];
					 } completion:^(BOOL finished){
					 }
	 ];	
	
	// --	Remove white screen.
	[UIView animateWithDuration:0.2 delay:0.1 options:nil
					 animations:^{						 
						 // --	theReportForm.formBackground
						 self.theReportForm.formBackground.backgroundColor = [UIColor blackColor];
						 self.theReportForm.formBackground.alpha = 0.8;
						 
						 // --	cells
 						 int countCells = [self.theReportForm.formTable numberOfSections];
 						 for (int i = 0; i < countCells; i++) {
							 FormCell *nonSelectedCell = [self.theReportForm.formTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:i]];							
							 nonSelectedCell.whiteScreen.alpha = 1;
						 }
					 } completion:^(BOOL finished){
					 }
	 ];	
}

#pragma mark -
#pragma mark UITouch

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
//	NSLog(@"VC_Home touchesBegan");
	CGPoint touchPoint;
	
	touchPoint = [touch locationInView:self.theSiteView.theSiteSummary.hideLabel];
	if ([self.theSiteView.theSiteSummary.hideLabel pointInside:touchPoint withEvent:nil]) {
		[self.theSiteView hideSiteSummary];
		return;
	}
	touchPoint = [touch locationInView:self.theReportForm.hideLabel];
	if ([self.theReportForm.hideLabel pointInside:touchPoint withEvent:nil]) {
		[self.theReportForm hideForm];
		return;
	}
	touchPoint = [touch locationInView:self.theUrlBarMenu.menuOption1];
	if ([self.theUrlBarMenu.menuOption1 pointInside:touchPoint withEvent:nil]) {
		[self performSelector:@selector(urlBarMenuOptionSelected:) withObject:[NSNumber numberWithInt:1] afterDelay:0.2];
		return;
	}
	touchPoint = [touch locationInView:self.theUrlBarMenu.menuOption2];
	if ([self.theUrlBarMenu.menuOption2 pointInside:touchPoint withEvent:nil]) {
		[self performSelector:@selector(urlBarMenuOptionSelected:) withObject:[NSNumber numberWithInt:2] afterDelay:0.2];
		return;
	}
	touchPoint = [touch locationInView:self.theUrlBarMenu.menuOption3];
	if ([self.theUrlBarMenu.menuOption3 pointInside:touchPoint withEvent:nil]) {
		[self performSelector:@selector(urlBarMenuOptionSelected:) withObject:[NSNumber numberWithInt:3] afterDelay:0.2];
		return;
	}
	touchPoint = [touch locationInView:self.theSiteView.webViewFooter];
	if ([self.theSiteView.webViewFooter pointInside:touchPoint withEvent:nil]) {	
		if (self.theSiteView.theSiteSummary.frame.origin.y > 350) {
			[self urlBarMenuOptionSelected:[NSNumber numberWithInt:2]];
		} else {
			[self urlBarMenuOptionSelected:[NSNumber numberWithInt:3]];
		}
		return;
	}
	touchPoint = [touch locationInView:self.theSiteView.theWebView];
	if ([self.theSiteView.theWebView pointInside:touchPoint withEvent:nil]) {
		[self.theSiteView.theWebView touchesBegan:touches withEvent:event];
		return;
	}
	
	touchPoint = [touch locationInView:self.theUrlBar];
	if (![self.theUrlBar pointInside:touchPoint withEvent:nil]) {
		[self.theUrlBar resignFirstResponder];
	}
}

#pragma mark -
#pragma mark SiteViewDelegate methods
- (void) theSiteViewIsShowingWebView {
	[self.theScreen setFrame:CGRectMake(0, 436 - 60, 320, 334)];
}
- (void) theSiteViewIsShowingSiteSummary {
	[self.theScreen setFrame:CGRectMake(0, 436 - 180, 320, 334)];
}
- (void) theSiteViewIsHiding {
	// TODO: this method can't really be tested yet, since we don't yet have a Home button.
	self.theScreen.backgroundColor = [UIColor yellowColor];
	self.theScreen.alpha = 0.4;
	[self.theScreen setFrame:CGRectMake(0, 38, 320, 334)];
}

- (void) reverseFormTableWhiteOut {

	
}

@end
