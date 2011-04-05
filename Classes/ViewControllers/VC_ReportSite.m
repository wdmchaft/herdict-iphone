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

@synthesize menuCategory;
@synthesize menuCommentsDefaultSelection;
@synthesize menuComments;
@synthesize menuAccessible;


@synthesize siteIsAccessible;
@synthesize keyCategory;
@synthesize comments;


#pragma mark -
#pragma mark lifecycle methods

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	//NSLog(@"%@ initWithNibName:%@ bundle:%@", self, nibNameOrNil, nibBundleOrNil);
	
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		
		self.title = @"Report Site";
		self.view.backgroundColor = [UIColor colorWithRed:barThemeRed green:barThemeGreen blue:barThemeBlue alpha:1];
		
		self.formTable = [[UITableView alloc] initWithFrame:CGRectMake(0,
																	   heightForNavBar - yOverhangForNavBar + heightForURLBar,
																	   320,
																	   heightForFormStateCell * 4)
													  style:UITableViewStylePlain];
		self.formTable.backgroundColor = [UIColor clearColor];
		self.formTable.userInteractionEnabled = YES;
		self.formTable.scrollEnabled = NO;
		self.formTable.delegate = self;
		self.formTable.dataSource = self;
		self.formTable.separatorStyle = UITableViewCellSeparatorStyleNone;
		[self.view addSubview:self.formTable];
		
		self.sectionNowEditing = -1;
		self.siteIsAccessible = NO;
		self.keyCategory = 0;
		
		// --	menuCategory
		self.menuCategory = [[FormMenuCategory alloc] initWithMessageHeight:0
																  withFrame:CGRectMake(25, heightForNavBar - yOverhangForNavBar + heightForURLBar + 10, 270, 0)
																 tailHeight:0];
		self.menuCategory.theMessage.text = @"";
		
		// --	Total kludge...  call setUpMenuCategory once, it will use the shipped Categories array.  Then 6s later do it again in case the latest one has arrived.  TODO set this up so we just call it when [HerdictArrays sharedSingleton] gets the callback.  Prob the right approach is to route that callback through vcReportSite.
		[self setUpMenuCategory];
		[self performSelector:@selector(setUpMenuCategory) withObject:nil afterDelay:6.0];
		
		// --	menuComments
		self.menuComments = [[FormMenuComments alloc] initWithCutoutHeight:112.0f
																 withFrame:CGRectMake(20, heightForNavBar - yOverhangForNavBar + heightForURLBar + 20, 280, 0)
																tailHeight:0];
		self.menuComments.theComments.delegate = self;
		self.menuCommentsDefaultSelection = [NSString stringWithString:@"Tap to Type"];
		
		// --	menuAccessible
		self.menuAccessible = [[FormMenuAccessible alloc] initWithFrame:CGRectMake(heightForFormStateCell, 28.0, (widthForFormMenuAccessibleButton * 2) + gapForFormMenuAccessible, heightForFormMenuAccessible)];
		self.menuAccessible.theDelegate = self;
	}
	return self;
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
	[menuAccessible release];
	[menuComments release];
	[menuCategory release];
	[formTable release];
    [super dealloc];
}

- (void) setUpMenuCategory {
	NSMutableArray *menuOptions = [NSMutableArray array];
	for (id item in [[HerdictArrays sharedSingleton] t01arrayCategories]) {
		NSString *anOption = [NSString stringWithString:[item objectForKey:@"label"]];
		[menuOptions addObject:anOption];
	}
	[self.menuCategory setUpMenuOptionsArray:menuOptions];
//	NSLog(@"[[HerdictArrays sharedSingleton] t01arrayCategories]: %@", [[HerdictArrays sharedSingleton] t01arrayCategories]);
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
		self.comments = textView.text;
		[self selectFormMenuOption:nil];
        return FALSE;
    }
    return TRUE;
}

#pragma mark -
#pragma mark UITableViewDelegate, UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == self.sectionNowEditing) {
		return 2;
	}	
	return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

	CGFloat subtractFromRowHeight = 0.0;
	if (indexPath.section == self.sectionNowEditing) {
		subtractFromRowHeight = heightToSubtractWhenFormStateCellShrinks;
	}
	
	UITableViewCell *cellAtPath = [self tableView:self.formTable cellForRowAtIndexPath:indexPath];
	if ([cellAtPath isKindOfClass:[FormClearCell class]]) {
//		NSLog(@"hFRAIP about to return %f", 250.0 + subtractFromRowHeight);
		return heightForFormClearCell + subtractFromRowHeight;
	}

	if (indexPath.section < 2) {
//		NSLog(@"hFRAIP about to return %f", heightForFormStateCell - subtractFromRowHeight);
		return heightForFormStateCell - subtractFromRowHeight;
	}
