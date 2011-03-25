//
//  GradientBackground.m
//  Herdict
//
//  Created by Christian Brink on 3/23/11.
//  Copyright 2011 Herdict. All rights reserved.
//

#import "GradientBackground.h"

@implementation GradientBackground

@synthesize floatRed;
@synthesize floatGreen;
@synthesize floatBlue;
@synthesize highColor;

- (id) initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
		
		self.layer.cornerRadius = 6;
		self.layer.masksToBounds = YES;
	}
	return self;
}
- (void)drawRect:(CGRect)rect {
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGFloat stroke = 3;
	CGFloat cornerRad = self.layer.cornerRadius;
	CGFloat selfwidth = self.frame.size.width;
	CGFloat selfheight = self.frame.size.height;
	
	CGContextSetLineJoin(context, kCGLineJoinRound);
	CGContextSetLineWidth(context, 3);
	CGContextSetRGBStrokeColor(context, 0.25, 0.25, 0.25, 0.2); 
	
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
							selfheight	- cornerRad//			- stroke
							);
	// --	Arc around bottom left corner.
	CGContextAddArcToPoint(context,
						   0,//			+ stroke,
						   selfheight,//	- stroke,
						   0			+ cornerRad,//			+ stroke,
						   selfheight,//	- stroke,
						   cornerRad
						   );
	// --	Line to bottom right corner.
	CGContextAddLineToPoint(context,
							selfwidth	- cornerRad,//			- stroke,
							selfheight//	- stroke
							);
	// --	Arc around bottom right corner.
	CGContextAddArcToPoint(context,
						   selfwidth,//	- stroke,
						   selfheight,//	- stroke,
						   selfwidth,//	- stroke,
						   selfheight	- cornerRad,//			- stroke,
						   cornerRad
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
	
	CGContextClosePath(context);
	
	CGGradientRef myGradient;
	
	CGFloat locations[4];
	CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
	NSMutableArray *colors = [NSMutableArray arrayWithCapacity:3];
	UIColor *color2 = [UIColor colorWithRed:self.floatRed green:self.floatGreen blue:self.floatBlue alpha:1];
	UIColor *color1 = [UIColor colorWithRed:(self.floatRed - 0.132) green:(self.floatGreen - 0.132) blue:(self.floatBlue - 0.132)  alpha:0.9];
	UIColor *color3 = [UIColor colorWithRed:(self.floatRed - 0.042) green:(self.floatGreen - 0.042) blue:(self.floatBlue - 0.042)  alpha:0.9];
	
	locations[3] = 0.0;
	[colors addObject:(id)[color1 CGColor]];
	locations[2] = 0.1;
	[colors addObject:(id)[color2 CGColor]];
	locations[1] = 0.3;
	[colors addObject:(id)[color2 CGColor]];
	locations[0] = 1.0;
	[colors addObject:(id)[color3 CGColor]];
	
	myGradient = CGGradientCreateWithColors(space, (CFArrayRef)colors, locations);
	CGColorSpaceRelease(space);
	
	CGRect currentBounds = self.bounds;
	CGPoint topCenter = CGPointMake(CGRectGetMidX(currentBounds), 0.0f);
	CGPoint bottomCenter = CGPointMake(CGRectGetMidX(currentBounds), 30.0f);
	CGContextDrawLinearGradient(context, myGradient, topCenter, bottomCenter, 0);
	
    CGGradientRelease(myGradient);
    CGColorSpaceRelease(space);
	
	CGContextDrawPath(context, kCGPathStroke);
	
}

- (void)dealloc {
    [super dealloc];
}


@end
