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

@synthesize sectionNowEditing;

@synthesize menuAccessible;
@synthesize menuCategory;
@synthesize menuComments;

@synthesize hideLabel;

@synthesize t01arrayCategories;

@synthesize siteIsAccessible;
@synthesize keyCategory;
@synthesize comments;


#pragma mark -
#pragma mark lifecycle methods

- (void)viewDidLoad {		
	NSLog(@"VC_ReportSite viewDidLoad");

	[super viewDidLoad];

	self.title = @"Report Site";
	
	[WebservicesController getCategories:self];

	self.hideLabel = [[UILabel alloc] initWithFrame:CGRectMake(270, heightForNavBar - yOverhangForNavBar + heightForURLBar + 7, 50, 14)];
	self.hideLabel.backgroundColor = [UIColor clearColor];
	self.hideLabel.textAlignment = UITextAlignmentCenter;
	self.hideLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
	self.hideLabel.textColor = [UIColor whiteColor];
	self.hideLabel.text = @"Cancel";
	self.hideLabel.userInteractionEnabled = NO;
	//		[self.view addSubview:self.hideLabel];
	
	self.formTable = [[UITableView alloc] initWithFrame:CGRectMake(0,
																   heightForNavBar - yOverhangForNavBar + heightForURLBar,
																   320,
																   heightForFormStateCell * 4)
												  style:UITableViewStylePlain];
	self.formTable.backgroundColor = [UIColor clearColor];
	self.formTable.scrollEnabled = NO;
	self.formTable.delegate = self;
	self.formTable.dataSource = self;
	
	self.formTable.separatorStyle = UITableViewCellSeparatorStyleNone;
	
	self.formTable.layer.masksToBounds = NO;
	self.formTable.layer.shadowOffset = CGSizeMake(0, 0);
	self.formTable.layer.shadowRadius = 5;
	self.formTable.layer.shadowOpacity = 0.8;
	
	self.sectionNowEditing = -1;
	
	[self.view addSubview:self.formTable];
	
	self.siteIsAccessible = NO;
	self.keyCategory = 0;
	
	// --	menuAccessible
	NSMutableArray *menuAccessibleOptions = [NSMutableArray array];
	[menuAccessibleOptions addObject:[NSString stringWithString:@"Yes"]];
	[menuAccessibleOptions addObject:[NSString stringWithString:@"No"]];
	self.menuAccessible = [[FormDetailMenu alloc] initWithMessageHeight:32
														  withFrame:CGRectMake(-110, heightForNavBar - yOverhangForNavBar + 60, 270, 0)
												   menuOptionsArray:menuAccessibleOptions
														 tailHeight:25
														anchorPoint:CGPointMake(0, 0)];
	self.menuAccessible.theMessage.text = @"Can you access this site?";
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
	self.menuCategory = [[FormDetailMenu alloc] initWithMessageHeight:0
																	  withFrame:CGRectMake(-110, heightForNavBar - yOverhangForNavBar -33, 270, 0)
															   menuOptionsArray:menuOptions
																	 tailHeight:25
																	anchorPoint:CGPointMake(0, 0)];
	self.menuCategory.theMessage.text = @"";	
	[self.t01arrayCategories insertObject:@"Tap to Select" atIndex:0];
}

