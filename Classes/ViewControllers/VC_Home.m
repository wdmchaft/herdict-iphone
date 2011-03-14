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

@synthesize theSearchBar;

@synthesize siteSummaryPlate;
@synthesize siteSummaryBackground;
@synthesize siteSummaryTextView;
@synthesize siteSummaryReceived;

@synthesize checkSiteButtonPlate;
@synthesize checkSiteButtonBackground;
@synthesize checkSiteButtonLabel;

@synthesize networkInfoPlate;
@synthesize networkInfoTabBackground;
@synthesize networkInfoBodyBackground;
@synthesize networkInfoLabel;
@synthesize networkInfoText;
@synthesize networkInfoPlateIsExpanded;

@synthesize loadingPlate;
@synthesize loadingBackground;
@synthesize loadingActivityIndicator;
@synthesize loadingLabel;

@synthesize ipString;
@synthesize ipInfoDict;
@synthesize ispString;
@synthesize countryDict;

@synthesize reportsFromFeed;
@synthesize currentReportForAnnotation;
@synthesize nextReportForAnnotation;
@synthesize reportMapView;
@synthesize theAnnotation;

#pragma mark UIViewController lifecycle

- (void) viewDidLoad {

	[super viewDidLoad];
	
	self.reportMapView = [[MKMapView alloc] initWithFrame:CGRectMake(0,0,320,436)];
	self.reportMapView.delegate = self;
	self.reportMapView.scrollEnabled = NO;
	self.reportMapView.zoomEnabled = NO;
	[self.view addSubview:self.reportMapView];
	
	self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
	UIImage *herdictBadgeImage = [UIImage imageNamed:@"herdict_badge"];
	UIImageView *herdictBadgeImageView = [[[UIImageView alloc] initWithImage:herdictBadgeImage] autorelease];
	[herdictBadgeImageView setFrame:CGRectMake(
											   herdictBadgeImageView.frame.origin.x,
											   herdictBadgeImageView.frame.origin.y-5,
											   herdictBadgeImageView.frame.size.width * 1,
											   herdictBadgeImageView.frame.size.height * 1)];
	self.navigationItem.titleView = herdictBadgeImageView;
	[herdictBadgeImageView release];
	self.view.backgroundColor = [UIColor whiteColor];
	
	self.reportsFromFeed = [NSMutableArray array];
	self.currentReportForAnnotation = 0;
	self.nextReportForAnnotation = 1;
	
	self.ispString = [NSString stringWithString:@""];
	self.ipInfoDict = [NSMutableDictionary dictionary];

	self.countryDict = [NSMutableDictionary dictionary];	
	[WebservicesController getCountries:self];	
	
	// --	Set up siteSummaryPlate.
	self.siteSummaryPlate = [[UIView alloc] initWithFrame:CGRectMake(0,0,320,480)];
	self.siteSummaryPlate.backgroundColor = [UIColor clearColor];
	self.siteSummaryPlate.alpha = 0;
	[self.view addSubview:self.siteSummaryPlate];
	self.siteSummaryBackground = [[UIView alloc] initWithFrame:CGRectMake(0,0,320,480)];
	self.siteSummaryBackground.backgroundColor = [UIColor blackColor];
	self.siteSummaryBackground.alpha = 0.85;
	[self.siteSummaryPlate addSubview:self.siteSummaryBackground];
	self.siteSummaryTextView = [[UITextView alloc] initWithFrame:CGRectMake(40,210,280,260)];
	self.siteSummaryTextView.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
	self.siteSummaryTextView.backgroundColor = [UIColor clearColor];
	self.siteSummaryTextView.textColor = [UIColor whiteColor];
	self.siteSummaryTextView.userInteractionEnabled = NO;
	[self.siteSummaryPlate addSubview:self.siteSummaryTextView];
	
	// --	Set up theSearchBar and theSearchDisplayController.
	self.theSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0,0,320,44)];
	self.theSearchBar.placeholder = @"e.g. amnesty.org";
	self.theSearchBar.autocorrectionType = UITextAutocorrectionTypeNo;
	self.theSearchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
	self.theSearchBar.keyboardType = UIKeyboardTypeURL;
	UITextField *searchBarTextView = [[self.theSearchBar subviews] objectAtIndex:1];
	searchBarTextView.returnKeyType = UIReturnKeyGo;
	self.theSearchBar.showsCancelButton = YES;
	[self.theSearchBar setDelegate:self];
	[self.view addSubview:self.theSearchBar];
	
	// --	Set up networkInfoPlate.
	self.networkInfoPlateIsExpanded = NO;
	self.networkInfoPlate = [[UIView alloc] initWithFrame:CGRectMake(bottomLeftTab_onscreen_x,
																	 bottomLeftTab_offscreen_y,
																	 networkInfoPlate_expanded_width,
																	 networkInfoPlate_expanded_height)];
	self.networkInfoPlate.backgroundColor = [UIColor clearColor];
	self.networkInfoPlate.clipsToBounds = YES;
	[self.view addSubview:self.networkInfoPlate];
	self.networkInfoTabBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0,
																			 bottomLeftTab_onscreen_width,
																			 bottomLeftTab_onscreen_height)];
	self.networkInfoTabBackground.backgroundColor = UIColorFromRGB(0xff5a03);
	self.networkInfoTabBackground.alpha = 1.0;
	self.networkInfoTabBackground.layer.cornerRadius = 8;
	[self.networkInfoPlate addSubview:self.networkInfoTabBackground];
	self.networkInfoBodyBackground = [[UIView alloc] initWithFrame:CGRectMake(0,
																			  bottomLeftTab_onscreen_height - 15,
																			  networkInfoPlate_expanded_width,
																			  networkInfoPlate_expanded_height - bottomLeftTab_onscreen_height)];
	self.networkInfoBodyBackground.backgroundColor = UIColorFromRGB(0xff5a03);
	self.networkInfoBodyBackground.alpha = 1.0;
	self.networkInfoBodyBackground.layer.cornerRadius = 8;
	[self.networkInfoPlate addSubview:self.networkInfoBodyBackground];

	
	self.networkInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, -8,
																		 bottomLeftTab_onscreen_width,
																		 bottomLeftTab_onscreen_height)];
	self.networkInfoLabel.backgroundColor = [UIColor clearColor];
	self.networkInfoLabel.text = @"Know Your ISP";
	self.networkInfoLabel.userInteractionEnabled = NO;
	self.networkInfoLabel.textAlignment = UITextAlignmentCenter;
	self.networkInfoLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
	self.networkInfoLabel.textColor = [UIColor whiteColor];
	[self.networkInfoPlate addSubview:self.networkInfoLabel];
	self.networkInfoText = [[UITextView alloc] initWithFrame:CGRectMake(20, 30, networkInfoPlate_expanded_width - 40, 50)];
	self.networkInfoText.text = [NSString stringWithFormat:@"%@", self.ispString];
	self.networkInfoText.textColor = [UIColor whiteColor];
	self.networkInfoText.backgroundColor = [UIColor clearColor];
	self.networkInfoText.font = [UIFont fontWithName:@"Helvetica" size:15];
	self.networkInfoText.userInteractionEnabled = NO;
	[self.networkInfoPlate addSubview:self.networkInfoText];
	
	// --	Set up checkSiteButtonPlate.
	self.checkSiteButtonPlate = [[UIView alloc] initWithFrame:CGRectMake(bottomRightTab_onscreen_x,
																		 bottomRightTab_offscreen_y,
																		 bottomRightTab_onscreen_width,
																		 bottomRightTab_onscreen_height)];
	self.checkSiteButtonPlate.backgroundColor = [UIColor clearColor];
	self.checkSiteButtonPlate.layer.cornerRadius = 8;
	self.checkSiteButtonPlate.clipsToBounds = YES;
	[self.view addSubview:self.checkSiteButtonPlate];
	self.checkSiteButtonBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0,
																			  bottomRightTab_onscreen_width,
																			  bottomRightTab_onscreen_height)];
	self.checkSiteButtonBackground.backgroundColor = UIColorFromRGB(0x94cc00);
	self.checkSiteButtonBackground.alpha = 0.925;
	[self.checkSiteButtonPlate addSubview:self.checkSiteButtonBackground];
	self.checkSiteButtonLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, -8,
																			 bottomRightTab_onscreen_width,
																			 bottomRightTab_onscreen_height)];
	self.checkSiteButtonLabel.backgroundColor = [UIColor clearColor];
	self.checkSiteButtonLabel.text = @"Test This Site";
	self.checkSiteButtonLabel.userInteractionEnabled = NO;
	self.checkSiteButtonLabel.textAlignment = UITextAlignmentCenter;
	self.checkSiteButtonLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
	self.checkSiteButtonLabel.textColor = [UIColor whiteColor];
	[self.checkSiteButtonPlate addSubview:self.checkSiteButtonLabel];
	
	// --	Set up loadingPlate.
	self.loadingPlate = [[UIView alloc] initWithFrame:CGRectMake(bottomRightTab_onscreen_x,
																 bottomRightTab_offscreen_y,
																 bottomRightTab_onscreen_width,
																 bottomRightTab_onscreen_height)];
	self.loadingPlate.backgroundColor = [UIColor clearColor];
	[self.view addSubview:self.loadingPlate];
	self.loadingBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0,
																	  bottomRightTab_onscreen_width,
																	  bottomRightTab_onscreen_height)];
	self.loadingBackground.backgroundColor = [UIColor blackColor];
	self.loadingBackground.alpha = 0.65;
	self.loadingBackground.layer.cornerRadius = 8;
	[self.loadingPlate addSubview:self.loadingBackground];
	self.loadingActivityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(25, 5, 18, 18)];
	self.loadingActivityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
	[self.loadingPlate addSubview:self.loadingActivityIndicator];
	[self.loadingActivityIndicator startAnimating];
	self.loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(49, 6, 70, 15)];
	self.loadingLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
	self.loadingLabel.text = @"Loading";
	self.loadingLabel.backgroundColor = [UIColor clearColor];
	self.loadingLabel.userInteractionEnabled = NO;
	self.loadingLabel.textAlignment = UITextAlignmentCenter;
	self.loadingLabel.textColor = [UIColor whiteColor];
	[self.loadingPlate addSubview:self.loadingLabel];
}

