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

@synthesize domainMessageString1;
@synthesize domainMessageString2;
@synthesize domainLoadingIndicator;
@synthesize domainLoadingText;

@synthesize domainAndPathMessageString1;
@synthesize domainAndPathMessageString2;
@synthesize domainAndPathLoadingIndicator;
@synthesize domainAndPathLoadingText;

- (id)initWithFrame:(CGRect)frame {

	self = [super initAsModalTabNumber:1 defaultYOrigin:siteSummaryTab__yOrigin__configurationDomainOnly withTabLabelText:(NSString*)siteSummaryTab__tabLabel__text];
	
	if (self) {

		[self setColorComponentsWithRed:themeColorRed withGreen:themeColorGreen withBlue:themeColorBlue withAlpha:0.9f];

        // --   domain
        
		self.domainMessageString1 = [[UITextView alloc] initWithFrame:CGRectZero];
		self.domainMessageString1.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
		self.domainMessageString1.backgroundColor = [UIColor clearColor];
		self.domainMessageString1.textColor = [UIColor colorWithRed:modalTab__text__colorRed green:modalTab__text__colorGreen blue:modalTab__text__colorBlue alpha:1];
		self.domainMessageString1.editable = NO;
		self.domainMessageString1.userInteractionEnabled = NO;
		
		self.domainMessageString2 = [[UITextView alloc] initWithFrame:CGRectMake(32, 53 + modalTab__tabLabel__heightDefault, 280, 55)];
		self.domainMessageString2.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
		self.domainMessageString2.backgroundColor = [UIColor clearColor];
		self.domainMessageString2.textColor = [UIColor colorWithRed:modalTab__text__colorRed green:modalTab__text__colorGreen blue:modalTab__text__colorBlue alpha:1];
		self.domainMessageString2.editable = NO;
		self.domainMessageString2.userInteractionEnabled = NO;
		
		self.domainLoadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		[self.domainLoadingIndicator setFrame:CGRectMake(0.5 * (self.frame.size.width - (siteSummaryTab_loadingAnimation__diameter + 11 + siteSummaryTab_domainLoadingText__width)),
												   modalTab__tabLabel__heightDefault + 0.5 * ((vcCheckSite__height - siteSummaryTab__yOrigin__configurationDomainOnly) - modalTab__tabLabel__heightDefault - siteSummaryTab_loadingAnimation__diameter),
												   siteSummaryTab_loadingAnimation__diameter,
												   siteSummaryTab_loadingAnimation__diameter)];
		self.domainLoadingIndicator.backgroundColor = [UIColor clearColor];
		[self.domainLoadingIndicator startAnimating];
		self.domainLoadingText = [[UILabel alloc] initWithFrame:CGRectMake(12 + self.domainLoadingIndicator.frame.origin.x + siteSummaryTab_loadingAnimation__diameter,
																	 1 + modalTab__tabLabel__heightDefault + 0.5 * ((vcCheckSite__height - siteSummaryTab__yOrigin__configurationDomainOnly) - modalTab__tabLabel__heightDefault - siteSummaryTab_loadingAnimation__diameter),
																	 siteSummaryTab_domainLoadingText__width,
																	 siteSummaryTab_domainLoadingText__height + 5)];
		self.domainLoadingText.text = @"Getting Summary...";
		self.domainLoadingText.font = [UIFont fontWithName:@"Helvetica-Bold" size:siteSummaryTab_domainLoadingText__fontSize];

		self.domainLoadingText.backgroundColor = [UIColor clearColor];
		self.domainLoadingText.textColor = [UIColor colorWithRed:modalTab__text__colorRed green:modalTab__text__colorGreen blue:modalTab__text__colorBlue alpha:1];
        
		self.domainMessageString1 = [[UITextView alloc] initWithFrame:CGRectZero];
		self.domainMessageString1.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
		self.domainMessageString1.backgroundColor = [UIColor clearColor];
		self.domainMessageString1.textColor = [UIColor colorWithRed:modalTab__text__colorRed green:modalTab__text__colorGreen blue:modalTab__text__colorBlue alpha:1];
		self.domainMessageString1.editable = NO;
		self.domainMessageString1.userInteractionEnabled = NO;
		
		self.domainMessageString2 = [[UITextView alloc] initWithFrame:CGRectMake(32, 53 + modalTab__tabLabel__heightDefault, 280, 55)];
		self.domainMessageString2.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
		self.domainMessageString2.backgroundColor = [UIColor clearColor];
		self.domainMessageString2.textColor = [UIColor colorWithRed:modalTab__text__colorRed green:modalTab__text__colorGreen blue:modalTab__text__colorBlue alpha:1];
		self.domainMessageString2.editable = NO;
		self.domainMessageString2.userInteractionEnabled = NO;
		
		// --	domainAndPath
        
		self.domainAndPathLoadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		[self.domainAndPathLoadingIndicator setFrame:CGRectMake(0.5 * (self.frame.size.width - (siteSummaryTab_loadingAnimation__diameter + 11 + siteSummaryTab_domainAndPathLoadingText__width)),
                                                         modalTab__tabLabel__heightDefault + 0.5 * ((vcCheckSite__height - siteSummaryTab__yOrigin__configurationDomainAndPath) - modalTab__tabLabel__heightDefault - siteSummaryTab_loadingAnimation__diameter),
                                                         siteSummaryTab_loadingAnimation__diameter,
                                                         siteSummaryTab_loadingAnimation__diameter)];
		self.domainAndPathLoadingIndicator.backgroundColor = [UIColor clearColor];
		[self.domainAndPathLoadingIndicator startAnimating];
		self.domainAndPathLoadingText = [[UILabel alloc] initWithFrame:CGRectMake(12 + self.domainAndPathLoadingIndicator.frame.origin.x + siteSummaryTab_loadingAnimation__diameter,
                                                                           1 + modalTab__tabLabel__heightDefault + 0.5 * ((vcCheckSite__height - siteSummaryTab__yOrigin__configurationDomainAndPath) - modalTab__tabLabel__heightDefault - siteSummaryTab_loadingAnimation__diameter),
                                                                           siteSummaryTab_domainAndPathLoadingText__width,
                                                                           siteSummaryTab_domainAndPathLoadingText__height + 5)];
		self.domainAndPathLoadingText.text = @"Getting Summary...";
		self.domainAndPathLoadingText.font = [UIFont fontWithName:@"Helvetica-Bold" size:siteSummaryTab_domainAndPathLoadingText__fontSize];
        
		self.domainAndPathLoadingText.backgroundColor = [UIColor clearColor];
		self.domainAndPathLoadingText.textColor = [UIColor colorWithRed:modalTab__text__colorRed green:modalTab__text__colorGreen blue:modalTab__text__colorBlue alpha:1];        
        
    }
    return self;
}

