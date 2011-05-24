//
//  SiteSummary.h
//  Herdict
//
//  Created by Christian Brink on 3/22/11.
//  Copyright 2011 Herdict. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModalTab.h"

@interface SiteSummary : ModalTab {

	UITextView *domainMessageString1;
	UITextView *domainMessageString2;
    UIActivityIndicatorView *domainLoadingIndicator;
	UILabel *domainLoadingText;		

    UITextView *domainAndPathMessageString1;
    UITextView *domainAndPathMessageString2;
	UIActivityIndicatorView *domainAndPathLoadingIndicator;
	UILabel *domainAndPathLoadingText;
}

@property (nonatomic, retain) UITextView *domainMessageString1;
@property (nonatomic, retain) UITextView *domainMessageString2;
@property (nonatomic, retain) UIActivityIndicatorView *domainLoadingIndicator;
@property (nonatomic, retain) UILabel *domainLoadingText;

@property (nonatomic, retain) UITextView *domainAndPathMessageString1;
@property (nonatomic, retain) UITextView *domainAndPathMessageString2;
@property (nonatomic, retain) UIActivityIndicatorView *domainAndPathLoadingIndicator;
@property (nonatomic, retain) UILabel *domainAndPathLoadingText;

- (void) setStateLoaded:(NSString *)theMessageString theColor:(int)theSheepColor domainOnly:(BOOL)isDomainOnly;

@end
