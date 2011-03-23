//
//  VC_Home.m
//  Herdict
//
//  Created by Christian Brink on 3/5/11.
//  Copyright 2011 Herdict. All rights reserved.
//

#import "Constants.h"
#import "VC_Home.h"
#import "WebservicesController.h"

#define bottomLeftTab_onscreen_x 15
#define bottomLeftTab_onscreen_y 391
#define bottomLeftTab_onscreen_width 140
#define bottomLeftTab_onscreen_height 40
#define bottomLeftTab_offscreen_y 480
#define bottomRightTab_onscreen_x 165
#define bottomRightTab_onscreen_y 391
#define bottomRightTab_onscreen_width 140
#define bottomRightTab_onscreen_height 40
#define bottomRightTab_offscreen_y 480

#define networkInfoPlate_expanded_x 15
#define networkInfoPlate_expanded_y 340
#define networkInfoPlate_expanded_width 290
#define networkInfoPlate_expanded_height 140

@implementation VC_Home

@synthesize searchButtonCancel;
@synthesize theSearchBar;
@synthesize theSearchMenu;

@synthesize reportsFromFeed;
@synthesize indexOfCurrentReportToBeAnnotated;
@synthesize reportMapView;
@synthesize theAnnotation;
@synthesize timerInititiateAnnotateReport;

@synthesize theSiteView;

@synthesize stateHome;

@synthesize ipString;
@synthesize ipInfoDict;
@synthesize ispString;
@synthesize countryDict;

#pragma mark UIViewController lifecycle

- (void) viewDidLoad {
	[super viewDidLoad];
		
	self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
	self.navigationController.navigationBar.tintColor = UIColorFromRGB(0xe4e7e9);
	UIImage *herdictBadgeImage = [UIImage imageNamed:@"herdict_badge"];
	UIImageView *herdictBadgeImageView = [[[UIImageView alloc] initWithImage:herdictBadgeImage] autorelease];
	[herdictBadgeImageView setFrame:CGRectMake(
											   herdictBadgeImageView.frame.origin.x,
											   herdictBadgeImageView.frame.origin.y,
											   herdictBadgeImageView.frame.size.width * 0.8,
											   herdictBadgeImageView.frame.size.height * 0.8)];
	self.navigationItem.titleView = herdictBadgeImageView;
	[herdictBadgeImageView release];
	self.view.backgroundColor = [UIColor grayColor];

	// --	Set up reportMapView.
	self.reportMapView = [[MKMapView alloc] initWithFrame:CGRectMake(0,38,320,378)];
	self.reportMapView.delegate = self;
	self.reportMapView.userInteractionEnabled = NO;
	self.reportMapView.zoomEnabled = NO;
	[self.view addSubview:self.reportMapView];	
	self.reportsFromFeed = [NSMutableArray array];
	self.indexOfCurrentReportToBeAnnotated = 0;
	self.countryDict = [NSMutableDictionary dictionary];	
	[WebservicesController getCountries:self];	
	
	// --	Set up the 'My ISP' stuff.
	self.ispString = [NSString stringWithString:@""];
	self.ipInfoDict = [NSMutableDictionary dictionary];
		
	self.stateHome = YES;
		
	// --	Set up theSearchBar.
	self.theSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0,0,320,38)];
	self.theSearchBar.placeholder = @"Enter URL to Get or Submit a Report";
	self.theSearchBar.tintColor = UIColorFromRGB(0xbfc7cb);
	self.theSearchBar.barStyle = UIBarStyleDefault;
	self.theSearchBar.autocorrectionType = UITextAutocorrectionTypeNo;
	self.theSearchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
	self.theSearchBar.keyboardType = UIKeyboardTypeURL;
	[self.theSearchBar setDelegate:self];
	[self.view addSubview:self.theSearchBar];
	UITextField *searchBarTextField = [[self.theSearchBar subviews] objectAtIndex:1];
	searchBarTextField.returnKeyType = UIReturnKeyGo;
	UIImage *urlIcon = [UIImage imageNamed:@"globe.png"];	
	UIImageView *urlIconView = [[UIImageView alloc] initWithImage:urlIcon];
	[searchBarTextField.leftView addSubview:urlIconView];

	// --	Set up the search bar's 'Cancel' button.
	self.searchButtonCancel = [CustomBarButton buttonWithType:UIButtonTypeCustom];
	self.searchButtonCancel.titleLabel.text = @"Cancel";
	[self.searchButtonCancel addTarget:self.theSearchBar action:@selector(resignFirstResponder) forControlEvents:UIControlEventTouchUpInside];
	NSLog(@"self.searchButtonCancel.titleLabel.text: %@", self.searchButtonCancel.titleLabel.text);
	
	// --	Set up theSearchMenu.
	self.theSearchMenu = [[SearchMenu alloc] initWithFrame:CGRectMake(215, -40, 155, 129)];
	[self.view addSubview:self.theSearchMenu];
	
	self.theSiteView = [[SiteView alloc] initWithFrame:CGRectMake(320,38,320,378)];
	[self.view addSubview:self.theSiteView];
}

