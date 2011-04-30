//
//  TabTracker.m
//  Herdict
//
//  Created by Christian Brink on 3/28/11.
//  Copyright 2011 Herdict. All rights reserved.
//

#import "TabTracker.h"


@implementation TabTracker


- (TabTracker *)initAtTab:(int)tabNumber {
    
	// --	Decide frame here
	CGRect frame = CGRectMake([self xOffset:tabNumber] - (tabTracker__width / 2.0f),
							  480.0f - statusBar__height - 49.0f - (tabTracker__height - 2.0f),
							  tabTracker__width,
							  tabTracker__height);	
	
    self = [super initWithFrame:frame];
    if (self) {
		self.backgroundColor = [UIColor clearColor];
	}
		
	self.layer.masksToBounds = NO;
	self.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
	self.layer.shadowRadius = 1.0f;
	self.layer.shadowOpacity = 0.8f;
	self.layer.shouldRasterize = YES;
	self.layer.shadowPath = [self newPath];	
	
    return self;
}

- (void)drawRect:(CGRect)rect {
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextSetLineJoin(context, kCGLineJoinRound);
	CGContextSetLineWidth(context, 2.0f);

	CGContextSetRGBStrokeColor(context, 0.2f, 0.2f, 0.2f, 1.0f);
//	CGContextSetRGBFillColor(context, 0.2f, 0.2f, 0.2f, 1.0f);
	CGContextSetRGBFillColor(context, 0.1f, 0.1f, 0.1f, 1.1f);
	
	CGContextAddPath(context, [self newPath]);
	
	CGContextDrawPath(context, kCGPathFillStroke);
	
//	CGContextClip(context);
}

- (CGPathRef) newPath {

	CGFloat selfWidth = self.frame.size.width;
	CGFloat selfHeight = self.frame.size.height;
		
	CGMutablePathRef thePath = CGPathCreateMutable();
	
	// --	Begin at bottom right corner.
	CGPathMoveToPoint(thePath, NULL, selfWidth, selfHeight);
	// --	Line to top middle corner.
	CGPathAddLineToPoint(thePath, NULL, selfWidth / 2, 0.0f);
	// --	Line to bottom left corner.
	CGPathAddLineToPoint(thePath, NULL, 0.0f, selfHeight);
	// --	Line to bottom right corner.
	CGPathAddLineToPoint(thePath, NULL, selfWidth, selfHeight);
	CGPathCloseSubpath(thePath);
	
	return thePath;
	
}

- (CGFloat) xOffset:(int)tabNumber {

	CGFloat xOffset;
	if (tabNumber == 0) {
		xOffset = 54.0f;
	} else if (tabNumber == 1) {
		xOffset = 160.0f;
	} else if (tabNumber == 2) {
		xOffset = 320.0f - 54.0f;
	}
	
	return xOffset;
}

- (void) moveFromTab:(int)currentTabNum toTab:(int)selectedTabNum {	
//	NSLog(@"called [tabTracker moveFromTab...]");
	
	[self setCenter:CGPointMake([self xOffset:currentTabNum], self.center.y)];	
	[UIView animateWithDuration:0.55 delay:0 options:UIViewAnimationOptionCurveEaseInOut
					 animations:^{
						 [self setCenter:CGPointMake([self xOffset:selectedTabNum], self.center.y)];
					 } completion:^(BOOL finished){
					 }
	 ];
}

- (void)dealloc {
    [super dealloc];
}


@end