- (void) viewWillAppear:(BOOL)animated {
	[self getTickerUpdate];
	[WebservicesController getIp:self];
}

- (void) dealloc {
	[theSearchBar release];
	
	[siteSummaryPlate release];
	[siteSummaryBackground release];
	[siteSummaryTextView release];
	[siteSummaryReceived release];
	
	[checkSiteButtonPlate release];
	[checkSiteButtonBackground release];
	[checkSiteButtonLabel release];
	
	[networkInfoPlate release];
	[networkInfoTabBackground release];
	[networkInfoBodyBackground release];
	[networkInfoLabel release];
	[networkInfoText release];
	[networkInfoPlateIsExpanded release];
	
	[loadingPlate release];
	[loadingBackground release];
	[loadingActivityIndicator release];
	[loadingLabel release];
	
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
#pragma mark Ticker and Map

- (void) getTickerUpdate {
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
//		NSLog(@"reportDict: %@", reportDict);
		[self.reportsFromFeed addObject:reportDict];		
	}
	
//		NSLog(@"self.reportsFromFeed: %@", self.reportsFromFeed);
	
	[self nextReportAnnotation];
}

- (void) nextReportAnnotation {
	
	if (([self.reportsFromFeed count] > 0) && (self.nextReportForAnnotation >= [self.reportsFromFeed count])) {
		self.nextReportForAnnotation = 0;
	}
	
	NSDictionary *currentReportDict = [self.reportsFromFeed objectAtIndex:self.currentReportForAnnotation];
	NSString *currentReportCountry = [[currentReportDict objectForKey:@"description"] objectForKey:@"Reporter Country"];
	NSDictionary *nextReportDict = [self.reportsFromFeed objectAtIndex:self.nextReportForAnnotation];
	NSString *nextReportCountry = [[nextReportDict objectForKey:@"description"] objectForKey:@"Reporter Country"];
	
	if (![nextReportCountry isEqualToString:currentReportCountry]) {
		[WebservicesController getRoughGeocodeForCountry:nextReportCountry callbackDelegate:self];
		self.currentReportForAnnotation = self.nextReportForAnnotation;
	} else {
		[NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(nextReportAnnotation) userInfo:nil repeats:NO];
	}
	self.nextReportForAnnotation++;
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
	//[reportAnnotationView setFrame:CGRectMake(0, 0, 25, 25)];
	ReportAnnotation *thisAnnotation = annotation;
	UIImage *sheepPin;
	if (thisAnnotation.sheepColor == 0) {
		sheepPin = [UIImage imageNamed:@"icon_herdometer_sheep_green_smaller"];
	} else if (thisAnnotation.sheepColor == 2) {
		sheepPin = [UIImage imageNamed:@"icon_herdometer_sheep_orange_smaller"];
	}
	reportAnnotationView.image = sheepPin;
	reportAnnotationView.canShowCallout = YES;
	reportAnnotationView.enabled = YES;
	return reportAnnotationView;
}

