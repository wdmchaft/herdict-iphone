//
//  WebservicesController.m
//  Herdict
//
//  Created by Christian Brink on 3/7/11.
//  Copyright 2011 Herdict, Inc. All rights reserved.
//

#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "CJSONDeserializer.h"
#import "CJSONSerializer.h"
#import "WebservicesController.h"

@implementation WebservicesController

@synthesize subdomain;
@synthesize apiVersion;
@synthesize herdictReachability;

- (id) init {

	self = [super init];
	if (self) {
		self.subdomain = @"dev2";
		self.apiVersion = @"FF1.0";
		// --	Get the notifications started (for everyone).
		self.herdictReachability = [[Reachability reachabilityWithHostName:@"www.herdict.org"] retain];
		[self.herdictReachability startNotifier];
		
	}
	return self;
}

+ (WebservicesController *)sharedSingleton {
	static WebservicesController *sharedSingleton;
	
	@synchronized(self) {
		if (!sharedSingleton) {
			sharedSingleton = [[WebservicesController alloc] init];
		}
		return sharedSingleton;
	}
}

- (void) dealloc {
	[super dealloc];
}

#pragma mark -
#pragma mark callouts to non-Herdict services

- (void)getIp:(id)theCallbackDelegate {
	
	NSString *urlString = @"http://jsonip.com/";
	[self asynchGETRequest:urlString callbackDelegate:theCallbackDelegate callbackSelector:@selector(getIpCallbackHandler:)];
	
}

- (void) getInfoForIpAddress:(NSString *)theIpAddress callbackDelegate:(id)theDelegate {
	
	NSString *keyString = @"ESU-GVZ3DETL5GG9olyyGLaa6Q7";
	NSString *valutaString = @"usd";
	
	NSString *urlString = [NSString stringWithFormat:@"http://api.wipmania.com/%@?k=%@&t=json", theIpAddress, keyString, valutaString];
	[self asynchGETRequest:urlString callbackDelegate:theDelegate callbackSelector:@selector(getInfoForIpAddressCallbackHandler:)];
	
}

- (void)getRoughGeocodeForCountry:(NSString *)theCountry callbackDelegate:(id)theCallbackDelegate {
	
	NSString *encodedCountryString = (NSString *)CFURLCreateStringByAddingPercentEscapes(
																						 NULL,
																						 (CFStringRef)theCountry,
																						 NULL,
																						 (CFStringRef)@"!*'();:@&=+$,/?%#[]",
																						 kCFStringEncodingUTF8);
	
	NSString *urlString = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?address=%@&sensor=false",encodedCountryString];
	[self asynchGETRequest:urlString callbackDelegate:theCallbackDelegate callbackSelector:@selector(getRoughGeocodeForCountryCallbackHandler:)];
	[encodedCountryString release];
}


#pragma mark -
#pragma mark callouts to Herdict services
- (void)getCountries:(id)theCallbackDelegate {
	// TO2
	NSString *urlString = [NSString stringWithFormat:@"http://%@.herdict.org/web/action/ajax/plugin/init-countries/%@", self.subdomain, self.apiVersion];
	[self asynchGETRequest:urlString callbackDelegate:theCallbackDelegate callbackSelector:@selector(getCountriesCallbackHandler:)];	
}
- (void)getCategories:(id)theCallbackDelegate {
	// T01
	NSString *urlString = [NSString stringWithFormat:@"http://%@.herdict.org/web/action/ajax/plugin/init-categories/%@", self.subdomain, self.apiVersion];
	[self asynchGETRequest:urlString callbackDelegate:theCallbackDelegate callbackSelector:@selector(getCategoriesCallbackHandler:)];	
}
- (void)getCurrentLocation:(id)theCallbackDelegate {
	// T06
	NSString *urlString = [NSString stringWithFormat:@"http://%@.herdict.org/web/action/ajax/plugin/init-currentLocation/%@", self.subdomain, self.apiVersion];
	[self asynchGETRequest:urlString callbackDelegate:theCallbackDelegate callbackSelector:@selector(getCurrentLocationCallbackHandler:)];
}
- (void)getSiteSummary:(NSString *)theUrl forCountry:(NSString *)theCountry urlEncoding:(NSString *)theEncoding callbackDelegate:(id)theDelegate {

	NSString *urlString = [NSString stringWithFormat:@"http://%@.herdict.org/web/action/ajax/plugin/site/%@/%@/%@/%@",
						   self.subdomain,
						   theUrl,
						   theCountry,
						   theEncoding,
						   self.apiVersion];
	[self asynchGETRequest:urlString callbackDelegate:theDelegate callbackSelector:@selector(getSiteSummaryCallbackHandler:)];
}

