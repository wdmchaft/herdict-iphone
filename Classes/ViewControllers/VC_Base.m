    //
//  VC_Base.m
//  Herdict
//
//  Created by Christian Brink on 3/26/11.
//  Copyright 2011 Herdict. All rights reserved.
//

#import "VC_Base.h"

@implementation VC_Base

@synthesize blackBackgroundForNavBar;
@synthesize navBar;
@synthesize navItem;
@synthesize buttonCancelTyping;
@synthesize buttonInfo;
@synthesize buttonWiFi;

@synthesize theUrlBar;
@synthesize theUrlBarMenu;

@synthesize theScreen;
@synthesize theTabTracker;

- (void)viewDidLoad {
    [super viewDidLoad];

	self.view.backgroundColor = [UIColor colorWithRed:themeRed green:themeGreen blue:themeBlue alpha:1];
	
	/* --	Set up theUrlBar	-- */
	self.theUrlBar = [[URLBar alloc] initWithFrame:CGRectMake(0,heightForNavBar - yOverhangForNavBar,320,heightForURLBar)];
	for (UIView *view in self.theUrlBar.subviews) {
		if ([view isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
			[view removeFromSuperview];
		}
	}
	[self.theUrlBar setBarStyle:UIBarStyleBlackTranslucent];
	[self.theUrlBar setDelegate:self];
	[self.view addSubview:self.theUrlBar];
	
	/* --	Set up blackBackgroundForNavBar, navBar, navItem	-- */
	self.blackBackgroundForNavBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, heightForNavBar + heightForURLBar - yOverhangForNavBar)];
	self.blackBackgroundForNavBar.backgroundColor = [UIColor blackColor];
	[self.view insertSubview:self.blackBackgroundForNavBar belowSubview:self.theUrlBar];	
	self.navBar = [[CustomNavBar alloc] initWithFrame:CGRectMake(0, 0, 320, heightForNavBar)];
	self.navBar.delegate = self;
	[self.view addSubview:self.navBar];		
	self.navItem = [[UINavigationItem alloc] initWithTitle:@"Herdict"];
	[self.navBar pushNavigationItem:navItem animated:NO];
	UIImage *herdictBadgeImage = [UIImage imageNamed:@"herdict_badge"];
	UIImageView *herdictBadgeImageView = [[[UIImageView alloc] initWithImage:herdictBadgeImage] autorelease];
	[herdictBadgeImageView setFrame:CGRectMake(
											   95,
											   -1,
											   130,
											   48)];
	navItem.titleView = herdictBadgeImageView;

	/* --	Set up navBar buttons	-- */
	self.buttonInfo = [CustomUIButton buttonWithType:UIButtonTypeCustom];
	[self.buttonInfo addTarget:self.buttonInfo action:@selector(setSelected) forControlEvents:UIControlEventTouchDown];
	[self.buttonInfo addTarget:self action:@selector(selectButtonInfo) forControlEvents:UIControlEventTouchUpInside];
	[self.buttonInfo addTarget:self.buttonInfo action:@selector(setNotSelected) forControlEvents:UIControlEventTouchUpOutside];
	[self.buttonInfo setBackgroundImage:[UIImage imageNamed:@"buttonInfo.png"] forState:UIControlStateNormal];
	[self.buttonInfo setFrame:CGRectMake(0, 0, 40, 30)];
	navItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:self.buttonInfo] autorelease];
	self.buttonWiFi = [CustomUIButton buttonWithType:UIButtonTypeCustom];
	[self.buttonWiFi addTarget:self.buttonWiFi action:@selector(setSelected) forControlEvents:UIControlEventTouchDown];
	[self.buttonWiFi addTarget:self action:@selector(selectButtonWiFi) forControlEvents:UIControlEventTouchUpInside];
	[self.buttonWiFi addTarget:self.buttonWiFi action:@selector(setNotSelected) forControlEvents:UIControlEventTouchUpOutside];
	[self.buttonWiFi setBackgroundImage:[UIImage imageNamed:@"buttonWiFi.png"] forState:UIControlStateNormal];
	[self.buttonWiFi setFrame:CGRectMake(0, 0, 40, 30)];
	navItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:self.buttonWiFi] autorelease];

	/* --	Set up buttonCancelTyping but don't use it here	-- */
	self.buttonCancelTyping = [CustomUIButton buttonWithType:UIButtonTypeCustom];
	[self.buttonCancelTyping setTitle:@"Cancel" forState:UIControlStateNormal];
	[self.buttonCancelTyping addTarget:self.buttonCancelTyping action:@selector(setSelected) forControlEvents:UIControlEventTouchDown];
	[self.buttonCancelTyping addTarget:self action:@selector(selectButtonCancelSearch) forControlEvents:UIControlEventTouchUpInside];
	[self.buttonCancelTyping addTarget:self.buttonCancelTyping action:@selector(setNotSelected) forControlEvents:UIControlEventTouchUpOutside];
	[self.buttonCancelTyping setFrame:CGRectMake(0,0,57,30)];
	
	/* --	Set up theUrlBarMenu	-- */
	NSMutableArray *urlMenuOptions = [NSMutableArray array];
	[urlMenuOptions addObject:[NSString stringWithString:@"Check Site"]];
	[urlMenuOptions addObject:[NSString stringWithString:@"Submit a Report"]];
	self.theUrlBarMenu = [[BubbleMenu alloc] initWithMessageHeight:0
														 withFrame:CGRectMake(-60, heightForNavBar - yOverhangForNavBar - 20, 170, 0)
												  menuOptionsArray:urlMenuOptions
														tailHeight:22
													   anchorPoint:CGPointMake(0, 0)];
	[self.view addSubview:self.theUrlBarMenu];
	
	/* --	Set up theScreen but don't show it yet		-- */
	self.theScreen = [[Screen alloc] initWithFrame:CGRectMake(0,
															  heightForNavBar - yOverhangForNavBar + heightForURLBar,
															  320,
															  480 - 20 - (heightForNavBar - yOverhangForNavBar + heightForURLBar) - 49)];
	self.theScreen.backgroundColor = [UIColor clearColor];
	
	/* --	Set up theTabTracker	-- */
	self.theTabTracker = [[TabTracker alloc] initAtTab:[self.tabBarController.viewControllers indexOfObject:self]];
	[self.view addSubview:self.theTabTracker];
}

- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	NSLog(@"%@ viewWillAppear", self.title);
	
	[self.view bringSubviewToFront:self.theUrlBar];
	[self.view bringSubviewToFront:self.navBar];
	[self.view bringSubviewToFront:self.theTabTracker];
	
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}
- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (void)dealloc {

	[buttonCancelTyping release];
	[theUrlBarMenu release];
	[theUrlBar release];		

    [super dealloc];
}


#pragma mark -
#pragma mark UINavigationItem

- (void) selectButtonInfo {
	[self.buttonInfo setNotSelected];
	// TODO: actually load the 'About' view...
}
- (void) selectButtonWiFi {
	[self.buttonWiFi setNotSelected];
	// TODO: actually load the 'About' view...
}
- (void) selectButtonCancelSearch {
	[self.buttonCancelTyping setNotSelected];
	[NSTimer scheduledTimerWithTimeInterval:0.0 target:self.theUrlBar selector:@selector(resignFirstResponder) userInfo:nil repeats:NO];
}

#pragma mark -
#pragma mark self as UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	[self selectBubbleMenuOption:[self.theUrlBarMenu viewWithTag:1]];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
	//NSLog(@"searchBarTextDidBeginEditing");
	self.navItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:self.buttonCancelTyping] autorelease];
	
	[self.theUrlBarMenu showBubbleMenuWithAnimation:[NSNumber numberWithBool:YES]];
	[self.view addSubview:self.theScreen];
	[self.view bringSubviewToFront:self.theScreen];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
	self.navItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:self.buttonWiFi] autorelease];
	[NSTimer scheduledTimerWithTimeInterval:0.00 target:self.theUrlBarMenu selector:@selector(hideBubbleMenu) userInfo:nil repeats:NO];
	[self.theScreen removeFromSuperview];
}


- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	NSLog(@"touchesBegan on %@", self);
	
	UITouch *touch = [touches anyObject];
	
	CGPoint touchPoint;
	
	// --	If it's in any of our BubbleMenu views....
	for (UIView *theMenu in [self.view subviews]) {
		if ([theMenu isKindOfClass:[BubbleMenu class]]) {
			if ([theMenu pointInside:[touch locationInView:theMenu] withEvent:nil]) {
				
				// --	If it 's in any of this BubbleMenu's tagged views...
				for (UIView *theSubview in [theMenu subviews]) {
					if (theSubview.tag > 0) {
						if ([theSubview pointInside:[touch locationInView:theSubview] withEvent:nil]) {
							[self performSelector:@selector(selectBubbleMenuOption:) withObject:theSubview afterDelay:0];
							return;
						}
					}
				}
			}
		}
	}
	if ([self.theUrlBar isFirstResponder]) {
		if (![self.theUrlBar pointInside:[touch locationInView:self.theUrlBar] withEvent:nil]) {		
			[self.theUrlBar resignFirstResponder];
		}
	}
}

- (void) selectBubbleMenuOption:(UITextView *)selectedSubview {
//	NSLog(@"selectBubbleMenuOption: %i", selectedSubview.tag);
	
	BubbleMenu *theMenu = [selectedSubview superview];
	
	// --	Have the menu show the selection background (and schedule its removal as well as the menu's).
	[theMenu showSelectionBackgroundForOption:selectedSubview.tag];
	[NSTimer scheduledTimerWithTimeInterval:0.25 target:theMenu selector:@selector(hideSelectionBackground) userInfo:nil repeats:NO];				
	
	if ([theMenu isEqual:self.theUrlBarMenu]) {
		if ([self urlTyped]) {
			[NSTimer scheduledTimerWithTimeInterval:0.0 target:self.theUrlBar selector:@selector(resignFirstResponder) userInfo:nil repeats:NO];		

			/* --	Use self.tabBarController to manage the switch... have to hand-hold it a little	-- */
			UITabBarController *theCon = self.tabBarController;
			if ([theCon.delegate tabBarController:theCon shouldSelectViewController:[theCon.viewControllers objectAtIndex:selectedSubview.tag]]) {
				self.tabBarController.selectedIndex = selectedSubview.tag;
				[theCon.delegate tabBarController:theCon didSelectViewController:[theCon.viewControllers objectAtIndex:selectedSubview.tag]];
			}
		}
	}
}

- (BOOL) urlTyped {
//	NSLog(@"entered urlTyped");

	if ([self.theUrlBar.text length] == 0) {
		//[self.theUrlBarMenu hideSelectionBackground];
		UIAlertView *alertNoUrl = [[UIAlertView alloc] initWithTitle:nil message:@"Please enter a URL." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alertNoUrl show];
		[alertNoUrl release];
		return NO;
	}
	return YES;
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {

	if ([alertView.message isEqualToString:@"Please enter a URL."]) {
		[self.theUrlBar becomeFirstResponder];
	}
}

- (NSString *) fixUpTypedUrl {
//	NSLog(@"fixUpTypedUrl");
	NSString *typedUrl = self.theUrlBar.text;
	
	typedUrl = [typedUrl lowercaseString];

	if ([typedUrl length] > 0) {
		NSRange rangeHttp = [typedUrl rangeOfString:@"http"];
		if (rangeHttp.location == NSNotFound) {
			//NSLog(@"location isEqual NSNotFound");
			typedUrl = [NSString stringWithFormat:@"%@%@", @"http://", typedUrl];
		}
	}
	
	return typedUrl;
}

@end
