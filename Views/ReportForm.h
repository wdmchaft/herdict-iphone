//
//  ReportForm.h
//  Herdict
//
//  Created by Christian Brink on 3/23/11.
//  Copyright 2011 Herdict. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "BubbleMenu.h"


@interface ReportForm : UIView <UITableViewDelegate, UITableViewDataSource> {

	UIView *formBackground;
	UITableView *formTable;
	CGRect formTableNormalFrame;
	
	BubbleMenu *menuAccessible;
	BubbleMenu *menuReason;
	BubbleMenu *menuCategory;
	BubbleMenu *menuInterest;
	BubbleMenu *menuCountry;
	BubbleMenu *menuLocation;
	BubbleMenu *menuIsp;
	BubbleMenu *menuComments;
	
	UILabel *hideLabel;
	
	// --	Received from webservices.
	NSMutableDictionary *ipInfoDict;
	NSString *detected_ispName;
	NSString *detected_countryCode;
	NSMutableArray *t01arrayCategories;
	NSMutableArray *t02arrayCountries;	
	NSMutableArray *t03arrayLocations;
	NSMutableArray *t04arrayInterests;
	NSMutableArray *t05arrayReasons;
	
	// --	User-modified.
	BOOL siteIsAccessible;
	NSString *accordingToUser_countryCode;
	NSString *accordingToUser_ispName;
	int keyLocation;
	int keyInterest;
	int keyReason;
	int keyCategory;
	BOOL ignoreCategoryAndUseCustomString;
	NSString *customString;
	NSString *comments;
}

@property (nonatomic, retain) UIView *formBackground;
@property (nonatomic, retain) UITableView *formTable;
@property (nonatomic) CGRect formTableNormalFrame;

@property (nonatomic, retain) BubbleMenu *menuAccessible;
@property (nonatomic, retain) BubbleMenu *menuReason;
@property (nonatomic, retain) BubbleMenu *menuCategory;
@property (nonatomic, retain) BubbleMenu *menuInterest;
@property (nonatomic, retain) BubbleMenu *menuCountry;
@property (nonatomic, retain) BubbleMenu *menuLocation;
@property (nonatomic, retain) BubbleMenu *menuIsp;
@property (nonatomic, retain) BubbleMenu *menuComments;

@property (nonatomic, retain) UILabel *hideLabel;

@property (nonatomic, retain) NSMutableDictionary *ipInfoDict;
@property (nonatomic, retain) NSString *detected_ispName;
@property (nonatomic, retain) NSString *detected_countryCode;
@property (nonatomic, retain) NSMutableArray *t01arrayCategories;
@property (nonatomic, retain) NSMutableArray *t02arrayCountries;
@property (nonatomic, retain) NSMutableArray *t03arrayLocations;
@property (nonatomic, retain) NSMutableArray *t04arrayInterests;
@property (nonatomic, retain) NSMutableArray *t05arrayReasons;

@property (nonatomic) BOOL siteIsAccessible;
@property (nonatomic, retain) NSString *accordingToUser_ispName;
@property (nonatomic, retain) NSString *accordingToUser_countryCode;
@property (nonatomic) int keyLocation;
@property (nonatomic) int keyInterest;
@property (nonatomic) int keyReason;
@property (nonatomic) int keyCategory;
@property (nonatomic) BOOL ignoreCategoryAndUseCustomString;
@property (nonatomic, retain) NSString *customString;
@property (nonatomic, retain) NSString *comments;

@end
