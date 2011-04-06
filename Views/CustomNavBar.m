//
//  CustomNavBar.m
//  Herdict
//
//  Created by Christian Brink on 3/27/11.
//  Copyright 2011 Herdict. All rights reserved.
//

#import "CustomNavBar.h"


@implementation CustomNavBar

- (CustomNavBar *) initWithFrame:(CGRect)frame {
	
	self = [super initWithFrame:frame];
	if (self) {
		
		[self setBarStyle:UIBarStyleBlackTranslucent];
		self.layer.cornerRadius = 4;
		self.backgroundColor = [UIColor blackColor];
		self.layer.masksToBounds = YES;
	}
	return self;
}

- (void)dealloc {
    [super dealloc];
}

- (void)drawRect:(CGRect)rect {
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGFloat cornerRad = self.layer.cornerRadius;
	CGFloat selfWidth = self.frame.size.width;
	CGFloat selfHeight = self.frame.size.height;
	
	CGContextSetLineJoin(context, kCGLineJoinRound);
	CGContextSetLineWidth(context, 0);
	CGContextSetRGBStrokeColor(context, 0.3, 0.3, 0.3, 0.4); 
	
	CGContextBeginPath(context);	
	// --	Begin at top right corner.
	CGContextMoveToPoint(context,
						 selfWidth		- cornerRad,//			- stroke,
						 0//				+ stroke
						 );
	// --	Line to top left corner.
	CGContextAddLineToPoint(context,
							0			+ cornerRad,//			+ stroke,
							0//			+ stroke
							);
	// --	Arc around top left corner.
	CGContextAddArcToPoint(context,
						   0,//			+ stroke,
						   0,//			+ stroke,
						   0,//			+ stroke,
						   0			+ cornerRad,//			+ stroke,
						   cornerRad
						   );
	// --	Line to bottom left corner.
	CGContextAddLineToPoint(context,
							0,//			+ stroke,
							selfHeight//			- stroke
							);
	// --	Line to bottom right corner.
	CGContextAddLineToPoint(context,
							selfWidth,//			- stroke,
							selfHeight//	- stroke
							);
	// --	Line to top right corner.
	CGContextAddLineToPoint(context,
							selfWidth,//	- stroke,
							0			+ cornerRad//			+ stroke
							);
	// --	Arc around top right corner.
	CGContextAddArcToPoint(context,
						   selfWidth,//	- stroke,
						   0,//			+ stroke,
						   selfWidth	- cornerRad,//			- stroke,
						   0,//			+ stroke,
						   cornerRad);
	// --	Close the path.
	CGContextClosePath(context);
	
	CGGradientRef myGradient;
	
	CGFloat locations[4];
	CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
	NSMutableArray *colors = [NSMutableArray arrayWithCapacity:4];
	UIColor *color0 = [UIColor colorWithRed:themeColorRed green:themeColorGreen blue:themeColorBlue alpha:1];
	UIColor *color1 = [UIColor colorWithRed:(themeColorRed - 0.032) green:(themeColorGreen - 0.032) blue:(themeColorBlue - 0.032)  alpha:1.0];	
	UIColor *color2 = [UIColor colorWithRed:(themeColorRed - 0.062) green:(themeColorGreen - 0.062) blue:(themeColorBlue - 0.062)  alpha:1.0];
	UIColor *color3 = [UIColor colorWithRed:(themeColorRed - navBar__colorDelta) green:(themeColorGreen - navBar__colorDelta) blue:(themeColorBlue - navBar__colorDelta)  alpha:1.0];
	
	locations[0] = 0.00;
	[colors addObject:(id)[color0 CGColor]];
	locations[1] = 0.15;
	[colors addObject:(id)[color1 CGColor]];
	locations[2] = 0.275;
	[colors addObject:(id)[color2 CGColor]];
	locations[3] = 1.0;
	[colors addObject:(id)[color3 CGColor]];
	
	myGradient = CGGradientCreateWithColors(space, (CFArrayRef)colors, locations);
	CGColorSpaceRelease(space);
	
	CGRect currentBounds = self.bounds;
	CGPoint topCenter = CGPointMake(CGRectGetMidX(currentBounds), 0.0f);
	CGPoint bottomCenter = CGPointMake(CGRectGetMidX(currentBounds), navBar__height);
	CGContextDrawLinearGradient(context, myGradient, topCenter, bottomCenter, 0);
	
    CGGradientRelease(myGradient);
    CGColorSpaceRelease(space);
	
	CGContextDrawPath(context, kCGPathStroke);
}

@end