- (void)reportUrl:(NSString *)theEncodedUrl reportType:(NSString *)theReportType country:(NSString *)theCountry userISP:(NSString *)theIsp userLocation:(NSString *)theLocation interest:(NSString *)theInterest reason:(NSString *)theReason sourceId:(NSString *)theSourceId tag:(NSString *)theTag comments:(NSString *)theComments defaultCountryCode:(NSString *)theDCC defaultispDefaultName:(NSString *)theDIN callbackDelegate:(id)theDelegate {
	
	NSString *urlString = [NSString stringWithFormat:@"http://%@.herdict.org/web/action/ajax/plugin/report?%@&report.url=%@&report.country.shortName=%@&report.ispDefaultName=%@&report.location=%@&report.interest=%@&report.reason=%@&report.sourceId=%@&report.tag=%@&report.comments=%@&defaultCountryCode=%@&defaultispDefaultName=%@&encoding=%@",
						   self.subdomain,
						   theReportType,
						   theEncodedUrl,
						   theCountry,
						   theIsp,
						   theLocation,
						   theInterest,
						   theReason,
						   theSourceId,
						   theTag,
						   theComments,
						   theDCC,
						   theDIN,
						   @""];
	[self asynchGETRequest:urlString callbackDelegate:theDelegate callbackSelector:@selector(reportUrlStatusCallbackHandler:)];
}


#pragma mark -
#pragma mark utilities

- (NSMutableDictionary *) getDictionaryFromJSONData:(NSData *)theData {
	//	Have a dictionary built using theData.
	NSError *errorDeserializingJSONResponse = nil;
	NSMutableDictionary *deserializedDictionary = [NSMutableDictionary dictionary];
	[deserializedDictionary addEntriesFromDictionary:[[CJSONDeserializer deserializer] deserializeAsDictionary:theData error:&errorDeserializingJSONResponse]];
	
	if (errorDeserializingJSONResponse) {
		deserializedDictionary = nil;
		NSLog(@"errorDeserializingJSONResponse: %@", errorDeserializingJSONResponse);
		return nil;
		
	} else {
		//NSLog(@"deserializedDictionary: %@", deserializedDictionary);
		return deserializedDictionary;
	}
}

- (NSMutableArray *) getArrayFromJSONData:(NSData *)theData {
	//	Have an array built using theData.
	NSError *errorDeserializingJSONResponse = nil;
	NSMutableArray *deserializedArray = [NSMutableArray arrayWithArray:[[CJSONDeserializer deserializer] deserializeAsArray:theData error:&errorDeserializingJSONResponse]];
//	NSLog(@"deserializedArray: %@", deserializedArray);
	
	if (errorDeserializingJSONResponse) {
		deserializedArray = nil;
//		NSLog(@"errorDeserializingJSONResponse: %@", errorDeserializingJSONResponse);
		return nil;
		
	} else {
		return deserializedArray;
	}
}

- (void) asynchGETRequest:(NSString*)stringForURL callbackDelegate:(id)theDelegate callbackSelector:(SEL)theSelector {
	
	if (![self.herdictReachability isReachable]) {
		return;
	}
	
	NSLog(@"GET request to URL: %@", stringForURL);
	NSURL *url = [NSURL URLWithString:stringForURL];
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
	[request setDelegate:theDelegate];
	[request setDidFinishSelector:theSelector];
	[request setDidFailSelector:theSelector];
	[request startAsynchronous];
}

@end