- (void)dealloc {
	[domainLoadingText release];
	[domainLoadingIndicator release];
	[domainMessageString2 release];
	[domainMessageString1 release];
    [super dealloc];
}

- (void) configureDefault {
	NSLog(@"ENTERING SiteSummary.configureDefault");
	
	self.yOrigin__current = siteSummaryTab__yOrigin__configurationDomainOnly;
	[self.delegate positionAllModalTabsInViewBehind:self];
	
	[UIView animateWithDuration:modalTab__duration__changeConfiguration delay:0.0f options:UIViewAnimationCurveEaseOut
					 animations:^{
						 
                         // this is where to set alpha 0 on anything that should disappear
                         self.domainAndPathLoadingText.alpha = 0;
                         self.domainAndPathLoadingIndicator.alpha = 0;
                         self.domainAndPathMessageString1.alpha = 0;
                         self.domainAndPathMessageString2.alpha = 0;                                                  
                         
					 }
					 completion:^(BOOL finished) {

						 // this is where to remove any alpha 0'd elements from superview
                         [self.domainAndPathLoadingText removeFromSuperview];
                         [self.domainAndPathLoadingIndicator removeFromSuperview];
                         [self.domainAndPathMessageString1 removeFromSuperview];
                         [self.domainAndPathMessageString2 removeFromSuperview];                                                  

                         // this is where to set alpha 1 on any just-removed elements (so they are ready for adding again)
                         self.domainAndPathLoadingText.alpha = 1;
                         self.domainAndPathLoadingIndicator.alpha = 1;
                         self.domainAndPathMessageString1.alpha = 1;
                         self.domainAndPathMessageString2.alpha = 1;
                         
						 // this is where to add whatever needs to be added at this point...
                         self.domainMessageString1.text = @"This site has been\nreported inaccessible:";
					 }
	 ];	
}

- (void) configureForDomainAndPath {
	NSLog(@"configureForDomainAndPath");
	
	self.yOrigin__current = siteSummaryTab__yOrigin__configurationDomainAndPath;
	[self.delegate positionAllModalTabsInViewBehind:self];
	
	[UIView animateWithDuration:modalTab__duration__changeConfiguration delay:0.0f options:UIViewAnimationCurveEaseOut
					 animations:^{
                         
                         // this is where to set alpha 0 on anything that should disappear
                         self.domainMessageString1.alpha = 0;
                         self.domainMessageString2.alpha = 0;                                                  
                         self.domainAndPathMessageString1.alpha = 0;
                         self.domainAndPathMessageString2.alpha = 0;                                                  
                         
					 }
					 completion:^(BOOL finished) {
                         
						 // this is where to remove any alpha 0'd elements from superview
                         [self.domainMessageString1 removeFromSuperview];
                         [self.domainMessageString2 removeFromSuperview];                                                  
                         [self.domainAndPathMessageString1 removeFromSuperview];
                         [self.domainAndPathMessageString2 removeFromSuperview];                                                  

                         // this is where to set alpha 1 on any just-removed elements (so they are ready for adding again)
                         self.domainMessageString1.alpha = 1;
                         self.domainMessageString2.alpha = 1;                                                  
                         self.domainAndPathMessageString1.alpha = 1;
                         self.domainAndPathMessageString2.alpha = 1;                                                  
						 
						 // this is where to add whatever needs to be added at this point...
                         [self addSubview:self.domainAndPathLoadingText];
                         [self addSubview:self.domainAndPathLoadingIndicator];
                         [self addSubview:self.domainLoadingText];
                         [self addSubview:self.domainLoadingIndicator];

                         // any specific changes:
                         self.domainMessageString1.text = [NSString stringWithFormat:@"%@ has been\nreported inaccessible:", [[self.delegate theUrlBar] text]];
                     }
	 ];	
}

- (void) setStateLoaded:(NSString *)theMessageString theColor:(int)theSheepColor domainOnly:(BOOL)isDomainOnly {

    if (isDomainOnly) {
        [self.domainLoadingIndicator removeFromSuperview];
        [self.domainLoadingText removeFromSuperview];        
        self.domainMessageString2.text = theMessageString;
        [self addSubview:self.domainMessageString1];
        [self addSubview:self.domainMessageString2];	
    } else {
        [self.domainAndPathLoadingIndicator removeFromSuperview];
        [self.domainAndPathLoadingText removeFromSuperview];        
        self.domainAndPathMessageString2.text = theMessageString;
        [self addSubview:self.domainAndPathMessageString1];
        [self addSubview:self.domainAndPathMessageString2];
    }
    

}

@end