//	NSLog(@"hFRAIP about to return %f", heightForFormStateCell - subtractFromRowHeight - 1);	
	return heightForFormStateCell - subtractFromRowHeight - 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

	// --	If it's the editCell
	if (indexPath.section == self.sectionNowEditing && indexPath.row == 1) {
		FormClearCell *cellClear = [[[FormClearCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellClear"] autorelease];
		return cellClear;
	}

	FormStateCell *cell = [[[FormStateCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellState"] autorelease];
		
	if (indexPath.section == 0) {
		UIImage *iconImage = [UIImage imageNamed:@"15-tags@2x.png"];
		cell.theIconView.image = iconImage;
		cell.cellLabel.text = @"Site Category";
		NSString *stringFromArray = [[[[HerdictArrays sharedSingleton] t01arrayCategories] objectAtIndex:self.keyCategory] objectForKey:@"label"];
		if ([stringFromArray length] > 0) {
			cell.cellDetailLabel.text = stringFromArray;
		} else {
			cell.cellDetailLabel.text = [[HerdictArrays sharedSingleton] menuCategoryDefaultSelection];
		}
		return cell;
	}
	if (indexPath.section == 1) {
		UIImage *iconImage = [UIImage imageNamed:@"09-chat-2@2x.png"];
		cell.theIconView.image = iconImage;
		cell.cellLabel.text = @"Comments";
		if ([self.comments length] > 0) {
			cell.cellDetailLabel.text = self.comments;
		} else {
			cell.cellDetailLabel.text = self.menuCommentsDefaultSelection;
		}
		cell.cellDetailLabel.alpha = 1;
		return cell;
	}
	if (indexPath.section == 2) {
		UIImage *iconImage = [UIImage imageNamed:@"146-gavel@2x.png"];
		cell.theIconView.image = iconImage;
		[cell.cellLabel setCenter:CGPointMake(cell.cellLabel.center.x, cell.cellLabel.center.y - 7)];
		cell.cellLabel.text = @"Site Accessible?";
		cell.cellDetailLabel.alpha = 0;
		[cell.textPlate insertSubview:self.menuAccessible atIndex:0];
		cell.theDelegate = self; 
		return cell;
	}
	return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	// --	If an editCell is already showing
	if (self.sectionNowEditing > -1 && indexPath.row == 0) {

		[self removeClearRow];
		[self removeDetailMenu];
		
		return;
	}

	if (indexPath.section == 2) {
		return;
	}
	
	self.sectionNowEditing = indexPath.section;

	NSIndexPath *pathForInsertRow = [NSIndexPath indexPathForRow:(1) inSection:indexPath.section];
	[self performSelector:@selector(addRow:) withObject:pathForInsertRow afterDelay:0];	
}


- (void) addRow:(NSIndexPath *)pathForRow {
	
	NSIndexPath *stateCellPath = [NSIndexPath indexPathForRow:0 inSection:pathForRow.section];

	FormStateCell *theStateCell = [self.formTable cellForRowAtIndexPath:stateCellPath];

//	[theStateCell arrangeSubviewsForNewHeight:[self tableView:self.formTable heightForRowAtIndexPath:stateCellPath]];

	[self addDetailMenuAtRow:pathForRow];
	
	[self.formTable beginUpdates];
	[self.formTable insertRowsAtIndexPaths:[NSArray arrayWithObject:pathForRow] withRowAnimation:UITableViewRowAnimationTop];
	[self.formTable endUpdates];
	
	[self.formTable scrollToRowAtIndexPath:pathForRow atScrollPosition:UITableViewScrollPositionTop animated:YES];
	
	FormStateCell *cell = [self.formTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
	[cell.textPlate insertSubview:self.menuAccessible atIndex:0];

}

- (void) removeClearRow {

	if (self.sectionNowEditing < 0) {
		return;
	}
	
	// --	Have to set sectionNowEditing to -1 BEFORE the transactions coming up.. it's a flag for them
	int sectionNowEditing_priorValue = self.sectionNowEditing;
	self.sectionNowEditing = -1;
	
	NSIndexPath *stateCellPath = [NSIndexPath indexPathForRow:0 inSection:sectionNowEditing_priorValue];
	CGFloat theHeight;
	theHeight = [self tableView:self.formTable heightForRowAtIndexPath:stateCellPath];
	FormStateCell *theStateCell = [self.formTable cellForRowAtIndexPath:stateCellPath];
	[theStateCell arrangeSubviewsForNewHeight:theHeight];
	
	NSIndexPath *pathForDeleteRow = [NSIndexPath indexPathForRow:(1) inSection:sectionNowEditing_priorValue];
	
	[self.formTable beginUpdates];
	[self.formTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:pathForDeleteRow] withRowAnimation:UITableViewRowAnimationNone];
	[self.formTable endUpdates];
	
	for (int i = 0; i < [self.formTable numberOfSections]; i++) {
		UITableViewCell *theCell = [self.formTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:i]];
		[self.formTable bringSubviewToFront:theCell];
	}
	
	FormStateCell *cell = [self.formTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
	[cell.textPlate insertSubview:self.menuAccessible atIndex:0];
}

- (void) addDetailMenuAtRow:(NSIndexPath *)pathForRow {

	FormMenuCategory *theMenu;
	if ([pathForRow section] == 0) {
		theMenu = self.menuCategory;
	} else if ([pathForRow section] == 1) {
		theMenu = self.menuComments;
	}
	[self.view insertSubview:theMenu belowSubview:self.formTable];
	[theMenu addShadow];
	[self.view performSelector:@selector(bringSubviewToFront:) withObject:theMenu afterDelay:0.3];
	if ([theMenu isEqual:self.menuComments]) {
		[self.menuComments.theComments performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.3];
	}
	
	FormStateCell *cell = [self.formTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
	[cell.textPlate insertSubview:self.menuAccessible atIndex:0];

}

- (void) removeDetailMenu {
	
	[self.view performSelector:@selector(sendSubviewToBack:) withObject:self.menuCategory afterDelay:0];
	[self.menuCategory performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.3];

	[self.view performSelector:@selector(sendSubviewToBack:) withObject:self.menuComments afterDelay:0];
	[self.menuComments performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.3];
	
	FormStateCell *cell = [self.formTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
	[cell.textPlate insertSubview:self.menuAccessible atIndex:0];

}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	//NSLog(@"touchesBegan on %@", self);
	
	UITouch *touch = [touches anyObject];
	
	// --	If it's in any of self.view's own BubbleMenu views....
	for (UIView *theMenu in [self.view subviews]) {
		if ([theMenu isKindOfClass:[FormMenuCategory class]]) {
			if ([theMenu pointInside:[touch locationInView:theMenu] withEvent:nil]) {
				
				// --	If it 's in any of this BubbleMenu's tagged views...
				for (UIView *theSubview in [theMenu subviews]) {
					if (theSubview.tag > 0) {
						if ([theSubview pointInside:[touch locationInView:theSubview] withEvent:nil]) {
							[self performSelector:@selector(selectFormMenuOption:) withObject:theSubview afterDelay:0];
							return;
						}
					}
				}
			}
		}
	}
}

#pragma mark -
#pragma mark Form 'Dives'

- (void) selectFormMenuOption:(UITextView *)selectedSubview {
	//NSLog(@"selectFormMenuOption.. view with tag: %i", selectedSubview.tag);
	
	FormMenuCategory *theMenu = [selectedSubview superview];
	
	// --	Have the menu show the selection background (and schedule its removal as well as the menu's).
	[theMenu showSelectionBackgroundForOption:selectedSubview.tag];
	[NSTimer scheduledTimerWithTimeInterval:0.25 target:theMenu selector:@selector(hideSelectionBackground) userInfo:nil repeats:NO];				
	
	if ([theMenu isEqual:self.menuCategory]) {
		self.keyCategory = selectedSubview.tag;		
		if (self.keyCategory > 0) {
			NSMutableDictionary *theDict = [[[HerdictArrays sharedSingleton] t01arrayCategories] objectAtIndex:self.keyCategory];
			FormStateCell *categoryMenu = [self.formTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
			categoryMenu.cellDetailLabel.text = [theDict objectForKey:@"label"];
		}
	}
	// --	Show any updated Comments string.
	FormStateCell *cellStateComment = [self.formTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
	if ([self.comments length] > 0) {
		cellStateComment.cellDetailLabel.text = self.comments;
	} else {
		cellStateComment.cellDetailLabel.text = self.menuCommentsDefaultSelection;
	}
	
	[self performSelector:@selector(removeClearRow) withObject:nil afterDelay:0.1];
	[self performSelector:@selector(removeDetailMenu) withObject:nil afterDelay:0.1];
}

- (void) selectButtonAccessibleNo {
	[self.menuAccessible.buttonNo setNotSelected];
	self.siteIsAccessible = NO;
	[self prepareForReportCallout];	
}

- (void) selectButtonAccessibleYes {
	[self.menuAccessible.buttonYes setNotSelected];
	self.siteIsAccessible = YES;
	[self prepareForReportCallout];	
}

- (void) prepareForReportCallout {
	NSString *theUrl = [[self.tabBarController.delegate theUrlBar] text];
	theUrl = [theUrl stringByReplacingOccurrencesOfString:@"http://" withString:@""];
	theUrl = [theUrl stringByReplacingOccurrencesOfString:@"www." withString:@""];		
	UIAlertView *alertConfirm = [[UIAlertView alloc] initWithTitle:@"Confirm" message:[NSString stringWithFormat:@"Report %@ %@?", theUrl, self.siteIsAccessible ? @"accessible" : @"inaccessible"] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Submit",nil];
	[alertConfirm show];
	[alertConfirm release];		
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

	if ([alertView.title isEqualToString:@"Confirm"] && buttonIndex == 1) {
		[self initiateReportCallout];		
	}
}

- (void) initiateReportCallout {

	NSString *theUrl = [[self.tabBarController.delegate theUrlBar] text]; 
	theUrl = [theUrl stringByReplacingOccurrencesOfString:@"http://" withString:@""];
	theUrl = [theUrl stringByReplacingOccurrencesOfString:@"www." withString:@""];
	theUrl = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)theUrl, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8);
	
	NSString *theReportType = [NSString string];
	if (self.siteIsAccessible) {
		theReportType = @"siteAccessible";
	} else {
		theReportType = @"siteInaccessible";
	}
	
	NSString *theCountry = [[HerdictArrays sharedSingleton] detected_countryCode];
	
	NSString *theDetectedIspName = [[HerdictArrays sharedSingleton] detected_ispName];
	theDetectedIspName = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)theDetectedIspName, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8);

	NSString *theLocation = [NSString string];
	NSString *theInterest = [NSString string];
	NSString *theReason = [NSString string];
	NSString *theSourceId = [NSString string];
	
	NSString *theTag = [[[[HerdictArrays sharedSingleton] t01arrayCategories] objectAtIndex:self.keyCategory] objectForKey:@"value"];
	theTag = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)theTag, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8);
	if ([theTag length] == 0) {
		theTag = @"";
	}
	
	NSString *theComments = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)self.comments, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8);
	if ([theComments length] == 0) {
		theComments = @"";
	}	
		
	[[WebservicesController sharedSingleton] reportUrl:theUrl reportType:theReportType country:theCountry userISP:theDetectedIspName userLocation:theLocation interest:theInterest reason:theReason sourceId:theSourceId tag:theTag comments:theComments defaultCountryCode:theCountry defaultispDefaultName:theDetectedIspName callbackDelegate:self];
}

- (void) reportUrlStatusCallbackHandler:(ASIHTTPRequest *)request {
	NSLog(@"[request responseString]: %@", [request responseString]);
	
	if ([[request responseString] isEqualToString:@"SUCCESS"]) {
		UIAlertView *alertThankYou = [[UIAlertView alloc] initWithTitle:@"Report Submitted" message:@"Thanks for participating!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Done",nil];
		[alertThankYou show];
		[alertThankYou release];
	} else {
		UIAlertView *alertError = [[UIAlertView alloc] initWithTitle:@"Error" message:@"There was an error submitting your report." delegate:self cancelButtonTitle:nil otherButtonTitles:@"Done",nil];
		[alertError show];
		[alertError release];
	}		
}
@end