-(void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
	[self.reportMapView selectAnnotation:self.theAnnotation animated:YES];
}


#pragma mark -
#pragma mark self as UISearchBarDelegate

- (BOOL) searchBarShouldBeginEditing:(UISearchBar *)searchBar {
	if (self.networkInfoPlateIsExpanded) {
		[self shrinkNetworkInfoPlate];
		[NSTimer scheduledTimerWithTimeInterval:0.3 target:self.theSearchBar selector:@selector(becomeFirstResponder) userInfo:nil repeats:NO];
		return NO;
	} else {
		return YES;
	}
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
	[self hideSiteSummaryPlate];
	[self liftNetworkInfoPlateWithKeyboard];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
	self.siteSummaryReceived = NO;
	[self.theSearchBar resignFirstResponder];
	[self dropNetworkInfoPlateWithKeyboard];	
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	[self.theSearchBar resignFirstResponder];
	[self initiateGetSiteSummary];
	[self dropNetworkInfoPlateWithKeyboard];	
}

#pragma mark Some callbackHandlers

- (void) getRoughGeocodeForCountryCallbackHandler:(ASIHTTPRequest *)request {
	
	[NSTimer scheduledTimerWithTimeInterval:4.5 target:self selector:@selector(nextReportAnnotation) userInfo:nil repeats:NO];	
	
	if (self.siteSummaryReceived || [self.theSearchBar isFirstResponder]) {
		return;
	}
	
	// --	Outsource the basic request callback handling to (initialResponseHandling:).
	NSDictionary *responseDictionary = [self initialResponseHandling:request];
	
	// --	Pull out the country location info.
	NSMutableDictionary *geometryDict = [[[responseDictionary objectForKey:@"results"] objectAtIndex:0] objectForKey:@"geometry"];
	NSMutableDictionary *centerDict = [geometryDict objectForKey:@"location"];
	CLLocationCoordinate2D centerCoord = CLLocationCoordinate2DMake(
																	[[centerDict objectForKey:@"lat"] doubleValue],
																	[[centerDict objectForKey:@"lng"] doubleValue]
																	);
	NSMutableDictionary *northeastCornerDict = [[geometryDict objectForKey:@"viewport"] objectForKey:@"northeast"];
	NSMutableDictionary *southwestCornerDict = [[geometryDict objectForKey:@"viewport"] objectForKey:@"southwest"];
	CLLocationCoordinate2D northeastCorner = CLLocationCoordinate2DMake(
																		[[northeastCornerDict objectForKey:@"lat"] doubleValue],
																		[[northeastCornerDict objectForKey:@"lng"] doubleValue]
																		);
	CLLocationCoordinate2D southwestCorner = CLLocationCoordinate2DMake(
																		[[southwestCornerDict objectForKey:@"lat"] doubleValue],
																		[[southwestCornerDict objectForKey:@"lng"] doubleValue]
																		);
	
	// --	Set the new map region.
	MKCoordinateRegion reportRegion = MKCoordinateRegionMake(
															 CLLocationCoordinate2DMake(
																						(northeastCorner.latitude + southwestCorner.latitude) / 2,
																						(northeastCorner.longitude + southwestCorner.longitude) / 2
																						),
															 MKCoordinateSpanMake(
																				  (northeastCorner.latitude - southwestCorner.latitude) * 1.3,
																				  (northeastCorner.longitude - southwestCorner.longitude) * 1.3
																				  )
															 );
	NSLog(@"reportRegion.center.latitude: %f  longitude: %f", reportRegion.center.latitude, reportRegion.center.longitude);
	NSLog(@"reportRegion.span.latitudeDelta: %f  longitudeDelta: %f", reportRegion.span.latitudeDelta, reportRegion.span.longitudeDelta);
	
	[self.reportMapView setRegion:reportRegion animated:YES];
	
	// --	Get report details from self.reportsFromFeed.
	NSDictionary *reportDict = [self.reportsFromFeed objectAtIndex:self.currentReportForAnnotation];
	NSString *urlString = [[reportDict objectForKey:@"description"] objectForKey:@"URL"];
	NSString *reportTitleString = [reportDict objectForKey:@"title"];
	NSRange stringInaccessibleRange = [reportTitleString rangeOfString:@"inaccessible"];
	NSLog(@"stringInaccessibleRange.length: %i", stringInaccessibleRange.length);
	BOOL reportedAccessible = NO;
	int sheepColorInt = 2;
	if (stringInaccessibleRange.length == 0) {
		reportedAccessible = YES;
		sheepColorInt = 0;
	}
	NSString *unformattedDateString = [[reportDict objectForKey:@"description"] objectForKey:@"Report Date"];
	NSDateFormatter *inputFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[inputFormatter setDateFormat:@"MMM dd, yyyy hh:mm:ss a"];	
	NSDate *reportDate = [inputFormatter dateFromString:unformattedDateString];
	NSTimeInterval secondsSinceReport = [[NSDate date] timeIntervalSinceDate:reportDate];
	NSLog(@"secondsSinceReport: %f", secondsSinceReport);
	NSString *timeString;
	if (((int)(secondsSinceReport / (60*60))) > 1) {
		timeString = [NSString stringWithFormat:@"%i hours ago", (int)(secondsSinceReport / (60*60))];
	} else if (((int)(secondsSinceReport / 60)) > 1) {
		timeString = [NSString stringWithFormat:@"%i minutes ago", (int)(secondsSinceReport / (60))];
	}  else {
		timeString = [NSString stringWithFormat:@"%i seconds ago", (int)(secondsSinceReport)];
	}
	
	// --	Set up and add the annotation.
	if (self.theAnnotation != nil) {
		[self.reportMapView removeAnnotation:self.theAnnotation];
	}
	self.theAnnotation = nil;
	[self.theAnnotation release];
	self.theAnnotation = [[ReportAnnotation alloc] initWithBasics:centerCoord.longitude
														 latitude:centerCoord.latitude + 2.0
															title:urlString
														 subtitle:timeString
													   sheepColor:sheepColorInt];
	[self.reportMapView addAnnotation:self.theAnnotation];	
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
	self.networkInfoText.text = [[self.ipInfoDict objectForKey:@"isp"] objectForKey:@"name"];
	
	[self showNetworkInfoPlate];
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

- (void) initiateGetSiteSummary {
	NSLog(@"initiateGetSiteSummary");
	
	self.siteSummaryReceived = NO;
	[self hideCheckSiteButtonPlate];
	
	UITextField *searchBarText = [[self.theSearchBar subviews] objectAtIndex:1];
	searchBarText.text = [searchBarText.text lowercaseString];
	searchBarText.text = [searchBarText.text stringByReplacingOccurrencesOfString:@"http://" withString:@""];
	searchBarText.text = [searchBarText.text stringByReplacingOccurrencesOfString:@"www." withString:@""];

	if ([searchBarText.text length] > 0) {
		[NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(showLoadingPlate) userInfo:nil repeats:NO];
		[WebservicesController getSummaryForUrl:searchBarText.text forCountry:@"US" urlEncoding:@"none" apiVersion:@"FF1.0" callbackDelegate:self];
	}
}

- (void) getSiteSummaryCallbackHandler:(ASIHTTPRequest*)request {
	[NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(hideLoadingPlate) userInfo:nil repeats:NO];
	
	self.siteSummaryReceived = YES;
	
	//	Outsource the basic request callback handling to (initialResponseHandling:).
	NSDictionary *siteSummaryDictionary = [self initialResponseHandling:request];
	
	NSString *countryCode = [siteSummaryDictionary objectForKey:@"countryCode"];
	NSString *countryString = [self.countryDict objectForKey:countryCode];
	int countryInaccessibleCount = [[siteSummaryDictionary objectForKey:@"countryInaccessibleCount"] intValue];
	int globalInaccessibleCount = [[siteSummaryDictionary objectForKey:@"globalInaccessibleCount"] intValue];
	int sheepColor = [[siteSummaryDictionary objectForKey:@"sheepColor"] intValue];
	int siteId = [[siteSummaryDictionary objectForKey:@"siteId"] intValue];
	NSString *urlInQuestion = [siteSummaryDictionary objectForKey:@"url"];	
	
	NSString *messageString = [NSString stringWithFormat:@"'Site unavailable' reports\nfor %@:\n\n  %d    %@\n  %d    Worldwide", urlInQuestion,countryInaccessibleCount,countryString,globalInaccessibleCount];
	self.siteSummaryTextView.text = messageString;

	UIImage *sheepImage;	
	if (sheepColor == 0) {
		sheepImage = [UIImage imageNamed:@"icon_herdometer_sheep_green"];
	} else if (sheepColor == 1) {
		sheepImage = [UIImage imageNamed:@"icon_herdometer_sheep_yellow"];
	} else if (sheepColor == 2) {
		sheepImage = [UIImage imageNamed:@"icon_herdometer_sheep_orange"];
	}
	UIImageView *sheepImageView = [[[UIImageView alloc] initWithImage:sheepImage] autorelease];
	[sheepImageView setFrame:CGRectMake(130, 110, 60, 60)];
	[self.siteSummaryPlate addSubview:sheepImageView];
	
	[self showSiteSummaryPlate];
	[NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(showCheckSiteButtonPlate) userInfo:nil repeats:NO];
}

#pragma mark -
#pragma mark siteSummaryPlate

- (void) showSiteSummaryPlate {
	[UIView animateWithDuration:0.2 animations:^{
		self.siteSummaryPlate.alpha = 1;
	}
	 ];
}

- (void) hideSiteSummaryPlate {
	[UIView animateWithDuration:0.2 animations:^{
		self.siteSummaryPlate.alpha = 0;
	}
	 ];	
}

#pragma mark -
#pragma mark networkInfoPlate

- (void) showNetworkInfoPlate {
	[UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
		[self.networkInfoPlate setFrame:CGRectMake(bottomLeftTab_onscreen_x,
												   bottomLeftTab_onscreen_y,
												   networkInfoPlate_expanded_width,
												   bottomLeftTab_onscreen_height)];		
	} completion:^(BOOL finished){
	}
	 ];
}

