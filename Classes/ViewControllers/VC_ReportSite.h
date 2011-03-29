//
//  VC_ReportSite.h
//  Herdict
//
//  Created by Christian Brink on 3/26/11.
//  Copyright 2011 Herdict. All rights reserved.
//

#import "VC_Base.h"

#import "FormStateCell.h"
#import "FormClearCell.h"


@interface VC_ReportSite : VC_Base <UITableViewDelegate, UITableViewDataSource> {

	UITableView *formTable;
	
	int sectionNowEditing;
	
	CGRect formTableNormalFrame;
	
	BubbleMenu *menuAccessible;
	BubbleMenu *menuReason;
	BubbleMenu *menuCategory;
	//	BubbleMenu *menuInterest;
	//	BubbleMenu *menuCountry;
	//	BubbleMenu *menuLocation;
	//	BubbleMenu *menuIsp;
	BubbleMenu *menuComments;
	
	UILabel *hideLabel;
	
	// --	Received from webservices.
	NSMutableArray *t01arrayCategories;
	//	NSMutableArray *t03arrayLocations;
	//	NSMutableArray *t04arrayInterests;
	NSMutableArray *t05arrayReasons;
	
	// --	User-modified.
	BOOL siteIsAccessible;
	//	NSString *accordingToUser_countryCode;
	//	NSString *accordingToUser_ispName;
	//	int keyLocation;
	//	int keyInterest;
	int keyReason;
	int keyCategory;
	//	BOOL ignoreCategoryAndUseCustomString;
	//	NSString *customString;
	NSString *comments;
	
	
}

@property (nonatomic, retain) UITableView *formTable;

@property (nonatomic) int sectionNowEditing;

@property (nonatomic) CGRect formTableNormalFrame;


/* --	For each of these make sure to call super	- */
@property (nonatomic, retain) BubbleMenu *menuAccessible;
@property (nonatomic, retain) BubbleMenu *menuReason;
@property (nonatomic, retain) BubbleMenu *menuCategory;
//@property (nonatomic, retain) BubbleMenu *menuInterest;
//@property (nonatomic, retain) BubbleMenu *menuCountry;
//@property (nonatomic, retain) BubbleMenu *menuLocation;
//@property (nonatomic, retain) BubbleMenu *menuIsp;
@property (nonatomic, retain) BubbleMenu *menuComments;

@property (nonatomic, retain) UILabel *hideLabel;

@property (nonatomic, retain) NSMutableArray *t01arrayCategories;
//@property (nonatomic, retain) NSMutableArray *t03arrayLocations;
//@property (nonatomic, retain) NSMutableArray *t04arrayInterests;
@property (nonatomic, retain) NSMutableArray *t05arrayReasons;

@property (nonatomic) BOOL siteIsAccessible;
//@property (nonatomic, retain) NSString *accordingToUser_ispName;
//@property (nonatomic, retain) NSString *accordingToUser_countryCode;
//@property (nonatomic) int keyLocation;
//@property (nonatomic) int keyInterest;
@property (nonatomic) int keyReason;
@property (nonatomic) int keyCategory;
//@property (nonatomic) BOOL ignoreCategoryAndUseCustomString;
//@property (nonatomic, retain) NSString *customString;
@property (nonatomic, retain) NSString *comments;


- (void) getCategoriesCallbackHandler:(ASIHTTPRequest *)request;
- (void) getReasonsCallbackHandler:(ASIHTTPRequest *)request;
//- (void) getInterestsCallbackHandler:(ASIHTTPRequest *)request;
//- (void) getLocationsCallbackHandler:(ASIHTTPRequest *)request;

@end