- (void) viewWillAppear:(BOOL)animated {
	NSLog(@"VC_Home viewWillApppear");
	[self fetchTickerFeed];
	[WebservicesController getIp:self];
}

- (void) viewWillDisappear:(BOOL)animated {

	[self.timerInititiateAnnotateReport invalidate];
}

- (void) dealloc {
	[theSearchBar release];
		
	[ipString release];
	[ipInfoDict release];
	[ispString release];
	[countryDict release];
	
	[reportsFromFeed release];
	[reportMapView release];
	[theAnnotation release];
	
	[super dealloc];
}

#pragma mark -
#pragma mark Herdometer

- (void) fetchTickerFeed {
	
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
	if ((!self.stateHome) || [self.reportsFromFeed count] == 0) {
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
	NSDictionary *reportDict = [self.reportsFromFeed objectAtIndex:self.indexOfCurrentReportToBeAnnotated];
	
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
		for (NSDictionary *plistCountryDict in countriesWithCoordinates) {
			if ([countryInReport isEqualToString:[plistCountryDict objectForKey:@"country_name"]]) {
				NSString *lng = [[plistCountryDict objectForKey:@"lng"] stringValue];
				NSString *lat = [[plistCountryDict objectForKey:@"lat"] stringValue];
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

	[self searchMenuOptionSelected:1];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.searchButtonCancel];
	self.navigationItem.rightBarButtonItem.title = @"Cancel";
	
	[self.timerInititiateAnnotateReport invalidate];
	[self.reportMapView removeAnnotation:self.theAnnotation];
	
	[self.theSearchMenu show];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
	self.navigationItem.rightBarButtonItem = nil;

	self.timerInititiateAnnotateReport = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(initiateAnnotateReport) userInfo:nil repeats:NO];

	[self.theSearchMenu hide];
}

#pragma mark Some callbackHandlers

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
	self.ipString = [ipDict objectForKey:@"ip"];
	[WebservicesController getInfoForIpAddress:self.ipString callbackDelegate:self];

}

- (void) getInfoForIpAddressCallbackHandler:(ASIHTTPRequest*)request {
	// --	Fix the response string, which may contain invalid JSON.
	NSString *responseString = [request responseString];
	responseString = [responseString stringByReplacingOccurrencesOfString:@"\"valuta_rate\":," withString:@""];
	NSData *fixedResponseData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
	self.ipInfoDict = [WebservicesController getDictionaryFromJSONData:fixedResponseData];

}

- (void) getCountriesCallbackHandler:(ASIHTTPRequest*)request {
	NSMutableArray *responseArray = [NSMutableArray array];
	responseArray = [WebservicesController getArrayFromJSONData:[request responseData]];
	
	// --	Convert array of dicts into a single dict (and where necessary remove quotation marks from 'label' strings).
	for (int i = 0; i < [responseArray count]; i++) {
		NSString *labelWithoutQuotes = [[responseArray objectAtIndex:i] objectForKey:@"label"];
		labelWithoutQuotes = [labelWithoutQuotes stringByReplacingOccurrencesOfString:@"\"" withString:@""];
		[self.countryDict setObject:labelWithoutQuotes forKey:[[responseArray objectAtIndex:i] objectForKey:@"value"]];
	}	
}

#pragma mark getSiteSummary