- (void) expandNetworkInfoPlate {
	self.networkInfoPlateIsExpanded = YES;
	
	int contingentY = 0;
	if ([self.networkInfoText.text length] > 20) {
		contingentY = 10;
	}
	
	[UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
		[self.networkInfoPlate setFrame:CGRectMake(networkInfoPlate_expanded_x,
												   networkInfoPlate_expanded_y - contingentY,
												   networkInfoPlate_expanded_width,
												   networkInfoPlate_expanded_height)];		
		if (self.siteSummaryReceived) {
			[self.checkSiteButtonPlate setFrame:CGRectMake(bottomRightTab_onscreen_x,
														   networkInfoPlate_expanded_y - contingentY,
														   bottomRightTab_onscreen_width,
														   bottomRightTab_onscreen_height)];
		}
	} completion:^(BOOL finished){
	}
	 ];	
}


- (void) shrinkNetworkInfoPlate {
	self.networkInfoPlateIsExpanded = NO;
	[UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
		[self.networkInfoPlate setFrame:CGRectMake(bottomLeftTab_onscreen_x,
												   bottomLeftTab_onscreen_y,
												   networkInfoPlate_expanded_width,
												   bottomLeftTab_onscreen_height)];
		if (self.siteSummaryReceived) {
			[self.checkSiteButtonPlate setFrame:CGRectMake(bottomRightTab_onscreen_x,
														   bottomRightTab_onscreen_y,
														   bottomRightTab_onscreen_width,
														   bottomRightTab_onscreen_height)];
		}
	} completion:^(BOOL finished) {
	}
	 ];	
}

