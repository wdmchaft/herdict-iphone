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
		self.clipsToBounds = NO;
		self.layer.masksToBounds = NO;
	}
	return self;
}

- (void)drawRect:(CGRect)rect {
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGFloat cornerRad = self.layer.cornerRadius;
	CGFloat selfwidth = self.frame.size.width;
	CGFloat selfheight = self.frame.size.height;
	
	CGContextSetLineJoin(context, kCGLineJoinRound);
	CGContextSetLineWidth(context, 1);
	CGContextSetRGBStrokeColor(context, 0.3, 0.3, 0.3, 0.4); 
	
	CGContextBeginPath(context);	
	// --	Begin at top right corner.
	CGContextMoveToPoint(context,
						 selfwidth		- cornerRad,//			- stroke,
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
							selfheight//			- stroke
							);
	// --	Line to bottom right corner.
	CGContextAddLineToPoint(context,
							selfwidth,//			- stroke,
							selfheight//	- stroke
							);
	// --	Line to top right corner.
	CGContextAddLineToPoint(context,
							selfwidth,//	- stroke,
							0			+ cornerRad//			+ stroke
							);
	// --	Arc around top right corner.
	CGContextAddArcToPoint(context,
						   selfwidth,//	- stroke,
						   0,//			+ stroke,
						   selfwidth	- cornerRad,//			- stroke,
						   0,//			+ stroke,
						   cornerRad);
	// --	Close the path.
	CGContextClosePath(context);
	
	// --	Clip on the path.
	CGContextClip(context);
	
	CGGradientRef myGradient;
	
	CGFloat locations[4];
	CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
	NSMutableArray *colors = [NSMutableArray arrayWithCapacity:4];
	UIColor *color0 = [UIColor colorWithRed:themeRed green:themeGreen blue:themeBlue alpha:1];
	UIColor *color1 = [UIColor colorWithRed:(themeRed - 0.032) green:(themeGreen - 0.032) blue:(themeBlue - 0.032)  alpha:0.9];	
	UIColor *color2 = [UIColor colorWithRed:(themeRed - 0.082) green:(themeGreen - 0.082) blue:(themeBlue - 0.082)  alpha:0.9];
	UIColor *color3 = [UIColor colorWithRed:(themeRed - navBarColorDelta) green:(themeGreen - navBarColorDelta) blue:(themeBlue - navBarColorDelta)  alpha:0.9];
	
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
	CGPoint bottomCenter = CGPointMake(CGRectGetMidX(currentBounds), heightForNavBar);
	CGContextDrawLinearGradient(context, myGradient, topCenter, bottomCenter, 0);
	
    CGGradientRelease(myGradient);
    CGColorSpaceRelease(space);
	
	CGContextDrawPath(context, kCGPathStroke);
}

- (void)dealloc {
    [super dealloc];
}


@end