- (void) getSiteSummaryCallbackHandler:(ASIHTTPRequest*)request {
	
	// --	Outsource the basic request callback handling to (initialResponseHandling:).
	NSDictionary *siteSummaryDictionary = [self initialResponseHandling:request];

	// --	We handle the site summary content right here - theSiteView and theSiteView.SiteSummary never have to know about it.
	NSString *countryCode = [siteSummaryDictionary objectForKey:@"countryCode"];
	NSString *countryString = [self.countryDict objectForKey:countryCode];
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

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
	NSLog(@"touchesBegan... touch.view: %@, [touch.view superview]: %@", touch.view, [touch.view superview]);
	CGPoint touchPoint = [touch locationInView:self.theSearchMenu];

	if (touch.view == self.reportMapView) {
		[self.theSearchBar resignFirstResponder];
	}
	
	if ([self.theSearchMenu point:touchPoint isInFrame:self.theSearchMenu.menuOption1.frame]) {
		[self searchMenuOptionSelected:1];		
		return;
	}
	if ([self.theSearchMenu point:touchPoint isInFrame:self.theSearchMenu.menuOption2.frame]) {		
		[self searchMenuOptionSelected:2];
		return;
	}
	if ([self.theSearchMenu point:touchPoint isInFrame:self.theSearchMenu.menuOption3.frame]) {
		[self searchMenuOptionSelected:3];
		return;
	}
	if (touch.view == self.theSiteView.webViewFooter) {
		[self searchMenuOptionSelected:2];
		return;
	}

	// --	If the touch is anywhere else...
	if (touch.view != self.theSearchBar) {
		[self.theSearchBar resignFirstResponder];
	}
}

- (NSString *) fixUpTypedUrl {

	NSString *typedUrl = [[[self.theSearchBar subviews] objectAtIndex:1] text];

	typedUrl = [typedUrl lowercaseString];
	
	NSRange rangeHttp = [typedUrl rangeOfString:@"http"];
	if (rangeHttp.location == NSNotFound) {
		NSLog(@"location isEqual NSNotFound");
		typedUrl = [NSString stringWithFormat:@"%@%@", @"http://", typedUrl];
	}
	
	return typedUrl;
}

#pragma mark -
#pragma mark self as SearchMenuDelegate

- (void) searchMenuOptionSelected:(int)optionNumber {
	NSString *theUrl = [[[self.theSearchBar subviews] objectAtIndex:1] text];

	// --	Check whether the entry is blank.
	if ([theUrl length] == 0) {
		[self.theSearchMenu removeSelectionBackground];				
		UIAlertView *alertNoUrl = [[UIAlertView alloc] initWithTitle:nil message:@"Please enter a complete URL." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alertNoUrl show];
		[alertNoUrl release];
		return;
	}
	// --	Fix up the Url.
	theUrl = [self fixUpTypedUrl];
	self.theSearchBar.text = theUrl;

	// --	Get the search bar and menu out of the way.
	[NSTimer scheduledTimerWithTimeInterval:0.5 target:self.theSearchBar selector:@selector(resignFirstResponder) userInfo:nil repeats:NO];
	[NSTimer scheduledTimerWithTimeInterval:0 target:self.theSearchMenu selector:@selector(hide) userInfo:nil repeats:NO];
	[NSTimer scheduledTimerWithTimeInterval:1.5 target:self.theSearchMenu selector:@selector(removeSelectionBackground) userInfo:nil repeats:NO];				

	// --	
	if (optionNumber == 1) {
		// --	Show selection background.
		self.theSearchMenu.selectionBackground.backgroundColor = [UIColor blueColor];
		[self.theSearchMenu.selectionBackground setFrame:CGRectMake(5, 31, 143, 30)];
		
		// --	Do appropriate stuff.
		[self.theSiteView hideSiteSummary];
		[self.theSiteView loadUrl:theUrl];
		return;
	}
	if (optionNumber == 2) {
		// --	Show selection background.
		self.theSearchMenu.selectionBackground.backgroundColor = [UIColor blueColor];
		[self.theSearchMenu.selectionBackground setFrame:CGRectMake(5, 61, 143, 30)];

		// --	Do appropriate stuff.
		[self.theSiteView loadUrl:theUrl];
		theUrl = [theUrl stringByReplacingOccurrencesOfString:@"http://" withString:@""];
		theUrl = [theUrl stringByReplacingOccurrencesOfString:@"www." withString:@""];		
		[WebservicesController getSummaryForUrl:theUrl forCountry:@"US" urlEncoding:@"none" apiVersion:@"FF1.0" callbackDelegate:self];
		return;
	}
	if (optionNumber == 3) {
		// --	Show selection background.
		self.theSearchMenu.selectionBackground.backgroundColor = [UIColor blueColor];
		[self.theSearchMenu.selectionBackground setFrame:CGRectMake(5, 91, 143, 30)];
		
		// --	Do appropriate stuff.
		// TODO nothing here yet!
		return;
	}		
}

@end
