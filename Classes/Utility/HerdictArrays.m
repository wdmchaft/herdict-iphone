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
	self.t01arrayCategories = [WebservicesController getArrayFromJSONData:[request responseData]];
	[self.t01arrayCategories insertObject:[NSDictionary dictionaryWithObject:self.menuCategoryDefaultSelection forKey:@"label"] atIndex:0];
}

- (void) getCountriesCallbackHandler:(ASIHTTPRequest*)request {
	self.t02arrayCountries = [WebservicesController getArrayFromJSONData:[request responseData]];
	
	NSLog(@"[self.t02arrayCountries count] before removal: %i", [self.t02arrayCountries count]);
	// TODO this is only because the scroll view isn't working
	while ([self.t02arrayCountries count] > 7) {
		for (int i = 0; i < [self.t02arrayCountries count] - 3; i++) {			
			NSString *codeString = [[self.t02arrayCountries objectAtIndex:i] objectForKey:@"value"];
			if (![codeString isEqualToString:@"US"]) {
				[self.t02arrayCountries removeObjectAtIndex:i];
			}
		}
	}
	NSLog(@"[self.t02arrayCountries count]: %i", [self.t02arrayCountries count]);	
}


@end
