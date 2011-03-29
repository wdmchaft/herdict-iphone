//
//  CustomUIButton.m
//  Herdict
//
//  Created by Christian Brink on 3/23/11.
//  Copyright 2011 Herdict. All rights reserved.
//

#import "CustomUIButton.h"
#import "Constants.h"

@implementation CustomUIButton

@synthesize selectionScreen;

//@synthesize theTitle;


- (id) initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:CGRectMake(0, 0, 57, 30)];
    if (self) {
		
		self.layer.cornerRadius = 5;
		self.layer.masksToBounds = YES;
		
		[self.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
		[self setTitleShadowOffset:CGSizeMake(0, 1)];

		[self setTitleColor:UIColorFromRGB(0x404040) forState:UIControlStateNormal];
		[self setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
		
		[self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
		[self setTitleShadowColor:UIColorFromRGB(0x404040) forState:UIControlStateSelected];
		
		self.titleLabel.backgroundColor = [UIColor clearColor];
//		self.titleLabel.alpha = 0.9;
				
		self.selectionScreen = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
		self.selectionScreen.backgroundColor = [UIColor blackColor];
		self.selectionScreen.alpha = 0;
		[self addSubview:self.selectionScreen];
	}
    return self;
}


- (void) setSelected {

	self.selectionScreen.alpha = 0.2;
	self.titleLabel.shadowOffset = CGSizeMake(0, -1);
}

- (void) setNotSelected {

	self.selectionScreen.alpha = 0;
	self.titleLabel.shadowOffset = CGSizeMake(0, 1);
}

 
- (void)drawRect:(CGRect)rect {
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGFloat stroke = 3;
	CGFloat cornerRad = self.layer.cornerRadius;
	CGFloat selfwidth = self.frame.size.width;
	CGFloat selfheight = self.frame.size.height;
	
	CGContextSetLineJoin(context, kCGLineJoinRound);
	CGContextSetLineWidth(context, 1);
	CGContextSetRGBStrokeColor(context, 0.25, 0.25, 0.25, 0.3); 
	
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
	UIColor *color0 = [UIColor colorWithRed:(themeRed - 0.442) green:(themeGreen - 0.442) blue:(themeBlue - 0.442)  alpha:0.9];
	UIColor *color1 = [UIColor colorWithRed:themeRed green:themeGreen blue:themeBlue alpha:1];
	UIColor *color2 = [UIColor colorWithRed:(themeRed - 0.202) green:(themeGreen - 0.202) blue:(themeBlue - 0.202)  alpha:0.9];
	
	locations[0] = 0.0;
	[colors addObject:(id)[color0 CGColor]];
	locations[1] = 0.07;
	[colors addObject:(id)[color1 CGColor]];
	locations[2] = 0.2;
	[colors addObject:(id)[color1 CGColor]];
	locations[3] = 1.0;
	[colors addObject:(id)[color2 CGColor]];
	
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