#pragma mark -
#pragma mark UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	int num = 1;
	if (section == self.sectionNowEditing) {
		num = 2;
	}	
	return num;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

	UITableViewCell *cellAtPath = [self tableView:self.formTable cellForRowAtIndexPath:indexPath];
	if ([cellAtPath isKindOfClass:[FormClearCell class]]) {
		return 250.0;
	}
	
	if (indexPath.section < 2) {
		return heightForFormStateCell;
	}
	return heightForFormStateCell - 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

	/* --	If it's the editCell	-- */
	if (indexPath.section == self.sectionNowEditing && indexPath.row == 1) {
		FormClearCell *cellClear = [[[FormClearCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellClear"] autorelease];
		return cellClear;
	}

	FormStateCell *cell = [[[FormStateCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellState"] autorelease];
		
	// --	'Is the Site Accessible?'.
	if (indexPath.section == 2) {
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
	if (indexPath.section == 0) {
		UIImage *iconImage = [UIImage imageNamed:@"15-tags@2x.png"];
		cell.theIconView.image = iconImage;
		cell.cellLabel.text = @"Site Category";
		cell.cellDetailLabel.text = @"Tap to Select";
		if (self.keyCategory > 0) {
			NSMutableDictionary *theDict = [self.t01arrayCategories objectAtIndex:self.keyCategory];
			cell.cellDetailLabel.text = [theDict objectForKey:@"label"];
		}
		return cell;
	}
	if (indexPath.section == 1) {
		UIImage *iconImage = [UIImage imageNamed:@"09-chat-2@2x.png"];
		cell.theIconView.image = iconImage;
		cell.cellLabel.text = @"Comments";
		cell.cellDetailLabel.text = self.comments;
		return cell;
	}
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	/* --	If an editCell is already showing	-- */
	BOOL editCellWasOpen = NO;
	if (self.sectionNowEditing > -1 && indexPath.row == 0) {

		editCellWasOpen = YES;
		
		int sectionNowEditing_priorValue = self.sectionNowEditing;
		NSIndexPath *pathForDeleteRow = [NSIndexPath indexPathForRow:(1) inSection:sectionNowEditing_priorValue];
		
		self.sectionNowEditing = -1;

		[self.formTable beginUpdates];
		[self.formTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:pathForDeleteRow] withRowAnimation:UITableViewRowAnimationNone];
		[self.formTable endUpdates];
		
		[self.formTable beginUpdates];
		[self.formTable reloadSections:[NSIndexSet indexSetWithIndex:sectionNowEditing_priorValue] withRowAnimation:UITableViewRowAnimationNone];
		[self.formTable endUpdates];
		
		return;
	}
	
	self.sectionNowEditing = indexPath.section;

	/* --	Disable form interaction	-- */
	self.formTable.userInteractionEnabled = NO;

	CGFloat insertDelay = 0;
	if (editCellWasOpen) {
		insertDelay = 0.35;
	}
	
	NSIndexPath *pathForInsertRow = [NSIndexPath indexPathForRow:(1) inSection:indexPath.section];
	[self performSelector:@selector(addRow:) withObject:pathForInsertRow afterDelay:insertDelay];	
}


- (void) addRow:(NSIndexPath *)pathForRow {
		
	FormDetailMenu *theMenu;
	if ([pathForRow section] == 0) {
		theMenu = self.menuCategory;
	} else if ([pathForRow section] == 1) {
		theMenu = self.menuComments;
	} else if ([pathForRow section] == 2) {
		theMenu = self.menuAccessible;
	}
	[self.view insertSubview:theMenu belowSubview:self.formTable];
	theMenu.alpha = 1;
		
	[self.formTable beginUpdates];
	[self.formTable insertRowsAtIndexPaths:[NSArray arrayWithObject:pathForRow] withRowAnimation:UITableViewRowAnimationNone];
	[self.formTable endUpdates];
	
	[self.formTable beginUpdates];
	[self.formTable reloadSections:[NSIndexSet indexSetWithIndex:[pathForRow section]] withRowAnimation:UITableViewRowAnimationNone];
	[self.formTable endUpdates];
	
	NSIndexPath *stateCellPath = [NSIndexPath indexPathForRow:0 inSection:pathForRow.section];
	
	[self.formTable scrollToRowAtIndexPath:stateCellPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

#pragma mark -
#pragma mark Form 'Dives'

- (void) selectFormDetailMenuOption:(UITextView *)selectedSubview {
	
	FormDetailMenu *theMenu = [selectedSubview superview];
	
	// --	Have the menu show the selection background (and schedule its removal as well as the menu's).
	[theMenu showSelectionBackgroundForOption:selectedSubview.tag];
	[NSTimer scheduledTimerWithTimeInterval:0.25 target:theMenu selector:@selector(hideSelectionBackground) userInfo:nil repeats:NO];				
	
	// --	Schedule hiding of bubble menu.
	[NSTimer scheduledTimerWithTimeInterval:0.2 target:theMenu selector:@selector(hideFormDetailMenu) userInfo:nil repeats:NO];
	
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
	[super selectFormDetailMenuOption:selectedSubview];
}


- (void) returnFromFormDive {
	
	// --	Enable form interaction.
	self.formTable.userInteractionEnabled = YES;
	
}


@end