- (void) liftNetworkInfoPlateWithKeyboard {
	[UIView animateWithDuration:0.3 animations:^{
		[self.networkInfoPlate setCenter:CGPointMake(self.networkInfoPlate.center.x, self.networkInfoPlate.center.y - 216)];
	}
	 ];
}

- (void) dropNetworkInfoPlateWithKeyboard {
	[UIView animateWithDuration:0.28 animations:^{
		[self.networkInfoPlate setCenter:CGPointMake(self.networkInfoPlate.center.x, self.networkInfoPlate.center.y + 216)];
	}
	 ];
}

- (void) hideNetworkInfoPlate {
	[UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{

	////
	
	} completion:^(BOOL finished){
	}
	 ];	
}

#pragma mark -
#pragma mark checkSiteButtonPlate

- (void) showCheckSiteButtonPlate {
	[UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
		[self.checkSiteButtonPlate setFrame:CGRectMake(bottomRightTab_onscreen_x,
													   bottomRightTab_onscreen_y,
													   bottomRightTab_onscreen_width,
													   bottomRightTab_onscreen_height)];
	} completion:^(BOOL finished){
	}
	 ];
	
}

- (void) hideCheckSiteButtonPlate {
	[UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
		[self.checkSiteButtonPlate setFrame:CGRectMake(bottomRightTab_onscreen_x,
													   bottomRightTab_offscreen_y,
													   bottomRightTab_onscreen_width,
													   bottomRightTab_onscreen_height)];
	} completion:^(BOOL finished){
	}
	 ];	
}

