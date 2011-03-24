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
	
	// --	Background variables.
	NSMutableDictionary *ipInfoDict;
	NSString *ispAccordingToWebservice;
	NSMutableDictionary *t01dictCategories;
	NSMutableDictionary *t02dictCountries;	
	NSMutableDictionary *t03dictLocations;
	NSMutableDictionary *t04dictInterests;
	NSMutableDictionary *t05dictReasons;
	
	// --	User-modified variables.
	BOOL siteIsAccessible;
	int indexOfCountryAccordingToUser;
	NSString *ispAccordingToUser;
	int indexOfLocation;
	int indexOfInterest;
	int indexOfReason;
	int indexOfCategory;
	BOOL ignoreCategoryAndUseCustomTag;
	NSString *customTag;
	NSString *comments;
}

@property (nonatomic, retain) UIView *formBackground;
@property (nonatomic, retain) UITableView *formTable;
@property (nonatomic, retain) FooterBar *formFooter;
@property (nonatomic, retain) UILabel *hideLabel;

// --	Background variables.
@property (nonatomic, retain) NSMutableDictionary *ipInfoDict;
@property (nonatomic, retain) NSString *ispAccordingToWebservice;
@property (nonatomic, retain) NSMutableDictionary *t01dictCategories;
@property (nonatomic, retain) NSMutableDictionary *t02dictCountries;
@property (nonatomic, retain) NSMutableDictionary *t03dictLocations;
@property (nonatomic, retain) NSMutableDictionary *t04dictInterests;
@property (nonatomic, retain) NSMutableDictionary *t05dictReasons;

// --	User-modified variables.
@property (nonatomic) BOOL siteIsAccessible;
@property (nonatomic) int indexOfCountryAccordingToUser;
@property (nonatomic, retain) NSString *ispAccordingToUser;
@property (nonatomic) int indexOfLocation;
@property (nonatomic) int indexOfInterest;
@property (nonatomic) int indexOfReason;
@property (nonatomic) int indexOfCategory;
@property (nonatomic) BOOL ignoreCategoryAndUseCustomTag;
@property (nonatomic, retain) NSString *customTag;
@property (nonatomic, retain) NSString *comments;

@end
