//
//  HerdictArrays.h
//  Herdict
//
//  Created by Christian Brink on 3/26/11.
//  Copyright 2011 Herdict. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "WebservicesController.h"

@interface HerdictArrays : NSObject {

	NSString *menuCategoryDefaultSelection;
	NSMutableArray *t01arrayCategories;
	NSMutableArray *t02arrayCountries;	

}

@property (nonatomic, retain) NSString *menuCategoryDefaultSelection;
@property (nonatomic, retain) NSMutableArray *t01arrayCategories;
@property (nonatomic, retain) NSMutableArray *t02arrayCountries;

+ (HerdictArrays *) sharedSingleton;

- (void) getCategoriesCallbackHandler:(ASIHTTPRequest *)request;
- (void) getCountriesCallbackHandler:(ASIHTTPRequest*)request;

@end
