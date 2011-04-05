//
//  HerdictArrays.m
//  Herdict
//
//  Created by Christian Brink on 3/26/11.
//  Copyright 2011 Herdict. All rights reserved.
//

#import "HerdictArrays.h"


@implementation HerdictArrays

@synthesize menuCategoryDefaultSelection;
@synthesize t01arrayCategories;
@synthesize t02arrayCountries;
@synthesize t06dictCurrentLocation;
@synthesize detected_ispName;
@synthesize detected_countryCode;
@synthesize detected_countryString;

- (id) init {
	self = [super init];
	if (self) {
		self.menuCategoryDefaultSelection = [NSString stringWithString:@"Tap to Select"];
	}
	return self;
}

- (void) dealloc {
	[super dealloc];
}

+ (HerdictArrays *) sharedSingleton {
	static HerdictArrays *sharedSingleton;
	
	@synchronized(self) {
		if (!sharedSingleton)
			sharedSingleton = [[HerdictArrays alloc] init];		
		return sharedSingleton;
	}
}

- (void) getCategoriesCallbackHandler:(ASIHTTPRequest*)request {	
	self.t01arrayCategories = [[WebservicesController sharedSingleton] getArrayFromJSONData:[request responseData]];
	[self.t01arrayCategories insertObject:[NSDictionary dictionaryWithObject:self.menuCategoryDefaultSelection forKey:@"label"] atIndex:0];
}

- (void) getCountriesCallbackHandler:(ASIHTTPRequest*)request {
	self.t02arrayCountries = [[WebservicesController sharedSingleton] getArrayFromJSONData:[request responseData]];	
	NSLog(@"[self.t02arrayCountries count]: %i", [self.t02arrayCountries count]);
}

- (void) getCurrentLocationCallbackHandler:(ASIHTTPRequest *)request {
	self.t06dictCurrentLocation = [[WebservicesController sharedSingleton] getDictionaryFromJSONData:[request responseData]];
	NSLog(@"t06dictCurrentLocation: %@", t06dictCurrentLocation);
	
	self.detected_ispName = [self.t06dictCurrentLocation objectForKey:@"ispName"];
	self.detected_countryCode = [self.t06dictCurrentLocation objectForKey:@"countryShort"];
	self.detected_countryString = [self.t06dictCurrentLocation objectForKey:@"countryLong"];
}

@end
