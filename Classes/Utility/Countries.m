//
//  Countries.m
//  Herdict
//
//  Created by Christian Brink on 3/26/11.
//  Copyright 2011 Herdict. All rights reserved.
//

#import "Countries.h"


@implementation Countries

@synthesize t02arrayCountries;

+ (Countries *) sharedSingleton {
	static Countries *sharedSingleton;
	
	@synchronized(self) {
		if (!sharedSingleton)
			sharedSingleton = [[Countries alloc] init];		
		return sharedSingleton;
	}
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
