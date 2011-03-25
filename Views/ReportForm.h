//
//  ReportForm.h
//  Herdict
//
//  Created by Christian Brink on 3/23/11.
//  Copyright 2011 Herdict. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FooterBar.h"

@interface ReportForm : UIView <UITableViewDelegate, UITableViewDataSource> {

	UIView *formBackground;
	UITableView *formTable;
	FooterBar *formFooter;
	UILabel *hideLabel;
	
	CGRect formTableNormalFrame;
	
	// --	Background variables.
	NSMutableDictionary *ipInfoDict;
	NSString *detected_ispName;
	NSString *detected_countryCode;
	NSMutableDictionary *t01dictCategories;
	NSMutableDictionary *t02dictCountries;	
	NSMutableDictionary *t03dictLocations;
	NSMutableDictionary *t04dictInterests;
	NSMutableDictionary *t05dictReasons;
	
	// --	User-modified variables.
	BOOL siteIsAccessible;
	NSString *accordingToUser_countryCode;
	NSString *accordingToUser_ispName;
	NSString *keyLocation;
	NSString *keyInterest;
	NSString *keyReason;
	NSString *keyCategory;
	BOOL ignoreCategoryAndUseCustomString;
	NSString *customString;
	NSString *comments;
}

@property (nonatomic, retain) UIView *formBackground;
@property (nonatomic, retain) UITableView *formTable;
@property (nonatomic, retain) FooterBar *formFooter;
@property (nonatomic, retain) UILabel *hideLabel;

@property (nonatomic) CGRect formTableNormalFrame;

// --	Background variables.
@property (nonatomic, retain) NSMutableDictionary *ipInfoDict;
@property (nonatomic, retain) NSString *detected_ispName;
@property (nonatomic, retain) NSString *detected_countryCode;
@property (nonatomic, retain) NSMutableDictionary *t01dictCategories;
@property (nonatomic, retain) NSMutableDictionary *t02dictCountries;
@property (nonatomic, retain) NSMutableDictionary *t03dictLocations;
@property (nonatomic, retain) NSMutableDictionary *t04dictInterests;
@property (nonatomic, retain) NSMutableDictionary *t05dictReasons;

// --	User-modified variables.
@property (nonatomic) BOOL siteIsAccessible;
@property (nonatomic, retain) NSString *accordingToUser_ispName;
@property (nonatomic, retain) NSString *accordingToUser_countryCode;
@property (nonatomic, retain) NSString *keyLocation;
@property (nonatomic, retain) NSString *keyInterest;
@property (nonatomic, retain) NSString *keyReason;
@property (nonatomic, retain) NSString *keyCategory;
@property (nonatomic) BOOL ignoreCategoryAndUseCustomString;
@property (nonatomic, retain) NSString *customString;
@property (nonatomic, retain) NSString *comments;

@end
