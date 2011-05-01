//
//  SiteSummary.m
//  Herdict
//
//  Created by Christian Brink on 3/22/11.
//  Copyright 2011 Herdict. All rights reserved.
//

#import "SiteSummary.h"
#import "Constants.h"


@implementation SiteSummary

@synthesize textView1;
@synthesize textView2;
@synthesize loadingIndicator;
@synthesize loadingText;

- (id)initWithFrame:(CGRect)frame {

	self = [super initAsModalTabNumber:1 defaultYOrigin:siteSummaryTab__yOrigin__configurationDefault withTabLabelText:(NSString*)siteSummaryTab__tabLabel__text];
	
	if (self) {

		[self setColorComponentsWithRed:themeColorRed withGreen:themeColorGreen withBlue:themeColorBlue withAlpha:0.9f];
//		[self setColorComponentsWithRed:0.694f withGreen:0.69f withBlue:0.69f withAlpha:0.9f];
//		[self setColorComponentsWithRed:1.0f withGreen:0.4f withBlue:0.0f withAlpha:0.8f];

		self.textView1 = [[UITextView alloc] initWithFrame:CGRectMake(32, 5 + modalTab__tabLabel__heightDefault, 280, 55)];
		self.textView1.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
		self.textView1.backgroundColor = [UIColor clearColor];
		self.textView1.textColor = [UIColor colorWithRed:modalTab__text__colorRed green:modalTab__text__colorGreen blue:modalTab__text__colorBlue alpha:1];
		self.textView1.editable = NO;
		self.textView1.text = @"This site has been\nreported inaccessible:";
		self.textView1.userInteractionEnabled = NO;
		[self addSubview:self.textView1];
		
		self.textView2 = [[UITextView alloc] initWithFrame:CGRectMake(32, 53 + modalTab__tabLabel__heightDefault, 280, 55)];
		self.textView2.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
		self.textView2.backgroundColor = [UIColor clearColor];
		self.textView2.textColor = [UIColor colorWithRed:modalTab__text__colorRed green:modalTab__text__colorGreen blue:modalTab__text__colorBlue alpha:1];
		self.textView2.editable = NO;
		self.textView2.userInteractionEnabled = NO;
	//	[self addSubview:self.textView2];
		
		// --	Set up loadingIndicator and loadingText
		self.loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		[self.loadingIndicator setFrame:CGRectMake(0.5 * (self.frame.size.width - (siteSummaryTab_loadingAnimation__diameter + 11 + siteSummaryTab_loadingText__width)),
												   modalTab__tabLabel__heightDefault + 0.5 * ((vcCheckSite__height - siteSummaryTab__yOrigin__configurationDefault) - modalTab__tabLabel__heightDefault - siteSummaryTab_loadingAnimation__diameter),
												   siteSummaryTab_loadingAnimation__diameter,
												   siteSummaryTab_loadingAnimation__diameter)];
		self.loadingIndicator.backgroundColor = [UIColor clearColor];
		[self.loadingIndicator startAnimating];
		self.loadingText = [[UILabel alloc] initWithFrame:CGRectMake(12 + self.loadingIndicator.frame.origin.x + siteSummaryTab_loadingAnimation__diameter,
																	 1 + modalTab__tabLabel__heightDefault + 0.5 * ((vcCheckSite__height - siteSummaryTab__yOrigin__configurationDefault) - modalTab__tabLabel__heightDefault - siteSummaryTab_loadingAnimation__diameter),
																	 siteSummaryTab_loadingText__width,
																	 siteSummaryTab_loadingText__height + 5)];
		self.loadingText.text = @"Getting Summary...";
		self.loadingText.font = [UIFont fontWithName:@"Helvetica-Bold" size:siteSummaryTab_loadingText__fontSize];

		self.loadingText.backgroundColor = [UIColor clearColor];
		self.loadingText.textColor = [UIColor colorWithRed:modalTab__text__colorRed green:modalTab__text__colorGreen blue:modalTab__text__colorBlue alpha:1];
    }
    return self;
}

- (void)dealloc {
	[loadingText release];
	[loadingIndicator release];
	[textView2 release];
	[textView1 release];
    [super dealloc];
}

- (void) setStateLoading {

	[self.textView1 removeFromSuperview];
	[self.textView2 removeFromSuperview];
	[self addSubview:self.loadingIndicator];
	[self addSubview:self.loadingText];	
}


- (void) setStateLoaded:(NSString *)theMessageString theColor:(int)theSheepColor {

	[self.loadingIndicator removeFromSuperview];
	[self.loadingText removeFromSuperview];

	self.textView2.text = theMessageString;
	[self addSubview:self.textView1];
	[self addSubview:self.textView2];	

	//	if (sheepColor == 0) {
	//		self.theTabSiteSummary.theBackground.backgroundColor = UIColorFromRGB(0x98D428);
	//	} else if (sheepColor == 1) {
	//		self.theTabSiteSummary.theBackground.backgroundColor = UIColorFromRGB(0x98D428);
	//	} else if (sheepColor == 2) {
	//		self.theTabSiteSummary.theBackground.backgroundColor = UIColorFromRGB(0xFF6600);
	//	}
}

@end
