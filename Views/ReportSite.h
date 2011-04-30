//
//  ReportSite.h
//  Herdict
//
//  Created by Christian Brink on 4/12/11.
//  Copyright 2011 Herdict. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "Constants.h"
#import "WebservicesController.h"
#import "CustomUIButton.h"
#import "ModalTab.h"
#import "FormMenuCategory.h"
#import "FormMenuComments.h"
#import "Screen.h"
#import "NetworkInfo.h"
#import "HerdictArrays.h"


@interface ReportSite : ModalTab <UIAlertViewDelegate, UITextViewDelegate> {
	
	// --	data
	BOOL siteIsAccessible;
	int keyCategory;
	NSString *comments;
	
	// --	view: all configurations
	CustomUIButton *buttonSiteAccessible;
	CustomUIButton *buttonSiteInaccessible;
	
	// --	view: configurationDefault
	UIImageView *imageViewAddComments;
	UILabel *labelAddComments;
	UIImageView *imageViewSelectCategory;
	UILabel *labelSelectCategory;
	
	// --	view: configurationAddComments
	FormMenuComments *menuComments;

	// --	view: configurationSelectCategory
	FormMenuCategory *menuCategory;
}

// --	data
@property (nonatomic) BOOL siteIsAccessible;
@property (nonatomic) int keyCategory;
@property (nonatomic, retain) NSString *comments;

// --	view: configurationDefault
@property (nonatomic, retain) UIImageView *imageViewAddComments;
@property (nonatomic, retain) UILabel *labelAddComments;
@property (nonatomic, retain) UIImageView *imageViewSelectCategory;
@property (nonatomic, retain) UILabel *labelSelectCategory;
@property (nonatomic, retain) CustomUIButton *buttonSiteAccessible;
@property (nonatomic, retain) CustomUIButton *buttonSiteInaccessible;

@property (nonatomic, retain) FormMenuCategory *menuCategory;
@property (nonatomic, retain) FormMenuComments *menuComments;
@property (nonatomic, retain) NSString *menuCommentsDefaultSelection;

// --	init
- (void) setUpMenuCategory;

// --	configurationDefault
- (void) configureToAddComments;
- (void) selectButtonAccessibleNo;
- (void) selectButtonAccessibleYes;
- (void) prepareForReportCallout;
- (void) initiateReportCallout;

// --	configurationSelectCategory
- (void) selectFormMenuOption:(UITextView *)selectedSubview;


@end
