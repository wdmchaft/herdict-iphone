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
#import "FormMenuAccessible.h"
#import "Screen.h"
#import "NetworkInfo.h"
#import "HerdictArrays.h"


@interface VC_ReportSite : UIViewController <UIAlertViewDelegate, FormStateCellDelegate, FormMenuAccessibleDelegate, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate> {

	UITableView *formTable;
	
	int sectionNowEditing;	
	
	FormMenuCategory *menuCategory;
	FormMenuComments *menuComments;
	NSString *menuCommentsDefaultSelection;
	FormMenuAccessible *menuAccessible;
	
	// --	User input
	BOOL siteIsAccessible;
	int keyCategory;
	NSString *comments;
}

@property (nonatomic, retain) UITableView *formTable;
@property (nonatomic) int sectionNowEditing;

@property (nonatomic, retain) FormMenuCategory *menuCategory;
@property (nonatomic, retain) FormMenuComments *menuComments;
@property (nonatomic, retain) NSString *menuCommentsDefaultSelection;
@property (nonatomic, retain) FormMenuAccessible *menuAccessible;

@property (nonatomic) BOOL siteIsAccessible;
@property (nonatomic) int keyCategory;
@property (nonatomic, retain) NSString *comments;

- (void) setUpMenuCategory;
- (void) addRow:(NSIndexPath *)pathForRow;
- (void) removeClearRow;
- (void) addDetailMenuAtRow:(NSIndexPath *)pathForRow;
- (void) removeDetailMenu;
- (void) selectFormMenuOption:(UITextView *)selectedSubview;
- (void) initiateReportCallout;

@end
