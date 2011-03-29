    //
//  VC_ReportSite.m
//  Herdict
//
//  Created by Christian Brink on 3/26/11.
//  Copyright 2011 Herdict. All rights reserved.
//

#import "VC_ReportSite.h"


@implementation VC_ReportSite

@synthesize formTable;
@synthesize formTableNormalFrame;

@synthesize menuAccessible;
@synthesize menuReason;
@synthesize menuCategory;
//@synthesize menuInterest;
//@synthesize menuCountry;
//@synthesize menuLocation;
//@synthesize menuIsp;
@synthesize menuComments;

@synthesize hideLabel;

@synthesize t01arrayCategories;
//@synthesize t03arrayLocations;
//@synthesize t04arrayInterests;
@synthesize t05arrayReasons;

@synthesize siteIsAccessible;
//@synthesize accordingToUser_countryCode;
//@synthesize accordingToUser_ispName;
//@synthesize keyLocation;
//@synthesize keyInterest;
@synthesize keyReason;
@synthesize keyCategory;
//@synthesize ignoreCategoryAndUseCustomString;
//@synthesize customString;
@synthesize comments;


#pragma mark -
#pragma mark lifecycle methods

- (void)viewDidLoad {		
	NSLog(@"VC_ReportSite viewDidLoad");

	[super viewDidLoad];

	self.title = @"Report Site";
	
	[WebservicesController getReasons:self];
	[WebservicesController getCategories:self];

	self.hideLabel = [[UILabel alloc] initWithFrame:CGRectMake(270, heightForNavBar - yOverhangForNavBar + heightForURLBar + 7, 50, 14)];
	self.hideLabel.backgroundColor = [UIColor clearColor];
	self.hideLabel.textAlignment = UITextAlignmentCenter;
	self.hideLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
	self.hideLabel.textColor = [UIColor whiteColor];
	self.hideLabel.text = @"Cancel";
	self.hideLabel.userInteractionEnabled = NO;
	//		[self.view addSubview:self.hideLabel];
	
	self.formTableNormalFrame = CGRectMake(30,
										   heightForNavBar - yOverhangForNavBar + heightForURLBar,
										   320,
										   480 - 20 - (heightForNavBar - yOverhangForNavBar + heightForURLBar) - 49);
	
	self.formTable = [[UITableView alloc] initWithFrame:CGRectMake(0,
																   heightForNavBar - yOverhangForNavBar + heightForURLBar,
																   320,
																   480 - 20 - (heightForNavBar - yOverhangForNavBar + heightForURLBar) - 49)
												  style:UITableViewStylePlain];
	self.formTable.backgroundColor = [UIColor clearColor];
	self.formTable.scrollEnabled = YES;
	self.formTable.delegate = self;
	self.formTable.dataSource = self;
	[self.view insertSubview:self.formTable atIndex:2];
	
	self.siteIsAccessible = NO;
	self.keyReason = 0;
	//		self.keyInterest = 0;
	//		self.keyLocation = 0;
	self.keyCategory = 0;
	//		self.comments = [NSString stringWithString:@"None Yet"];
	
	// --	menuAccessible
	NSMutableArray *menuAccessibleOptions = [NSMutableArray array];
	[menuAccessibleOptions addObject:[NSString stringWithString:@"Yes"]];
	[menuAccessibleOptions addObject:[NSString stringWithString:@"No"]];
	self.menuAccessible = [[BubbleMenu alloc] initWithMessageHeight:32
														  withFrame:CGRectMake(-110, heightForNavBar - yOverhangForNavBar + 60, 270, 0)
												   menuOptionsArray:menuAccessibleOptions
														 tailHeight:25
														anchorPoint:CGPointMake(0, 0)];
	self.menuAccessible.theMessage.text = @"Can you access this site?";
	[self.view insertSubview:self.menuAccessible atIndex:2];
	

	
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (void)dealloc {
    [super dealloc];
}


#pragma mark -
#pragma mark Herdict API callbacks

- (void) getCategoriesCallbackHandler:(ASIHTTPRequest*)request {
	self.t01arrayCategories = [WebservicesController getArrayFromJSONData:[request responseData]];
	
	// TODO this is only because the scroll view isn't working
	for (int i = 0; i < 5; i++) {
		[self.t01arrayCategories removeLastObject];
	}
	
	// Set up the Bubble Menu that uses this array
	NSMutableArray *menuOptions = [NSMutableArray array];
	for (id item in self.t01arrayCategories) {
		NSString *anOption = [NSString stringWithString:[item objectForKey:@"label"]];
		[menuOptions addObject:anOption];
	}
	self.menuCategory = [[BubbleMenu alloc] initWithMessageHeight:32
																	  withFrame:CGRectMake(-110, heightForNavBar - yOverhangForNavBar -33, 270, 0)
															   menuOptionsArray:menuOptions
																	 tailHeight:25
																	anchorPoint:CGPointMake(0, 0)];
	self.menuCategory.theMessage.text = @"What type of site is this?";
	[self.view insertSubview:self.menuCategory atIndex:2];
	
	[self.t01arrayCategories insertObject:@"Tap to Select" atIndex:0];
}

//- (void) getLocationsCallbackHandler:(ASIHTTPRequest*)request {
//	self.t03arrayLocations = [WebservicesController getArrayFromJSONData:[request responseData]];
//	
//	// Set up the Bubble Menu that uses this array
//	NSMutableArray *menuOptions = [NSMutableArray array];
//	for (id item in self.t03arrayLocations) {
//		NSString *anOption = [NSString stringWithString:[item objectForKey:@"label"]];
//		[menuOptions addObject:anOption];
//	}
//	self.menuLocation = [[BubbleMenu alloc] initWithMessageHeight:32
//																	  withFrame:CGRectMake(-110, -75, 270, 0)
//															   menuOptionsArray:menuOptions
//																	 tailHeight:25
//																	anchorPoint:CGPointMake(0, 0)];
//	self.menuLocation.theMessage.text = @"Where are you right now?";
//	[self.view addSubview:self.menuLocation];
//	
//	[self.t03arrayLocations insertObject:@"Tap to Select" atIndex:0];	
//}

//- (void) getInterestsCallbackHandler:(ASIHTTPRequest*)request {
//	self.t04arrayInterests = [WebservicesController getArrayFromJSONData:[request responseData]];
//	
//	// Set up the Bubble Menu that uses this array
//	[self.t04arrayInterests removeLastObject];		// TODO am only removing this because the text is too big
//	NSMutableArray *menuOptions = [NSMutableArray array];
//	for (id item in self.t04arrayInterests) {
//		NSString *anOption = [NSString stringWithString:[item objectForKey:@"label"]];
//		[menuOptions addObject:anOption];
//	}
//	self.menuInterest = [[BubbleMenu alloc] initWithMessageHeight:32
//																	  withFrame:CGRectMake(-110, 32, 270, 0)
//															   menuOptionsArray:menuOptions
//																	 tailHeight:25
//																	anchorPoint:CGPointMake(0, 0)];
//	self.menuInterest.theMessage.text = @"Is this site useful to you?";
//	[self.view addSubview:self.menuInterest];
//	
//	[self.t04arrayInterests insertObject:@"Tap to Select" atIndex:0];	
//}

- (void) getReasonsCallbackHandler:(ASIHTTPRequest*)request {
	self.t05arrayReasons = [WebservicesController getArrayFromJSONData:[request responseData]];
	
	// NOTE this is by design - we are not showing the 'Reasons' option if the site is designated as accessible.
	[self.t05arrayReasons removeObjectAtIndex:0]; 
	
	// Set up the Bubble Menu that uses this array
	NSMutableArray *menuOptions = [NSMutableArray array];
	for (id item in self.t05arrayReasons) {
		NSString *anOption = [NSString stringWithString:[item objectForKey:@"label"]];
		[menuOptions addObject:anOption];
	}
	self.menuReason = [[BubbleMenu alloc] initWithMessageHeight:60
																	withFrame:CGRectMake(-110, heightForNavBar - yOverhangForNavBar -37, 270, 0)
															 menuOptionsArray:menuOptions
																   tailHeight:25
																  anchorPoint:CGPointMake(0, 0)];
	self.menuReason.theMessage.text = @"Why do you think this site is inaccessible?";
	[self.view insertSubview:self.menuReason atIndex:2];
	
	[self.t05arrayReasons insertObject:@"Tap to Select" atIndex:0];
}


#pragma mark -
#pragma mark UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if (self.siteIsAccessible) {
		return 4;
	}
	return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section == 0)
        return 6;
    return 1.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return 1.0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	return [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)] autorelease];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	return [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)] autorelease];
}	
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	FormCell *cell = [[[FormCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"] autorelease];
	int indexPathSection = indexPath.section;
	
	if (self.siteIsAccessible && indexPathSection > 0) {
		indexPathSection++;													// remember we're using this trick 
	}
	
	// --	'Is the Site Accessible?'.
	if (indexPathSection == 0) {
		UIImage *iconImage = [UIImage imageNamed:@"146-gavel@2x.png"];
		cell.theIconView.image = iconImage;
		cell.cellLabel.text = @"Site Accessible";
		if (self.siteIsAccessible) {
			cell.cellDetailLabel.text = @"Yes";
		} else {
			cell.cellDetailLabel.text = @"No";
		}
		return cell;
	}
	if (indexPathSection == 1) {
		UIImage *iconImage = [UIImage imageNamed:@"20-gear2@2x.png"];
		cell.theIconView.image = iconImage;
		cell.cellLabel.text = @"Reason";
		cell.cellDetailLabel.text = @"Tap to Select";
		if (self.keyReason > 0) {
			NSMutableDictionary *theDict = [self.t05arrayReasons objectAtIndex:self.keyReason];
			cell.cellDetailLabel.text = [theDict objectForKey:@"label"];
		}
		return cell;
	}
	if (indexPathSection == 2) {
		UIImage *iconImage = [UIImage imageNamed:@"15-tags@2x.png"];
		cell.theIconView.image = iconImage;
		cell.cellLabel.text = @"Category";
		cell.cellDetailLabel.text = @"Tap to Select";
		if (self.keyCategory > 0) {
			NSMutableDictionary *theDict = [self.t01arrayCategories objectAtIndex:self.keyCategory];
			cell.cellDetailLabel.text = [theDict objectForKey:@"label"];
		}
		return cell;
	}
//	if (indexPathSection == 3) {
//		UIImage *iconImage = [UIImage imageNamed:@"186-ruler@2x.png"];
//		cell.theIconView.image = iconImage;
//		cell.cellLabel.text = @"Usefulness";
//		cell.cellDetailLabel.text = @"Tap to Select";
//		if (self.keyInterest > 0) {
//			NSMutableDictionary *theDict = [self.t04arrayInterests objectAtIndex:self.keyInterest];
//			cell.cellDetailLabel.text = [theDict objectForKey:@"label"];
//		}
//		return cell;
//	}
//	if (indexPathSection == 4) {
//		UIImage *iconImage = [UIImage imageNamed:@"59-flag@2x.png"];
//		cell.theIconView.image = iconImage;
//		[cell.theIconView setFrame:CGRectMake(10, 6, 20, 28)];
//		cell.cellLabel.text = @"Country";
//		
//		
//		NSLog(@"self.accordingToUser_countryCode: %@", self.accordingToUser_countryCode);
//		for (id item in self.t02arrayCountries) {
//			if ([self.t02arrayCountries indexOfObject:item] > 0) {
//				NSString *countryCodeInArray = [item objectForKey:@"value"]; 
//				NSLog(@"countryCodeInArray: %@", countryCodeInArray);
//				if ([countryCodeInArray isEqualToString:self.accordingToUser_countryCode]) {
//					cell.cellDetailLabel.text = [item objectForKey:@"label"];
//					NSLog(@"thus cell.cellDetailLabel.text has been assigned!");
//				}
//			}
//		}
//		
//		return cell;
//	}
//	if (indexPathSection == 5) {
//		UIImage *iconImage = [UIImage imageNamed:@"193-location-arrow@2x.png"];
//		cell.theIconView.image = iconImage;
//		cell.cellLabel.text = @"Location";
//		cell.cellDetailLabel.text = @"Tap to Select";
//		if (self.keyLocation > 0) {
//			NSMutableDictionary *theDict = [self.t03arrayLocations objectAtIndex:self.keyLocation];
//			cell.cellDetailLabel.text = [theDict objectForKey:@"label"];
//		}
//		return cell;
//	}
//	if (indexPathSection == 6) {
//		UIImage *iconImage = [UIImage imageNamed:@"55-wifi@2x.png"];
//		cell.theIconView.image = iconImage;
//		[cell.theIconView setFrame:CGRectMake(6, 10, 28, 20)];
//		cell.cellLabel.text = @"ISP";
//		cell.cellDetailLabel.text = self.accordingToUser_ispName;
//		return cell;
//	}
	if (indexPathSection == 3) {
		UIImage *iconImage = [UIImage imageNamed:@"09-chat-2@2x.png"];
		cell.theIconView.image = iconImage;
		cell.cellLabel.text = @"Comments";
		cell.cellDetailLabel.text = self.comments;
		return cell;
	}
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	int indexPathSection = indexPath.section;	
	if (self.siteIsAccessible && indexPathSection > 0) {		
		indexPathSection++;											// remember we're using this trick 
	}
	
	if (indexPathSection >= 6) {
		return;
	}
	
	// --	Disable form interaction.
	self.formTable.userInteractionEnabled = NO;
	
	// --	Apply white screen.
	[UIView animateWithDuration:0.2 delay:0 options:nil
					 animations:^{
//						 // --	theReportSite.formBackground
//						 self.formBackground.backgroundColor = [UIColor whiteColor];
//						 self.formBackground.alpha = 1;
						 
						 // --	cells
 						 int countCells = [self.formTable numberOfSections];
 						 for (int i = 0; i < countCells; i++) {	
							 FormCell *nonSelectedCell = [self.formTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:i]];							
							 if (i != indexPath.section) {
								 nonSelectedCell.whiteScreen.alpha = 1;
							 }
						 }
					 } completion:^(BOOL finished){
					 }
	 ];
	
	/** --	Slide the whole tableView up so the selected cell is at the top -- **/
	
	// --	First determine how much to slide it, based on which cell this is.
	int rowSpan = [self.formTable.delegate tableView:self.formTable heightForRowAtIndexPath:indexPath];
	rowSpan = rowSpan + [self.formTable.delegate tableView:self.formTable heightForFooterInSection:indexPath.section];
	int slideSpan;
	if (indexPathSection == 0) {
		slideSpan = rowSpan * (indexPath.section - 1.5);
	} else if (indexPathSection == 1) {
		slideSpan = rowSpan * (indexPath.section - 0.5);
	} else if (indexPathSection == 2) {
		slideSpan = rowSpan * (indexPath.section - 0.5);
	} else if (indexPathSection == 3) {
		slideSpan = rowSpan * (indexPath.section - 1);
	}
	
	[UIView animateWithDuration:0.3 delay:0.1 options:UIViewAnimationOptionCurveEaseOut
					 animations:^{
						 [self.view bringSubviewToFront:self.theUrlBar];
						 [self.formTable setCenter:CGPointMake(
																			 self.formTable.center.x,
																			 self.formTable.center.y - slideSpan)];						 
					 } completion:^(BOOL finished){
					 }
	 ];
	
	/** --	what to actually do	-- **/
	
	
	if (indexPathSection == 0) {
		[self.menuAccessible performSelector:@selector(showBubbleMenuWithAnimation:) withObject:[NSNumber numberWithBool:YES] afterDelay:0.3];
		return;
	}
	if (indexPathSection == 1) {
		[self.menuReason performSelector:@selector(showBubbleMenuWithAnimation:) withObject:[NSNumber numberWithBool:YES] afterDelay:0.3];
	}
	if (indexPathSection == 2) {
		[self.menuCategory performSelector:@selector(showBubbleMenuWithAnimation:) withObject:[NSNumber numberWithBool:YES] afterDelay:0.3];
	}
}


#pragma mark -
#pragma mark Form 'Dives'

- (void) selectBubbleMenuOption:(UITextView *)selectedSubview {
	
	BubbleMenu *theMenu = [selectedSubview superview];
	
	// --	Have the menu show the selection background (and schedule its removal as well as the menu's).
	[theMenu showSelectionBackgroundForOption:selectedSubview.tag];
	[NSTimer scheduledTimerWithTimeInterval:0.25 target:theMenu selector:@selector(hideSelectionBackground) userInfo:nil repeats:NO];				
	
	// --	Schedule hiding of bubble menu.
	[NSTimer scheduledTimerWithTimeInterval:0.2 target:theMenu selector:@selector(hideBubbleMenu) userInfo:nil repeats:NO];
	
	if ([theMenu isEqual:self.menuAccessible]) {
		BOOL siteIsAccessible_priorValue = self.siteIsAccessible;
		if (selectedSubview.tag == 1) {
			self.siteIsAccessible = YES;
			// --	Study this... it works!
			if (siteIsAccessible_priorValue == NO) {
				[self.formTable beginUpdates];
				[self.formTable deleteSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationRight];
				[self.formTable endUpdates];
				NSRange sectionsToReload = NSMakeRange(0,3);				
				[self.formTable beginUpdates];
				[self.formTable reloadSections:[NSIndexSet indexSetWithIndexesInRange:sectionsToReload] withRowAnimation:UITableViewRowAnimationNone];
				[self.formTable endUpdates];
			}
		}
		if (selectedSubview.tag == 2) {
			self.siteIsAccessible = NO;			
			// --	Study this... it works!
			if (siteIsAccessible_priorValue == YES) {
				[self.formTable beginUpdates];
				[self.formTable insertSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationLeft];
				[self.formTable endUpdates];
				NSRange sectionsToReload = NSMakeRange(0,4);
				[self.formTable beginUpdates];
				[self.formTable reloadSections:[NSIndexSet indexSetWithIndexesInRange:sectionsToReload] withRowAnimation:UITableViewRowAnimationNone];
				[self.formTable endUpdates];				
			}
		}
		[self performSelector:@selector(returnFromFormDive) withObject:nil afterDelay:0.4];
		return;
	}
	if ([theMenu isEqual:self.menuReason]) {
		self.keyReason = selectedSubview.tag;
		NSRange sectionsToReload = NSMakeRange(1,1);
		if (self.siteIsAccessible) {
			sectionsToReload = NSMakeRange(0, 0);
		}
		[self.formTable beginUpdates];
		[self.formTable reloadSections:[NSIndexSet indexSetWithIndexesInRange:sectionsToReload] withRowAnimation:UITableViewRowAnimationNone];
		[self.formTable endUpdates];
		
		[self performSelector:@selector(returnFromFormDive) withObject:nil afterDelay:0.4];
		return;
	}
	if ([theMenu isEqual:self.menuCategory]) {
		self.keyCategory = selectedSubview.tag;
		NSRange sectionsToReload = NSMakeRange(2,1);
		if (self.siteIsAccessible) {
			sectionsToReload = NSMakeRange(1, 0);
		}
		[self.formTable beginUpdates];
		[self.formTable reloadSections:[NSIndexSet indexSetWithIndexesInRange:sectionsToReload] withRowAnimation:UITableViewRowAnimationNone];
		[self.formTable endUpdates];
		
		[self performSelector:@selector(returnFromFormDive) withObject:nil afterDelay:0.4];
		return;

	}
	if ([theMenu isEqual:self.menuComments]) {
		//		self.comments = selectedSubview.tag;
		//		NSRange sectionsToReload = NSMakeRange(7,1);
		//		[self.formTable beginUpdates];
		//		[self.formTable reloadSections:[NSIndexSet indexSetWithIndexesInRange:sectionsToReload] withRowAnimation:UITableViewRowAnimationNone];
		//		[self.formTable endUpdates];

		[self performSelector:@selector(returnFromFormDive) withObject:nil afterDelay:0.4];
		return;
	}
	[super selectBubbleMenuOption:selectedSubview];
}


- (void) returnFromFormDive {
	
	// --	Enable form interaction.
	self.formTable.userInteractionEnabled = YES;
	
	// --	Slide the tableView back to its normal frame.
	[UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveEaseOut
					 animations:^{
						 [self.formTable setFrame:self.formTableNormalFrame];
						 if (self.siteIsAccessible) {
							 [self.formTable setCenter:CGPointMake(self.formTable.center.x,
																				 self.formTable.center.y + 15)];
						 }
					 } completion:^(BOOL finished){
					 }
	 ];	
	
	// --	Remove white screen.
	[UIView animateWithDuration:0.15 delay:0.2 options:nil
					 animations:^{						 
//						 // --	theReportSite.formBackground
//						 self.formBackground.backgroundColor = [UIColor blackColor];
//						 self.formBackground.alpha = 0.8;
						 
						 // --	cells
 						 int countCells = [self.formTable numberOfSections];
 						 for (int i = 0; i < countCells; i++) {
							 FormCell *nonSelectedCell = [self.formTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:i]];							
							 if (nonSelectedCell.whiteScreen.alpha > 0) {
								 nonSelectedCell.whiteScreen.alpha = 0;
							 }
						 }
					 } completion:^(BOOL finished){
					 }
	 ];	
}


@end
