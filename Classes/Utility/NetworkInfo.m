//
//  NetworkInfo.m
//  Herdict
//
//  Created by Christian Brink on 3/26/11.
//  Copyright 2011 Herdict. All rights reserved.
//

#import "NetworkInfo.h"


@implementation NetworkInfo

@synthesize ipAddress;
@synthesize ipInfoDict;
@synthesize detected_ispName;
@synthesize detected_countryCode;

+ (NetworkInfo *)sharedSingleton {
	static NetworkInfo *sharedSingleton;
	
	@synchronized(self) {
		if (!sharedSingleton)
			sharedSingleton = [[NetworkInfo alloc] init];		
		return sharedSingleton;
	}
}

#pragma mark -
#pragma mark callbackHandlers

- (void) getIpCallbackHandler:(ASIHTTPRequest *)theRequest {
	NSLog(@"getIpCallbackHandler");
	NSDictionary *ipDict = [[WebservicesController sharedSingleton] getDictionaryFromJSONData:[theRequest responseData]];
	self.ipAddress = [ipDict objectForKey:@"ip"];
//	[[WebservicesController sharedSingleton] getInfoForIpAddress:self.ipAddress callbackDelegate:self];
}

- (void) getInfoForIpAddressCallbackHandler:(ASIHTTPRequest*)request {
	NSLog(@"getInfoForIpAddressCallbackHandler");

	// --	Fix the response string, which may contain invalid JSON.
	NSString *responseString = [request responseString];
	responseString = [responseString stringByReplacingOccurrencesOfString:@"\"valuta_rate\":," withString:@""];
	NSData *fixedResponseData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
	self.ipInfoDict = [[WebservicesController sharedSingleton] getDictionaryFromJSONData:fixedResponseData];
	self.detected_ispName = [NSString stringWithString:[[self.ipInfoDict objectForKey:@"isp"] objectForKey:@"name"]];
	self.detected_countryCode = [NSString stringWithString:[[self.ipInfoDict objectForKey:@"country"] objectForKey:@"code"]];
}

@end
