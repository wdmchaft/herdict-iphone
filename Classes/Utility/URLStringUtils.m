//
//  URLStringUtils.m
//  Herdict
//
//  Created by Christian Brink on 5/24/11.
//  Copyright 2011 Herdict. All rights reserved.
//

#import "URLStringUtils.h"


@implementation URLStringUtils

- (id) init {
	self = [super init];
	if (self) {
	}
	return self;
}

- (void) dealloc {
	[super dealloc];
}

+ (URLStringUtils *) sharedSingleton {
	static URLStringUtils *sharedSingleton;
	
	@synchronized(self) {
		if (!sharedSingleton)
			sharedSingleton = [[URLStringUtils alloc] init];		
		return sharedSingleton;
	}
}

- (NSString*) urlWithoutScheme:(NSString *)theUrl {
    NSLog(@"urlWithoutScheme:theUrl >> ENTERING");
    NSLog(@"urlWithoutScheme:theUrl >> theUrl: %@", theUrl);
    
    NSString *theUrlString = [theUrl stringByReplacingOccurrencesOfString:@"https://www." withString:@""];
    theUrlString = [theUrlString stringByReplacingOccurrencesOfString:@"http://www." withString:@""];
    theUrlString = [theUrlString stringByReplacingOccurrencesOfString:@"https://" withString:@""];    
    theUrlString = [theUrlString stringByReplacingOccurrencesOfString:@"http://" withString:@""];
    
    NSLog(@"urlWithoutScheme:theUrl >> RETURNING %@", theUrlString);
    return theUrlString;
}

- (NSString *) domainOfUrl:(NSString *)theUrl {
    NSLog(@"domainOfUrl:theUrl >> ENTERING");
    NSLog(@"domainOfUrl:theUrl >> theUrl: %@",theUrl);
    
	NSString *theString = [self urlWithoutScheme:theUrl];
    
    // --   our "cut to the end" variable...
    BOOL shouldContinue = TRUE;
    
//    // --   Make sure this is a URL and not something like "about:blank"
//    NSRange rangeOfFirstDot = [theString rangeOfString:@"."];
//    if (rangeOfFirstDot.location == NSNotFound) {
//        NSLog(@"rangeOfFirstDot.location == NSNotFound");
//        shouldContinue = FALSE;
//    }
    

    // --	Drop the first "/" and anything following it.  If there is no "/", drop nothing.
    NSRange rangeOfFirstSlash;
    if (shouldContinue) {
        rangeOfFirstSlash = [theString rangeOfString:@"/"];
        if (rangeOfFirstSlash.location == NSNotFound) {
            NSLog(@"rangeOfFirstSlash.location == NSNotFound");
            shouldContinue = FALSE;
        }
    }
    
    if (shouldContinue) {
        NSLog(@"domainOfUrl:theUrl >> using substring with range: %@", NSStringFromRange(NSMakeRange(0, rangeOfFirstSlash.location)));
        theString = [theString substringWithRange:NSMakeRange(0, rangeOfFirstSlash.location)];
    }
    
    NSLog(@"domainOfUrl:theUrl >> RETURNING %@", theString);
    return theString;
}


@end
