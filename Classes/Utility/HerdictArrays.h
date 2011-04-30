//
//  HerdictArrays.h
//  Herdict
//
//  Created by Christian Brink on 3/26/11.
//  Copyright 2011 Herdict. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "Constants.h"
#import "WebservicesController.h"
#import "Reachability.h"

@interface HerdictArrays : NSObject {

	NSString *menuCategoryDefaultSelection;
	NSMutableArray *t01arrayCategories;
	NSMutableArray *t02arrayCountries;
	NSMutableDictionary *t06dictCurrentLocation;
	NSString *detected_ispName;
	NSString *detected_countryCode;
	NSString *detected_countryString;
	
}

@property (nonatomic, retain) NSString *menuCategoryDefaultSelection;
@property (nonatomic, retain) NSMutableArray *t01arrayCategories;
@property (nonatomic, retain) NSMutableArray *t02arrayCountries;
@property (nonatomic, retain) NSMutableDictionary *t06dictCurrentLocation;
@property (nonatomic, retain) NSString *detected_ispName;
@property (nonatomic, retain) NSString *detected_countryCode;
@property (nonatomic, retain) NSString *detected_countryString;

+ (HerdictArrays *) sharedSingleton;
- (void) t01SetupFromPlist;
- (void) t02SetupFromPlist;
- (void) getCategoriesCallbackHandler:(ASIHTTPRequest *)request;
- (void) getCountriesCallbackHandler:(ASIHTTPRequest *)request;
- (void) getCurrentLocationCallbackHandler:(ASIHTTPRequest *)request;

@end
