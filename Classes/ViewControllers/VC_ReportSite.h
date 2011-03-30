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
#import "FormDetailMenu.h"
#import "HeightForRow.h"


@interface VC_ReportSite : VC_Base <UITableViewDelegate, UITableViewDataSource> {

	UITableView *formTable;
	
	int sectionNowEditing;	
	
	FormDetailMenu *menuAccessible;
	FormDetailMenu *menuCategory;
	FormDetailMenu *menuComments;
	
	UILabel *hideLabel;
	
	// --	Received from webservices.
	NSMutableArray *t01arrayCategories;
	
	// --	User-modified.
	BOOL siteIsAccessible;
	int keyCategory;
	NSString *comments;
	
	
}

@property (nonatomic, retain) UITableView *formTable;
@property (nonatomic) int sectionNowEditing;


/* --	For each of these make sure to call super	- */
@property (nonatomic, retain) FormDetailMenu *menuAccessible;
@property (nonatomic, retain) FormDetailMenu *menuCategory;
@property (nonatomic, retain) FormDetailMenu *menuComments;

@property (nonatomic, retain) UILabel *hideLabel;

@property (nonatomic, retain) NSMutableArray *t01arrayCategories;

@property (nonatomic) BOOL siteIsAccessible;
@property (nonatomic) int keyCategory;
@property (nonatomic, retain) NSString *comments;


- (void) getCategoriesCallbackHandler:(ASIHTTPRequest *)request;

@end
