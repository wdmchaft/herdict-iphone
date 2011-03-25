//
//  ReportForm.m
//  Herdict
//
//  Created by Christian Brink on 3/23/11.
//  Copyright 2011 Herdict. All rights reserved.
//

#import "ReportForm.h"


@implementation ReportForm

@synthesize formBackground;
@synthesize formTable;
@synthesize formTableNormalFrame;

@synthesize menuAccessible;
@synthesize menuReason;
@synthesize menuCategory;
@synthesize menuInterest;
@synthesize menuCountry;
@synthesize menuLocation;
@synthesize menuIsp;
@synthesize menuComments;

@synthesize hideLabel;

@synthesize ipInfoDict;
@synthesize detected_ispName;
@synthesize detected_countryCode;
@synthesize t01arrayCategories;
@synthesize t02arrayCountries;
@synthesize t03arrayLocations;
@synthesize t04arrayInterests;
@synthesize t05arrayReasons;

@synthesize siteIsAccessible;
@synthesize accordingToUser_countryCode;
@synthesize accordingToUser_ispName;
@synthesize keyLocation;
@synthesize keyInterest;
@synthesize keyReason;
@synthesize keyCategory;
@synthesize ignoreCategoryAndUseCustomString;
@synthesize customString;
@synthesize comments;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {

		self.backgroundColor = [UIColor clearColor];
		self.userInteractionEnabled = YES;
		
		self.formBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 378)];
		self.formBackground.backgroundColor = [UIColor blackColor];
		self.formBackground.alpha = 0.8;
		self.formBackground.userInteractionEnabled = NO;
		[self addSubview:self.formBackground];

		self.hideLabel = [[UILabel alloc] initWithFrame:CGRectMake(270, 7, 50, 14)];
		self.hideLabel.backgroundColor = [UIColor clearColor];
		self.hideLabel.textAlignment = UITextAlignmentCenter;
		self.hideLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
		self.hideLabel.textColor = [UIColor whiteColor];
		self.hideLabel.text = @"Cancel";
		self.hideLabel.userInteractionEnabled = NO;
//		[self addSubview:self.hideLabel];
		
		self.formTableNormalFrame = CGRectMake(30, 15, 260, 400);
		
		self.formTable = [[UITableView alloc] initWithFrame:self.formTableNormalFrame style:UITableViewStyleGrouped];
		self.formTable.backgroundColor = [UIColor clearColor];
		self.formTable.scrollEnabled = YES;
		[self addSubview:self.formTable];
		
		self.siteIsAccessible = NO;
		self.keyReason = 0;
		self.keyInterest = 0;
		self.keyLocation = 0;
		self.keyCategory = 0;
		self.comments = [NSString stringWithString:@"None Yet"];
		
		// --	menuAccessible
		NSMutableArray *menuAccessibleOptions = [NSMutableArray array];
		[menuAccessibleOptions addObject:[NSString stringWithString:@"Yes"]];
		[menuAccessibleOptions addObject:[NSString stringWithString:@"No"]];
		self.menuAccessible = [[BubbleMenu alloc] initWithMessageHeight:32
															  withFrame:CGRectMake(-110, 60, 270, 0)
													   menuOptionsArray:menuAccessibleOptions
															 tailHeight:25
															anchorPoint:CGPointMake(0, 0)];
		self.menuAccessible.theMessage.text = @"Can you access this site?";
		[self addSubview:self.menuAccessible];
		
		// --	menuReason... handled in callback method on VC_Home
		
		
	}
    return self;
}

- (void)dealloc {
    [super dealloc];
}

- (void) showForm {
	[self.formTable reloadData];
	
	[UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut
					 animations:^{
						 [self setFrame:CGRectMake(0,38,320,400)];
					 } completion:^(BOOL finished){
					 }
	 ];
}

- (void) hideForm {
	[UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut
					 animations:^{
						 [self setFrame:CGRectMake(0,416,320,400)];
					 } completion:^(BOOL finished){
					 }
	 ];
}

@end
