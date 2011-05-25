//
//  URLStringUtils.h
//  Herdict
//
//  Created by Christian Brink on 5/24/11.
//  Copyright 2011 Herdict. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface URLStringUtils : NSObject {
    
}

- (URLStringUtils *) sharedSingleton;

- (NSString *) urlWithoutScheme:theUrl;
- (NSString *) domainOfUrl:(NSString *)theUrl;

@end
