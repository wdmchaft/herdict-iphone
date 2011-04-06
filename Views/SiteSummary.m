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
@synthesize hideLabel;
@synthesize loadingIndicator;
@synthesize loadingText;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
		self.backgroundColor = [UIColor clearColor];
		self.userInteractionEnabled = YES;
		
		self.layer.masksToBounds = NO;
		self.layer.shadowOffset = CGSizeMake(0, 0);
		self.layer.shadowRadius = 5;
		self.layer.shadowOpacity = 0.8;	
		self.layer.shouldRasterize = YES;
		self.layer.shadowPath = [self getPath];
		
		self.textView1 = [[UITextView alloc] initWithFrame:CGRectMake(32, 5 + heightForSiteSummaryHideTab, 280, 55)];
		self.textView1.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
		self.textView1.backgroundColor = [UIColor clearColor];
		self.textView1.textColor = [UIColor whiteColor];
		self.textView1.editable = NO;
		self.textView1.text = @"This site has been\nreported inaccessible:";
		self.textView1.userInteractionEnabled = NO;
		[self addSubview:self.textView1];
		
		self.textView2 = [[UITextView alloc] initWithFrame:CGRectMake(32, 53 + heightForSiteSummaryHideTab, 280, 55)];
		self.textView2.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
		self.textView2.backgroundColor = [UIColor clearColor];
		self.textView2.textColor = [UIColor whiteColor];
		self.textView2.editable = NO;
		self.textView2.userInteractionEnabled = NO;
	//	[self addSubview:self.textView2];
		
		self.hideLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - xOffsetForSiteSummaryHideTab - widthForSiteSummaryHideTab,
																   0,
																   widthForSiteSummaryHideTab,
																   heightForSiteSummaryHideTab)];
		self.hideLabel.backgroundColor = [UIColor clearColor];
		self.hideLabel.textAlignment = UITextAlignmentCenter;
		self.hideLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
		self.hideLabel.textColor = [UIColor whiteColor];
		self.hideLabel.text = textForSiteSummaryHideTabStateHidden;
		self.hideLabel.userInteractionEnabled = NO;
		[self addSubview:self.hideLabel];

		// --	Set up loadingIndicator and loadingText
		self.loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
		[self.loadingIndicator setFrame:CGRectMake(0.5 * (self.frame.size.width - (diameterForSiteSummaryLoadingAnimation + 11 + widthForSiteSummaryLoadingText)),
												   heightForSiteSummaryHideTab + 0.5 * (heightForSiteSummary - heightForSiteSummaryHideTab - diameterForSiteSummaryLoadingAnimation),
												   diameterForSiteSummaryLoadingAnimation,
												   diameterForSiteSummaryLoadingAnimation)];
		self.loadingIndicator.backgroundColor = [UIColor clearColor];
		[self.loadingIndicator startAnimating];
		self.loadingText = [[UILabel alloc] initWithFrame:CGRectMake(12 + self.loadingIndicator.frame.origin.x + diameterForSiteSummaryLoadingAnimation,
																	 1 + heightForSiteSummaryHideTab + 0.5 * (heightForSiteSummary - heightForSiteSummaryHideTab - diameterForSiteSummaryLoadingAnimation),
																	 widthForSiteSummaryLoadingText,
																	 heightForSiteSummaryLoadingText + 5)];
		self.loadingText.text = @"Getting Summary...";
		self.loadingText.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];

		self.loadingText.backgroundColor = [UIColor clearColor];
		self.loadingText.textColor = [UIColor whiteColor];
    }
    return self;
}

- (void)dealloc {
	[loadingText release];
	[loadingIndicator release];
	[hideLabel release];
	[textView2 release];
	[textView1 release];
    [super dealloc];
}

- (void) drawRect:(CGRect)rect {

	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextSetLineJoin(context, kCGLineJoinRound);
	CGContextSetLineWidth(context, 2);

	CGContextSetRGBStrokeColor(context, 1.0, 0.4, 0.0, 0.4);
	CGContextSetRGBFillColor(context, 1.0, 0.4, 0.0, 0.8);
	
	CGContextAddPath(context, [self getPath]);

	CGContextDrawPath(context, kCGPathFillStroke);		
}

