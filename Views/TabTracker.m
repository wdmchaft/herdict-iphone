//
//  TabTracker.m
//  Herdict
//
//  Created by Christian Brink on 3/28/11.
//  Copyright 2011 Herdict. All rights reserved.
//

#import "TabTracker.h"


@implementation TabTracker


- (id)initAtTab:(int)tabNumber {
    
	/* --	Decide frame here	-- */
	CGRect frame = CGRectMake([self xOffset:tabNumber],
							  480 - 20 - 49 - (heightForTabTracker - 4),
							  widthForTabTracker,
							  heightForTabTracker);	
	
    self = [super initWithFrame:frame];
    if (self) {
		self.backgroundColor = [UIColor clearColor];
	}
	
	self.layer.masksToBounds = NO;
	self.layer.shadowOffset = CGSizeMake(0, 0);
	self.layer.shadowRadius = 5;
	self.layer.shadowOpacity = 0.8;
	
    return self;
}

- (void)drawRect:(CGRect)rect {
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGFloat cornerRad = self.layer.cornerRadius;
	CGFloat selfwidth = self.frame.size.width;
	CGFloat selfheight = self.frame.size.height;
	
	CGContextSetLineJoin(context, kCGLineJoinRound);
	CGContextSetLineWidth(context, 2);

	CGContextSetRGBStrokeColor(context, 0.0, 0.0, 0.0, 0.4);
	CGContextSetRGBFillColor(context, 0, 0, 0, 0.85);
	
	CGContextBeginPath(context);	

	// --	Begin at bottom right corner.
	CGContextMoveToPoint(context,
						 selfwidth,
						 selfheight
						 );
	// --	Line to top middle corner.
	CGContextAddLineToPoint(context,
							selfwidth / 2,
							0
							);
	// --	Line to bottom left corner.
	CGContextAddLineToPoint(context,
						   0,
						   selfheight
						   );
	// --	Line to bottom right corner.
	CGContextAddLineToPoint(context,
							selfwidth,
							selfheight
							);
	CGContextClosePath(context);

	CGContextDrawPath(context, kCGPathFillStroke);
	
	CGContextClip(context);
}

- (CGFloat) xOffset:(int)tabNumber {

	CGFloat xOffset;
	if (tabNumber == 0) {
		xOffset = 54.0;
	} else if (tabNumber == 1) {
		xOffset = 160.0;
	} else if (tabNumber == 2) {
		xOffset = 320.0 - 54.0;
	}
	
	return xOffset;
}

- (void) moveFromTab:(int)currentTabNum toTab:(int)selectedTabNum {
	
	NSLog(@"called [tabTracker moveFromTab...]");
	
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
