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

- (void) dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[super dealloc];
}

#pragma mark -
#pragma mark callouts to non-Herdict services

+ (void)getIp:(id)theCallbackDelegate {
	
	NSString *urlString = @"http://jsonip.com/";
	[self asynchGETRequest:urlString callbackDelegate:theCallbackDelegate callbackSelector:@selector(getIpCallbackHandler:)];
	
}

+ (void) getInfoForIpAddress:(NSString *)theIpAddress callbackDelegate:(id)theDelegate {
	
	NSString *keyString = @"ESU-GVZ3DETL5GG9olyyGLaa6Q7";
	NSString *valutaString = @"usd";
	
	NSString *urlString = [NSString stringWithFormat:@"http://api.wipmania.com/%@?k=%@&t=json", theIpAddress, keyString, valutaString];
	[self asynchGETRequest:urlString callbackDelegate:theDelegate callbackSelector:@selector(getInfoForIpAddressCallbackHandler:)];
	
}

+ (void)getRoughGeocodeForCountry:(NSString *)theCountry callbackDelegate:(id)theCallbackDelegate {
	
	NSString *encodedCountryString = (NSString *)CFURLCreateStringByAddingPercentEscapes(
																						 NULL,
																						 (CFStringRef)theCountry,
																						 NULL,
																						 (CFStringRef)@"!*'();:@&=+$,/?%#[]",
																						 kCFStringEncodingUTF8);
	
	NSString *urlString = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?address=%@&sensor=false",encodedCountryString];
	[self asynchGETRequest:urlString callbackDelegate:theCallbackDelegate callbackSelector:@selector(getRoughGeocodeForCountryCallbackHandler:)];
}


#pragma mark -
#pragma mark callouts to Herdict services
+ (void)getCountries:(id)theCallbackDelegate {
	// TO2
	NSString *urlString = [NSString stringWithFormat:@"http://www.herdict.org/web/action/ajax/plugin/init-countries/FF0.9"];
	[self asynchGETRequest:urlString callbackDelegate:theCallbackDelegate callbackSelector:@selector(getCountriesCallbackHandler:)];	
}
+ (void)getCategories:(id)theCallbackDelegate {
	// T01
	NSString *urlString = [NSString stringWithFormat:@"http://www.herdict.org/web/action/ajax/plugin/init-categories/FF0.9"];
	[self asynchGETRequest:urlString callbackDelegate:theCallbackDelegate callbackSelector:@selector(getCategoriesCallbackHandler:)];	
}

+ (void)getSiteSummary:(NSString *)theUrl forCountry:(NSString *)theCountry urlEncoding:(NSString *)theEncoding apiVersion:(NSString *)theVersion callbackDelegate:(id)theDelegate {

	NSString *urlString = [NSString stringWithFormat:@"http://www.herdict.org/web/action/ajax/plugin/site/%@/%@/%@/%@",
						   theUrl,
						   theCountry,
						   theEncoding,
						   theVersion];
	[self asynchGETRequest:urlString callbackDelegate:theDelegate callbackSelector:@selector(getSiteSummaryCallbackHandler:)];	
}

+ (void)reportUrl:(NSString *)theEncodedUrl reportType:(NSString *)theReportType country:(NSString *)theCountry userISP:(NSString *)theIsp userLocation:(NSString *)theLocation interest:(NSString *)theInterest reason:(NSString *)theReason sourceId:(NSString *)theSourceId tag:(NSString *)theTag comments:(NSString *)theComments defaultCountryCode:(NSString *)theDCC defaultispDefaultName:(NSString *)theDIN callbackDelegate:(id)theDelegate {
	
	NSString *urlString = [NSString stringWithFormat:@"http://www.herdict.org/web/action/ajax/plugin/report&report.url=%@&report.country.shortName=%@&report.ispDefaultName=%@&report.location=%@&report.interest=%@&report.reason=%@&report.sourceId=%@&report.tag=%@&report.comments=%@&defaultCountryCode=%@&defaultispDefaultName=%@&encoding=%@",
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
						   theDIN];
	[self asynchGETRequest:urlString callbackDelegate:theDelegate callbackSelector:@selector(reportUrlStatusCallbackHandler:)];	
}


#pragma mark -
#pragma mark utilities

+ (NSMutableDictionary *) getDictionaryFromJSONData:(NSData *)theData {
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

+ (NSMutableArray *) getArrayFromJSONData:(NSData *)theData {
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


+ (void) asynchGETRequest:(NSString*)stringForURL callbackDelegate:(id)theDelegate callbackSelector:(SEL)theSelector {
	NSLog(@"GET request to URL: %@", stringForURL);
	NSURL *url = [NSURL URLWithString:stringForURL];
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
	[request setDelegate:theDelegate];
	[request setDidFinishSelector:theSelector];
	[request setDidFailSelector:theSelector];
	[request startAsynchronous];
}


@end