- (CGPathRef) getPath {

	CGFloat offsetForStroke = 1;
	CGFloat cornerRad = 4;
	CGFloat selfWidth = self.frame.size.width;
	CGFloat selfHeight = self.frame.size.height;
	
	CGMutablePathRef thePath = CGPathCreateMutable();
	
	// --	Begin at right edge to the right of hideTab, proceed counterclockwise.
	CGPathMoveToPoint(thePath, NULL, selfWidth + 2, heightForSiteSummaryHideTab);
	CGPathAddLineToPoint(thePath, NULL, selfWidth - xOffsetForSiteSummaryHideTab, heightForSiteSummaryHideTab);
	CGPathAddLineToPoint(thePath, NULL, selfWidth - xOffsetForSiteSummaryHideTab, cornerRad);
	CGPathAddArcToPoint(thePath, NULL, selfWidth - xOffsetForSiteSummaryHideTab, 0 + offsetForStroke, selfWidth - xOffsetForSiteSummaryHideTab - cornerRad, 0 + offsetForStroke, cornerRad);
	CGPathAddLineToPoint(thePath, NULL, selfWidth - xOffsetForSiteSummaryHideTab - widthForSiteSummaryHideTab + cornerRad, 0 + offsetForStroke);
	CGPathAddArcToPoint(thePath, NULL, selfWidth - xOffsetForSiteSummaryHideTab - widthForSiteSummaryHideTab, 0 + offsetForStroke, selfWidth - xOffsetForSiteSummaryHideTab - widthForSiteSummaryHideTab, cornerRad, cornerRad);
	CGPathAddLineToPoint(thePath, NULL, selfWidth - xOffsetForSiteSummaryHideTab - widthForSiteSummaryHideTab, heightForSiteSummaryHideTab);
	CGPathAddLineToPoint(thePath, NULL, 0 - 2, heightForSiteSummaryHideTab);
	CGPathAddLineToPoint(thePath, NULL, 0 - offsetForStroke, selfHeight + 2);
	CGPathAddLineToPoint(thePath, NULL, selfWidth + offsetForStroke, selfHeight + 2);
	CGPathAddLineToPoint(thePath, NULL, selfWidth + 2, heightForSiteSummaryHideTab);
	
	return thePath;
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
	//		self.theSiteSummary.theBackground.backgroundColor = UIColorFromRGB(0x98D428);
	//	} else if (sheepColor == 1) {
	//		self.theSiteSummary.theBackground.backgroundColor = UIColorFromRGB(0x98D428);
	//	} else if (sheepColor == 2) {
	//		self.theSiteSummary.theBackground.backgroundColor = UIColorFromRGB(0xFF6600);
	//	}
}

- (void) positionSiteSummaryInView {
	
	// --	Haul the theSiteSummary up into view.
	[UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut
					 animations:^{
						 [self setFrame:CGRectMake(0,
												   480 - heightForStatusBar_real - 49 - heightForSiteSummary,
												   320,
												   heightForSiteSummary + 5)];
					 } completion:^(BOOL finished){
					 }
	 ];	
	
	// --	Switch hideLabel.text.
	[UIView animateWithDuration:0.15 delay:0 options:nil
					 animations:^{
//						 self.hideLabel.alpha = 0;
					 } completion:^(BOOL finished){
						 self.hideLabel.text = textForSiteSummaryHideTabStateShowing;
						 [UIView animateWithDuration:0.15 delay:0 options:nil
										  animations:^{
											  self.hideLabel.alpha = 1;
										  } completion:^(BOOL finished){
										  }
						  ];
					 }
	 ];
}

- (void) positionSiteSummaryOutOfView {
	
	// --	Shove the theSiteSummary down out of view.
	[UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut
					 animations:^{
						 [self setFrame:CGRectMake(0,
												   480 - heightForStatusBar_real - 48 - heightForSiteSummaryHideTab,
												   320,
												   heightForSiteSummary + 5)];
					 } completion:^(BOOL finished){
					 }
	 ];
	
	[UIView animateWithDuration:0.15 delay:0 options:nil
					 animations:^{
//						 self.hideLabel.alpha = 0;
					 } completion:^(BOOL finished){
						 
						 //	Switch hideLabel text.
						 self.hideLabel.text = textForSiteSummaryHideTabStateHidden;
						 						 
						 [UIView animateWithDuration:0.15 delay:0 options:nil
										  animations:^{
											  self.hideLabel.alpha = 1;
										  } completion:^(BOOL finished){
										  }
						  ];
					 }
	 ];
	
}

@end
