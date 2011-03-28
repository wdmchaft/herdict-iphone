//
//  Countries.h
//  Herdict
//
//  Created by Christian Brink on 3/26/11.
//  Copyright 2011 Herdict. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "WebservicesController.h"

@interface Countries : NSObject {

	NSMutableArray *t02arrayCountries;	

}

@property (nonatomic, retain) NSMutableArray *t02arrayCountries;

- (void) getCountriesCallbackHandler:(ASIHTTPRequest*)request;

@end
