//
//  LoadingBar.m
//  Herdict
//
//  Created by Christian Brink on 4/29/11.
//  Copyright 2011 Herdict. All rights reserved.
//

#import "LoadingBar.h"
#import "Constants.h"

@implementation LoadingBar

@synthesize loadingIndicator;
@synthesize loadingText;

@synthesize componentRed;
@synthesize componentGreen;
@synthesize componentBlue;
@synthesize componentAlpha;	

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
		
		self.backgroundColor = [UIColor clearColor];
		self.componentRed = 0.0f;
		self.componentGreen = 0.0f;
		self.componentBlue = 0.0f;
		self.componentAlpha = 0.7f;		
		
		// --	Set up loadingIndicator
		self.loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
		[self.loadingIndicator setFrame:CGRectMake(0.5 * (self.frame.size.width - (loadingBarAnimation__diameter + loadingBarText__width)),
												   0.5 * (self.frame.size.height - loadingBarText__height),
												   loadingBarAnimation__diameter,
												   loadingBarAnimation__diameter)];
		[self.loadingIndicator startAnimating];
		[self addSubview:self.loadingIndicator];
		
		// --	Set up loadingText
		self.loadingText = [[UILabel alloc] initWithFrame:CGRectMake(self.loadingIndicator.frame.origin.x + loadingBarAnimation__diameter,
																	 0.5 * (self.frame.size.height - loadingBarText__height),
																	 loadingBarText__width,
																	 loadingBarText__height)];
		self.loadingText.backgroundColor = [UIColor clearColor];
		self.loadingText.text = @"Loading...";
		self.loadingText.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
		self.loadingText.textColor = [UIColor whiteColor];
		self.loadingText.textAlignment = UITextAlignmentCenter;
				
		[self addSubview:self.loadingIndicator];
		[self addSubview:self.loadingText];
    }	
    return self;
}

- (void) drawRect:(CGRect)rect {
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextSetLineJoin(context, kCGLineJoinRound);
	CGContextSetLineWidth(context, 2);
	
	CGContextSetRGBStrokeColor(context, self.componentRed, self.componentGreen, self.componentBlue, self.componentAlpha * 0.6f);
	CGContextSetRGBFillColor(context, self.componentRed, self.componentGreen, self.componentBlue, self.componentAlpha);
	
	CGContextAddPath(context, [self newPath]);
	
	CGContextDrawPath(context, kCGPathFillStroke);		
}

- (CGPathRef) newPath {
	
	CGFloat offsetForStroke = 1.0f;
	CGFloat cornerRad = 8.0f;
	CGFloat selfWidth = self.frame.size.width;
	CGFloat selfHeight = self.frame.size.height;
	
	CGMutablePathRef thePath = CGPathCreateMutable();
	
	// --	Begin at right edge to the right of hideTab, proceed counterclockwise.
	CGPathMoveToPoint(thePath, NULL, selfWidth, 0);
	CGPathAddLineToPoint(thePath, NULL, 0, 0);
	CGPathAddLineToPoint(thePath, NULL, 0, selfHeight);
	CGPathAddLineToPoint(thePath, NULL, selfWidth - cornerRad, selfHeight);
	CGPathAddArcToPoint(thePath, NULL, selfWidth, selfHeight, selfWidth, selfHeight - cornerRad, cornerRad);
	CGPathAddLineToPoint(thePath, NULL, selfWidth, 0);
	
	return thePath;
}

- (void) show {
	[UIView animateWithDuration:0.2
					 animations:^{
						 [self setFrame:CGRectMake(loadingBar__xOrigin, loadingBar__yOrigin__stateShow, loadingBar__width, loadingBar__height)];
					 }
	 ];
}



- (void) hide {
	[UIView animateWithDuration:0.2
					 animations:^{
						 [self setFrame:CGRectMake(loadingBar__xOrigin, loadingBar__yOrigin__stateHide, loadingBar__width, loadingBar__height)];
					 }
	 ];
}

- (void)dealloc {
	[loadingText release];
	[loadingIndicator release];
    [super dealloc];
}

@end
