//
//  VC_ReportSite.h
//  Herdict
//
//  Created by Christian Brink on 3/26/11.
//  Copyright 2011 Herdict. All rights reserved.
//

#import "ASIHTTPRequest.h"
#import "Constants.h"
#import "WebservicesController.h"
#import "FormStateCell.h"
#import "FormClearCell.h"
#import "FormMenuCategory.h"
#import "FormMenuComments.h"


@interface VC_ReportSite : UIViewController <UITableViewDelegate, UITableViewDataSource> {

	UITableView *formTable;
	
	int sectionNowEditing;	
	
	FormMenuCategory *menuAccessible;
	FormMenuCategory *menuCategory;
	FormMenuComments *menuComments;
	
	// --	from Herdict API
	NSMutableArray *t01arrayCategories;
	
	// --	User input
	BOOL siteIsAccessible;
	int keyCategory;
	NSString *comments;
}

@property (nonatomic, retain) UITableView *formTable;
@property (nonatomic) int sectionNowEditing;

@property (nonatomic, retain) FormMenuCategory *menuAccessible;
@property (nonatomic, retain) FormMenuCategory *menuCategory;
@property (nonatomic, retain) FormMenuComments *menuComments;

@property (nonatomic, retain) NSMutableArray *t01arrayCategories;

@property (nonatomic) BOOL siteIsAccessible;
@property (nonatomic) int keyCategory;
@property (nonatomic, retain) NSString *comments;


- (void) setUpT01ArrayCategories;
- (void) getCategoriesCallbackHandler:(ASIHTTPRequest *)request;
- (void) addRow:(NSIndexPath *)pathForRow;
- (void) removeClearRow;
- (void) addDetailMenuAtRow:(NSIndexPath *)pathForRow;
- (void) removeDetailMenu;

@end
