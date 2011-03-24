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
@synthesize formFooter;
@synthesize hideLabel;

@synthesize ipInfoDict;
@synthesize ispAccordingToWebservice;
@synthesize t01dictCategories;
@synthesize t02dictCountries;
@synthesize t03dictLocations;
@synthesize t04dictInterests;
@synthesize t05dictReasons;

@synthesize siteIsAccessible;
@synthesize indexOfCountryAccordingToUser;
@synthesize ispAccordingToUser;
@synthesize indexOfLocation;
@synthesize indexOfInterest;
@synthesize indexOfReason;
@synthesize indexOfCategory;
@synthesize ignoreCategoryAndUseCustomTag;
@synthesize customTag;
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
		
		self.formTable = [[UITableView alloc] initWithFrame:CGRectMake(15, 20, 290, 300) style:UITableViewStyleGrouped];
		self.formTable.backgroundColor = [UIColor clearColor];
		self.formTable.delegate = self;
		[self addSubview:self.formTable];
	
		self.hideLabel = [[UILabel alloc] initWithFrame:CGRectMake(280, 7, 40, 14)];
		self.hideLabel.backgroundColor = [UIColor clearColor];
		self.hideLabel.textAlignment = UITextAlignmentCenter;
		self.hideLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
		self.hideLabel.textColor = [UIColor whiteColor];
		self.hideLabel.text = @"hide";
		self.hideLabel.userInteractionEnabled = NO;
		[self addSubview:self.hideLabel];
		
	}
    return self;
}

- (void)dealloc {
    [super dealloc];
}

- (void) showForm {
	[UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut
					 animations:^{
						 [self setFrame:CGRectMake(0,38,320,378)];
					 } completion:^(BOOL finished){
					 }
	 ];
}

- (void) hideForm {
	[UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut
					 animations:^{
						 [self setFrame:CGRectMake(0,416,320,378)];
					 } completion:^(BOOL finished){
					 }
	 ];
}


#pragma mark -
#pragma mark UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 8;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {	
	UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"] autorelease];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}


@end
