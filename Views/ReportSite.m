//
//  ReportSite.m
//  Herdict
//
//  Created by Christian Brink on 4/12/11.
//  Copyright 2011 Herdict. All rights reserved.
//

#import "ReportSite.h"
#import "Constants.h"


@implementation ReportSite

// --	configurationDefault
@synthesize imageViewAddComments;
@synthesize labelAddComments;
@synthesize imageViewSelectCategory;
@synthesize labelSelectCategory;
@synthesize buttonSiteAccessible;
@synthesize buttonSiteInaccessible;

@synthesize menuCategory;
@synthesize menuComments;

@synthesize siteIsAccessible;
@synthesize keyCategory;
@synthesize comments;

- (id)initWithFrame:(CGRect)frame {

	self = [super initAsModalTabNumber:0 defaultYOrigin:reportSiteTab__yOrigin__configurationDefault withTabLabelText:(NSString *)reportSiteTab__tabLabel__text];
	if (self) {

		self.backgroundColor = [UIColor clearColor];
		[self setColorComponentsWithRed:themeColorRed withGreen:themeColorGreen withBlue:themeColorBlue withAlpha:0.9f];
//		[self setColorComponentsWithRed:0.694f withGreen:0.69f withBlue:0.69f withAlpha:0.9f];
//		[self setColorComponentsWithRed:0.302f withGreen:0.475f withBlue:0.651f withAlpha:0.8f];
				
		UIImage *imageSelectCategory = [UIImage imageNamed:@"15-tags@2x dark.png"];
		self.imageViewSelectCategory = [[UIImageView alloc] initWithImage:imageSelectCategory];
		
		self.labelSelectCategory = [[UILabel alloc] initWithFrame:CGRectZero];
		self.labelSelectCategory.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
		self.labelSelectCategory.textColor = [UIColor colorWithRed:modalTab__text__colorRed green:modalTab__text__colorGreen blue:modalTab__text__colorBlue alpha:1];
		self.labelSelectCategory.backgroundColor = [UIColor clearColor];
		self.labelSelectCategory.textAlignment = UITextAlignmentLeft;

		UIImage *imageAddComments = [UIImage imageNamed:@"09-chat-2@2x dark.png"];
		self.imageViewAddComments = [[UIImageView alloc] initWithImage:imageAddComments];
		
		self.labelAddComments = [[UILabel alloc] initWithFrame:CGRectZero];
		self.labelAddComments.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
		self.labelAddComments.textColor = [UIColor colorWithRed:modalTab__text__colorRed green:modalTab__text__colorGreen blue:modalTab__text__colorBlue alpha:1];
		self.labelAddComments.backgroundColor = [UIColor clearColor];
		self.labelAddComments.textAlignment = UITextAlignmentLeft;
		
		self.buttonSiteAccessible = [CustomUIButton buttonWithType:UIButtonTypeCustom];
		[self.buttonSiteAccessible addTarget:self.buttonSiteAccessible action:@selector(setSelected) forControlEvents:UIControlEventTouchDown];
		[self.buttonSiteAccessible addTarget:self action:@selector(selectButtonAccessibleYes) forControlEvents:UIControlEventTouchUpInside];
		[self.buttonSiteAccessible addTarget:self.buttonSiteAccessible action:@selector(setNotSelected) forControlEvents:UIControlEventTouchUpOutside];
		[self.buttonSiteAccessible setFrame:CGRectMake((self.frame.size.width - (2 * reportSiteTab__mainButtons__width) - reportSiteTab__mainButtons__gapBetween) / 2.0,
													   reportSiteTab__mainButtons__yOrigin_default,
													   reportSiteTab__mainButtons__width,
													   reportSiteTab__mainButtons__height)];
		[self.buttonSiteAccessible setColorComponentsWithRed:0.635f withGreen:0.773f withBlue:0.224f withAlpha:0.8f];
		[self.buttonSiteAccessible.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
		self.buttonSiteAccessible.titleLabel.shadowOffset = CGSizeMake(0, 1);
		[self.buttonSiteAccessible setTitleColor:UIColorFromRGB(0x404040) forState:UIControlStateSelected];
		[self.buttonSiteAccessible setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateSelected];
		[self.buttonSiteAccessible setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[self.buttonSiteAccessible setTitleShadowColor:UIColorFromRGB(0x404040) forState:UIControlStateNormal];		
		[self.buttonSiteAccessible setTitle:@"Site Accessible" forState:UIControlStateNormal];
		
		self.buttonSiteInaccessible = [CustomUIButton buttonWithType:UIButtonTypeCustom];
		[self.buttonSiteInaccessible addTarget:self.buttonSiteInaccessible action:@selector(setSelected) forControlEvents:UIControlEventTouchDown];
		[self.buttonSiteInaccessible addTarget:self action:@selector(selectButtonAccessibleNo) forControlEvents:UIControlEventTouchUpInside];
		[self.buttonSiteInaccessible addTarget:self.buttonSiteInaccessible action:@selector(setNotSelected) forControlEvents:UIControlEventTouchUpOutside];
		[self.buttonSiteInaccessible setColorComponentsWithRed:1.0f withGreen:0.4f withBlue:0.0f withAlpha:0.8f];
		[self.buttonSiteInaccessible setFrame:CGRectMake(self.buttonSiteAccessible.frame.origin.x + reportSiteTab__mainButtons__width + reportSiteTab__mainButtons__gapBetween,
													   reportSiteTab__mainButtons__yOrigin_default,
													   reportSiteTab__mainButtons__width,
													   reportSiteTab__mainButtons__height)];
		[self.buttonSiteInaccessible.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
		self.buttonSiteInaccessible.titleLabel.shadowOffset = CGSizeMake(0, 1);
		[self.buttonSiteInaccessible setTitleColor:UIColorFromRGB(0x404040) forState:UIControlStateSelected];
		[self.buttonSiteInaccessible setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateSelected];
		[self.buttonSiteInaccessible setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[self.buttonSiteInaccessible setTitleShadowColor:UIColorFromRGB(0x404040) forState:UIControlStateNormal];		
		[self.buttonSiteInaccessible setTitle:@"Site Inaccessible" forState:UIControlStateNormal];
		
		// --	menuCategory
		self.menuCategory = [[FormMenuCategory alloc] initWithMessageHeight:0
																  withFrame:CGRectMake(0.5 * (self.frame.size.width - reportSiteTab__menuCategory__width), reportSiteTab__menuCategory__yOrigin, reportSiteTab__menuCategory__width, 0)
																 tailHeight:0];
		self.menuCategory.theMessage.text = @"";
		
		// --	Call setUpMenuCategory once here.. it will use the shipped Categories array.  It gets called again when we hear back from the Herdict API.
		[self setUpMenuCategory];
		
		// --	menuComments
		self.menuComments = [[FormMenuComments alloc] initWithCutoutHeight:reportSiteTab__menuComments__height
																 withFrame:CGRectMake(0.5 * (self.frame.size.width - reportSiteTab__menuComments__width),
																					  reportSiteTab__menuComments__yOrigin,
																					  reportSiteTab__menuComments__width,
																					  reportSiteTab__menuComments__height)
																tailHeight:0];
		self.menuComments.theComments.text = reportSiteTab__menuComments__textInitial;
		self.menuComments.theComments.delegate = self;
				
		[self resetData];
    }
    return self;
}

- (void)dealloc {
	[buttonSiteAccessible release];
	[buttonSiteInaccessible release];
	[menuComments release];
	[menuCategory release];
    [super dealloc];
}

- (void) resetData {
	self.labelSelectCategory.text = reportSiteTab__labelSelectCategory__text__configurationDefault;
	self.labelAddComments.text = reportSiteTab__labelAddComments__text__configurationDefault;
	self.siteIsAccessible = NO;
	self.keyCategory = 0;
	[self configureDefault];
}

- (void) getCategoriesCallbackHandler:(ASIHTTPRequest*)request {
	NSLog(@"%@ getCategoriesCallbackHandler", [self class]); 
	[[HerdictArrays sharedSingleton] getCategoriesCallbackHandler:request];
	[self performSelector:@selector(setUpMenuCategory) withObject:nil afterDelay:1.0];
}

- (void) setUpMenuCategory {
	NSMutableArray *menuOptions = [NSMutableArray array];
	for (id item in [[HerdictArrays sharedSingleton] t01arrayCategories]) {
		NSString *anOption = [NSString stringWithString:[item objectForKey:@"label"]];
		[menuOptions addObject:anOption];
	}
	[self.menuCategory setUpMenuOptionsArray:menuOptions optionHeight:reportSiteTab__menuCategoryOption__height optionFontSize:reportSiteTab__menuCategoryOption__fontSize];
	//	NSLog(@"[[HerdictArrays sharedSingleton] t01arrayCategories]: %@", [[HerdictArrays sharedSingleton] t01arrayCategories]);
}

#pragma mark -
#pragma mark UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
	if ([textView.text isEqualToString:(NSString*)reportSiteTab__menuComments__textInitial]) {
		textView.text = @"";
	}
	[self configureToAddComments];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
		self.comments = textView.text;
		self.labelAddComments.text = self.comments;
		[self selectFormMenuOption:nil];
        return FALSE;
    }
    return TRUE;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
	[self.menuComments.theComments resignFirstResponder];
	[self configureDefault];
}

#pragma mark -
#pragma mark UITouch

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	//NSLog(@"touchesBegan on %@", [self class]);
	
	UITouch *touch = [touches anyObject];
	
	// --	If it's in menuCategory:
	for (UIView *theMenu in [self subviews]) {
		if ([theMenu isKindOfClass:[FormMenuCategory class]]) {
			if ([theMenu pointInside:[touch locationInView:theMenu] withEvent:nil]) {
				
				// --	If it 's in any of the menuOptions
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
	[self.superview touchesBegan:touches withEvent:event];
}

#pragma mark -
#pragma mark Form 'Dives'

- (void) selectFormMenuOption:(UITextView *)selectedSubview {
	NSLog(@"selectFormMenuOption.. view with tag: %i", selectedSubview.tag);
	
	FormMenuCategory *theMenu = (FormMenuCategory*)[selectedSubview superview];
	
	// --	Have the menu show the selection background (and schedule its removal as well as the menu's).
	[theMenu showSelectionBackgroundForOption:selectedSubview.tag];
	[NSTimer scheduledTimerWithTimeInterval:0.25 target:theMenu selector:@selector(hideSelectionBackground) userInfo:nil repeats:NO];				
	
	if ([theMenu isEqual:self.menuCategory]) {
		self.keyCategory = selectedSubview.tag;		
		if (self.keyCategory > 0) {
			NSMutableDictionary *theDict = [[[HerdictArrays sharedSingleton] t01arrayCategories] objectAtIndex:self.keyCategory];
			self.labelSelectCategory.text = [theDict objectForKey:@"label"];
			[self performSelector:@selector(configureDefault) withObject:nil afterDelay:0.3];
		}
	}
}

#pragma mark -
#pragma mark mainButtons
- (void) selectButtonAccessibleNo {
	self.siteIsAccessible = NO;
	[self prepareForReportCallout];
	[self.buttonSiteInaccessible setNotSelected];
}

- (void) selectButtonAccessibleYes {
	self.siteIsAccessible = YES;
	[self prepareForReportCallout];	
	[self.buttonSiteAccessible setNotSelected];
}


#pragma mark -
#pragma mark report callout sequence

- (void) prepareForReportCallout {
	NSString *theUrl = [[self.delegate theUrlBar] text];
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
	
	if (![[[WebservicesController sharedSingleton] herdictReachability] isReachable]) {
		[[[[UIAlertView alloc] initWithTitle:@"No Connection" message:@"You must have an Internet connection to submit a report." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
		return;
	}
	
	NSString *theUrl = [[self.delegate theUrlBar] text]; 
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
	
	[theUrl release];
	[theDetectedIspName release];
	[theTag release];
	[theComments release];
	
	[self configureDefault];
}

- (void) reportUrlStatusCallbackHandler:(ASIHTTPRequest *)request {
	NSLog(@"reportUrlStatusCallbackHandler");
	NSLog(@"[request responseString]: %@", [request responseString]);
	
	if ([[request responseString] isEqualToString:@"SUCCESS"]) {
		UIAlertView *alertThankYou = [[UIAlertView alloc] initWithTitle:@"Report Submitted" message:@"Thanks for participating!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Done",nil];
		[alertThankYou show];
		[alertThankYou release];
		[self.delegate positionAllModalTabsOutOfViewExcept:nil];
		self.labelSelectCategory.text = reportSiteTab__labelSelectCategory__text__configurationDefault;
		self.labelAddComments.text = reportSiteTab__labelAddComments__text__configurationDefault;
	} else {
		UIAlertView *alertError = [[UIAlertView alloc] initWithTitle:@"Error" message:@"There was an error submitting your report." delegate:self cancelButtonTitle:nil otherButtonTitles:@"Done",nil];
		[alertError show];
		[alertError release];
	}
}

#pragma mark -
#pragma mark configuring the tab

- (void) configureToSelectCategory {
	NSLog(@"configureToSelectCategory");
	
	self.yOrigin__current = reportSiteTab__yOrigin__configurationSelectCategory;
	[self.delegate positionAllModalTabsInViewBehind:self];
	
	CGFloat heightDiff = reportSiteTab__yOrigin__configurationDefault - reportSiteTab__yOrigin__configurationSelectCategory;
	
	[UIView animateWithDuration:modalTab__duration__changeConfiguration delay:0.0f options:UIViewAnimationCurveEaseOut
					 animations:^{
						 
						 self.buttonSiteAccessible.alpha = 0;
						 self.buttonSiteInaccessible.alpha = 0;
						 self.imageViewAddComments.alpha = 0;
						 self.labelAddComments.alpha = 0;
						 self.imageViewSelectCategory.alpha = 0;
						 self.labelSelectCategory.alpha = 0;
					 }
					 completion:^(BOOL finished) {
						 [self.buttonSiteAccessible removeFromSuperview];
						 [self.buttonSiteInaccessible removeFromSuperview];
						 [self.imageViewAddComments removeFromSuperview];
						 [self.labelAddComments removeFromSuperview];
						 [self.imageViewSelectCategory removeFromSuperview];
						 [self.labelSelectCategory removeFromSuperview];
						 self.buttonSiteAccessible.alpha = 1;
						 self.buttonSiteInaccessible.alpha = 1;
						 self.imageViewAddComments.alpha = 1;
						 self.labelAddComments.alpha = 1;
						 self.imageViewSelectCategory.alpha = 1;
						 self.labelSelectCategory.alpha = 1;
						 
						 [self addSubview:self.menuCategory];
					 }
	 ];	
}

- (void) configureToAddComments {
	NSLog(@"configureToAddComments");
	
	self.yOrigin__current = reportSiteTab__yOrigin__configurationAddComments;
	[self.delegate positionAllModalTabsInViewBehind:self];
	
	CGFloat heightDiff = reportSiteTab__yOrigin__configurationDefault - reportSiteTab__yOrigin__configurationAddComments;
	
	[UIView animateWithDuration:modalTab__duration__changeConfiguration delay:0.0f options:UIViewAnimationCurveEaseOut
					 animations:^{
						 
						 // --	Keep the buttons and labels at the bottom
						 [self.imageViewAddComments setFrame:CGRectMake(0.5 * (self.frame.size.width - reportSiteTab__imageViewAddComments__width - reportSiteTab__labelAddComments__width),
																		heightDiff + reportSiteTab__imageViewAddComments__yOrigin,
																		reportSiteTab__imageViewAddComments__width,
																		reportSiteTab__imageViewAddComments__height)];		
						 [self.labelAddComments setFrame:CGRectMake(self.imageViewAddComments.frame.origin.x + reportSiteTab__imageViewAddComments__width + reportSiteTab__labels__xGapAfterImages,
																	heightDiff + reportSiteTab__labelAddComments__yOrigin,
																	reportSiteTab__labelAddComments__width,
																	reportSiteTab__labelAddComments__height)];
						 [self.imageViewSelectCategory setFrame:CGRectMake(0.5 * (self.frame.size.width - reportSiteTab__imageViewSelectCategory__width - reportSiteTab__labelSelectCategory__width),
																		   heightDiff + reportSiteTab__imageViewSelectCategory__yOrigin,
																		   reportSiteTab__imageViewSelectCategory__width,
																		   reportSiteTab__imageViewSelectCategory__height)];		
						 [self.labelSelectCategory setFrame:CGRectMake(self.imageViewSelectCategory.frame.origin.x + reportSiteTab__imageViewSelectCategory__width + reportSiteTab__labels__xGapAfterImages,
																	   heightDiff + reportSiteTab__labelSelectCategory__yOrigin,
																	   reportSiteTab__labelSelectCategory__width,
																	   reportSiteTab__labelSelectCategory__height)];
						 [self.buttonSiteAccessible setFrame:CGRectMake(self.buttonSiteAccessible.frame.origin.x,
																		heightDiff + reportSiteTab__mainButtons__yOrigin_default,
																		reportSiteTab__mainButtons__width,
																		reportSiteTab__mainButtons__height)];
						 [self.buttonSiteInaccessible setFrame:CGRectMake(self.buttonSiteInaccessible.frame.origin.x,
																		  heightDiff + reportSiteTab__mainButtons__yOrigin_default,
																		  reportSiteTab__mainButtons__width,
																		  reportSiteTab__mainButtons__height)];
					 }
					 completion:^(BOOL finished) {
						 [self addSubview:self.menuComments];
						 [self.menuComments.theComments becomeFirstResponder];
					 }
	 ];
}

- (void) configureDefault {

    if ([[self.delegate modalTabInFront] isEqual:self]) {
        [self.delegate positionAllModalTabsInViewWithYOrigin:reportSiteTab__yOrigin__configurationDefault];
        [super configureDefault];
    }
    
	[UIView animateWithDuration:0.05 delay:0 options:UIViewAnimationCurveEaseOut
					 animations:^{
						 self.menuComments.alpha = 0;
						 self.menuCategory.alpha = 0;
					 } completion:^(BOOL finished){
						 [self.menuComments removeFromSuperview];
						 self.menuComments.alpha = 1;
						 [self.menuCategory removeFromSuperview];
						 self.menuCategory.alpha = 1;
					 }
	 ];
	
	[self addSubview:self.buttonSiteAccessible];
	[self addSubview:self.buttonSiteInaccessible];
	[self addSubview:self.imageViewAddComments];
	[self addSubview:self.labelAddComments];		
	[self addSubview:self.labelSelectCategory];
	[self addSubview:self.imageViewSelectCategory];	
	
	[UIView animateWithDuration:modalTab__duration__changeConfiguration delay:0.0f options:UIViewAnimationCurveEaseOut
					 animations:^{
						 [self.imageViewAddComments setFrame:CGRectMake(0.5 * (self.frame.size.width - reportSiteTab__imageViewAddComments__width - reportSiteTab__labelAddComments__width),
																		reportSiteTab__imageViewAddComments__yOrigin,
																		reportSiteTab__imageViewAddComments__width,
																		reportSiteTab__imageViewAddComments__height)];		
						 [self.labelAddComments setFrame:CGRectMake(self.imageViewAddComments.frame.origin.x + reportSiteTab__imageViewAddComments__width + reportSiteTab__labels__xGapAfterImages,
																	reportSiteTab__labelAddComments__yOrigin,
																	reportSiteTab__labelAddComments__width,
																	reportSiteTab__labelAddComments__height)];
						 [self.imageViewSelectCategory setFrame:CGRectMake(0.5 * (self.frame.size.width - reportSiteTab__imageViewSelectCategory__width - reportSiteTab__labelSelectCategory__width),
																		   reportSiteTab__imageViewSelectCategory__yOrigin,
																		   reportSiteTab__imageViewSelectCategory__width,
																		   reportSiteTab__imageViewSelectCategory__height)];		
						 [self.labelSelectCategory setFrame:CGRectMake(self.imageViewSelectCategory.frame.origin.x + reportSiteTab__imageViewSelectCategory__width + reportSiteTab__labels__xGapAfterImages,
																	   reportSiteTab__labelSelectCategory__yOrigin,
																	   reportSiteTab__labelSelectCategory__width,
																	   reportSiteTab__labelSelectCategory__height)];
						 [self.buttonSiteAccessible setFrame:CGRectMake(self.buttonSiteAccessible.frame.origin.x,
																		reportSiteTab__mainButtons__yOrigin_default,
																		reportSiteTab__mainButtons__width,
																		reportSiteTab__mainButtons__height)];
						 [self.buttonSiteInaccessible setFrame:CGRectMake(self.buttonSiteInaccessible.frame.origin.x,
																		  reportSiteTab__mainButtons__yOrigin_default,
																		  reportSiteTab__mainButtons__width,
																		  reportSiteTab__mainButtons__height)];						 
					 }
					 completion:^(BOOL finished){
					 }
	 ];
}

@end