#pragma mark submitReport

- (void) initiateSubmitReport {
}

- (void) submitReportCallbackHandler:(ASIHTTPRequest *)request {
}

#pragma mark loadingPlate

- (void) showLoadingPlate {
	if (self.siteSummaryReceived == NO) {	
		[UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
			[self.loadingPlate setFrame:CGRectMake(bottomRightTab_onscreen_x,
												   bottomRightTab_onscreen_y,
												   bottomRightTab_onscreen_width,
												   bottomRightTab_onscreen_height)];
		} completion:^(BOOL finished){}
		 ];
	}
}

- (void) hideLoadingPlate {
	[UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
		[self.loadingPlate setFrame:CGRectMake(bottomRightTab_onscreen_x,
											   bottomRightTab_offscreen_y,
											   bottomRightTab_onscreen_width,
											   bottomRightTab_onscreen_height)];
	} completion:^(BOOL finished){}
	 ];
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
	//	NSLog(@"touch.view: %@", touch.view);
	//	NSLog(@"[touch.view superview]: %@", [touch.view superview]);
	if (self.networkInfoPlateIsExpanded) {
		[self shrinkNetworkInfoPlate];
	} else {
		for (UIView *view in [self.networkInfoPlate subviews]) {
			if (touch.view == view) {
				if ([self.theSearchBar isFirstResponder]) {
					[NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(expandNetworkInfoPlate) userInfo:nil repeats:NO];
					[self searchBarCancelButtonClicked:self.theSearchBar];
					[self.view bringSubviewToFront:self.networkInfoPlate];
				} else {
					[self.view bringSubviewToFront:self.networkInfoPlate];
					[self expandNetworkInfoPlate];
				}
				break;
			}
		}
	}
}

@end
