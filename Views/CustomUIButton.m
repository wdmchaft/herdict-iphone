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
@synthesize componentRed;
@synthesize componentGreen;
@synthesize componentBlue;
@synthesize componentAlpha;

- (id) initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
		
		self.componentRed = themeColorRed;
		self.componentGreen = themeColorGreen;
		self.componentBlue = themeColorBlue;
		self.componentAlpha = 1.0f;
		
		self.layer.cornerRadius = 5;
		self.layer.masksToBounds = YES;
		
		[self.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
		self.titleLabel.shadowOffset = CGSizeMake(0, 1);

		[self setTitleColor:UIColorFromRGB(0x404040) forState:UIControlStateNormal];
		[self setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
		
		[self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
		[self setTitleShadowColor:UIColorFromRGB(0x404040) forState:UIControlStateSelected];
		
		self.titleLabel.backgroundColor = [UIColor clearColor];
//		self.titleLabel.alpha = 0.9;
		
		self.selectionScreen = [[UIView alloc] initWithFrame:CGRectZero];
		self.selectionScreen.backgroundColor = [UIColor blackColor];
		self.selectionScreen.alpha = 0;
		[self addSubview:self.selectionScreen];		
	}
    return self;
}

- (void)dealloc {
	[selectionScreen release];
    [super dealloc];
}

- (void) setColorComponentsWithRed:(CGFloat)theRed withGreen:(CGFloat)theGreen withBlue:(CGFloat)theBlue withAlpha:(CGFloat)theAlpha {
	self.componentRed = theRed;
	self.componentGreen = theGreen;
	self.componentBlue = theBlue;
	self.componentAlpha = theAlpha;
}

- (void) setFrame:(CGRect)frame {
	[super setFrame:frame];
	[self.selectionScreen setFrame:CGRectMake(1, 1, frame.size.width - 2, frame.size.height - 2)];
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
	
	CGFloat cornerRad = self.layer.cornerRadius;
	CGFloat selfWidth = self.frame.size.width;
	CGFloat selfHeight = self.frame.size.height;
	
	CGContextSetLineJoin(context, kCGLineJoinRound);
	CGContextSetLineWidth(context, 1);
	CGContextSetRGBStrokeColor(context, 0.25, 0.25, 0.25, 0.3); 
	
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
							selfHeight	- cornerRad//			- stroke
							);
	// --	Arc around bottom left corner.
	CGContextAddArcToPoint(context,
						   0,//			+ stroke,
						   selfHeight,//	- stroke,
						   0			+ cornerRad,//			+ stroke,
						   selfHeight,//	- stroke,
						   cornerRad
						   );
	// --	Line to bottom right corner.
	CGContextAddLineToPoint(context,
							selfWidth	- cornerRad,//			- stroke,
							selfHeight//	- stroke
							);
	// --	Arc around bottom right corner.
	CGContextAddArcToPoint(context,
						   selfWidth,//	- stroke,
						   selfHeight,//	- stroke,
						   selfWidth,//	- stroke,
						   selfHeight	- cornerRad,//			- stroke,
						   cornerRad
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
	
	CGContextClosePath(context);
	
	CGGradientRef myGradient;
	
	CGFloat locations[4];
	CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
	NSMutableArray *colors = [NSMutableArray arrayWithCapacity:3];
	UIColor *color0 = [UIColor colorWithRed:(self.componentRed - 0.442) green:(self.componentGreen - 0.442) blue:(self.componentBlue - 0.442)  alpha:self.componentAlpha];
	UIColor *color1 = [UIColor colorWithRed:self.componentRed green:self.componentGreen blue:self.componentBlue alpha:self.componentAlpha];
	UIColor *color2 = [UIColor colorWithRed:(self.componentRed - 0.202) green:(self.componentGreen - 0.202) blue:(self.componentBlue - 0.202)  alpha:self.componentAlpha];
	
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
	CGPoint bottomCenter = CGPointMake(CGRectGetMidX(currentBounds), self.frame.size.height);
	CGContextDrawLinearGradient(context, myGradient, topCenter, bottomCenter, 0);
	
    CGGradientRelease(myGradient);
//    CGColorSpaceRelease(space);
	
	CGContextDrawPath(context, kCGPathStroke);
	
}


@end
