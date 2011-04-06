//
//  WebservicesController.h
//  Herdict
//
//  Created by Christian Brink on 3/7/11.
//  Copyright 2011 Herdict, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "Reachability.h"
#import "CoreLocation/CoreLocation.h"


@interface WebservicesController : NSObject {

	NSString *apiVersion;
	Reachability *herdictReachability;	
}

@property (nonatomic, retain) NSString *apiVersion;
@property (nonatomic, retain) Reachability *herdictReachability;


+ (WebservicesController *)sharedSingleton;

- (void) getRoughGeocodeForCountry:(NSString *)theCountry callbackDelegate:(id)theCallbackDelegate;
- (void) getCountries:(id)theCallbackDelegate;
- (void) getCategories:(id)theCallbackDelegate;
- (void) getCurrentLocation:(id)theCallbackDelegate;
- (void) getSiteSummary:(NSString *)theUrl forCountry:(NSString *)theCountry urlEncoding:(NSString *)theEncoding callbackDelegate:(id)theDelegate;
- (void) reportUrl:(NSString *)theEncodedUrl reportType:(NSString *)theReportType country:(NSString *)theCountry userISP:(NSString *)theIsp userLocation:(NSString *)theLocation interest:(NSString *)theInterest reason:(NSString *)theReason sourceId:(NSString *)theSourceId tag:(NSString *)theTag comments:(NSString *)theComments defaultCountryCode:(NSString *)theDCC defaultispDefaultName:(NSString *)theDIN callbackDelegate:(id)theDelegate;

- (NSMutableArray *) getArrayFromJSONData:(NSData *)theData;
- (NSMutableDictionary *) getDictionaryFromJSONData:(NSData *)theData;

- (void) asynchGETRequest:(NSString*)stringForURL callbackDelegate:(id)theDelegate callbackSelector:(SEL)theSelector;
- (void) getIp:(id)theCallbackDelegate;
- (void) getInfoForIpAddress:(NSString *)theIpAddress callbackDelegate:(id)theDelegate;


@end