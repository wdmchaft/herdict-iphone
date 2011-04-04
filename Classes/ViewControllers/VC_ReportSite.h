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
#import "FormDetailMenu.h"


@interface VC_ReportSite : UIViewController <UITableViewDelegate, UITableViewDataSource> {

	UITableView *formTable;
	
	int sectionNowEditing;	
	
	FormDetailMenu *menuAccessible;
	FormDetailMenu *menuCategory;
	FormDetailMenu *menuComments;
	
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

@property (nonatomic, retain) NSMutableArray *t01arrayCategories;

@property (nonatomic) BOOL siteIsAccessible;
@property (nonatomic) int keyCategory;
@property (nonatomic, retain) NSString *comments;


- (void) getCategoriesCallbackHandler:(ASIHTTPRequest *)request;
- (void) removeClearRow;
- (void) addDetailMenu;
- (void)removeDetailMenuAtRow:(NSIndexPath *)pathForRow;

@end
