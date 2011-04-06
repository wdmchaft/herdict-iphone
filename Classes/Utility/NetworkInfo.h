//
//  NetworkInfo.h
//  Herdict
//
//  Created by Christian Brink on 3/26/11.
//  Copyright 2011 Herdict. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "WebservicesController.h"

@interface NetworkInfo : NSObject {

	NSString *ipAddress;
	NSMutableDictionary *ipInfoDict;
	NSString *detected_ispName;
	NSString *detected_countryCode;	
}

@property (nonatomic, retain) NSString *ipAddress;
@property (nonatomic, retain) NSMutableDictionary *ipInfoDict;
@property (nonatomic, retain) NSString *detected_ispName;
@property (nonatomic, retain) NSString *detected_countryCode;

+ (NetworkInfo *)sharedSingleton;

- (void) getIpCallbackHandler:(ASIHTTPRequest *)theRequest;
- (void) getInfoForIpAddressCallbackHandler:(ASIHTTPRequest*)request;


@end
