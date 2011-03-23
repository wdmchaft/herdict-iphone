//
//  CustomBarButton.m
//  Herdict
//
//  Created by Christian Brink on 3/23/11.
//  Copyright 2011 Herdict. All rights reserved.
//

#import "CustomBarButton.h"
#import "Constants.h"

@implementation CustomBarButton

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
		
		UILabel *theTitle = [[[UILabel alloc] initWithFrame:CGRectMake(-1, 5, 49, 20)] autorelease];
		theTitle.text = @"Cancel";
		theTitle.textColor = UIColorFromRGB(0x515151);
		theTitle.alpha = 0.75;
		theTitle.textAlignment = UITextAlignmentCenter;
		theTitle.backgroundColor = [UIColor clearColor];
		[theTitle setFont:[UIFont boldSystemFontOfSize:12]];
		theTitle.shadowOffset = CGSizeMake(0, 1);
		theTitle.shadowColor = [UIColor whiteColor];
		[self addSubview:theTitle];
		
		self.layer.cornerRadius = 4;
		self.layer.masksToBounds = YES;
		[self setFrame:CGRectMake(0,0,49,30)];
		[self.titleLabel setFont:[UIFont boldSystemFontOfSize:13]];
		self.titleLabel.textColor = [UIColor blackColor];
		self.titleLabel.shadowOffset = CGSizeMake(0, -1);
		[self.titleLabel setFrame:CGRectMake(0, 5, 49, 20)];
		self.titleLabel.textAlignment = UITextAlignmentCenter;
		self.titleLabel.shadowColor = [UIColor grayColor];
	}
    return self;
}

- (void)drawRect:(CGRect)rect {

	CGContextRef context = UIGraphicsGetCurrentContext();

	CGFloat stroke = 3;
	CGFloat cornerRad = 4;
	CGFloat selfwidth = self.frame.size.width;
	CGFloat selfheight = self.frame.size.height;
	
	CGContextSetLineJoin(context, kCGLineJoinRound);
	CGContextSetLineWidth(context, 2.5);
	CGContextSetRGBStrokeColor(context, 0.25, 0.25, 0.25, 0.3); 
	
	CGContextBeginPath(context);	
	// --	Begin at top right corner of layer, i.e. tip of anchor.
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
	CGColorSpaceRef myColorspace;
	size_t num_locations = 2;
	CGFloat locations[2] = { 0.0, 1.0 };
	CGFloat components[8] = {0.925, 0.933, 0.937, 1.0,  // Begin color
		0.855, 0.861, 0.864, 1.0}; // End color
	
	myColorspace = CGColorSpaceCreateDeviceRGB();
	myGradient = CGGradientCreateWithColorComponents (myColorspace, components,
													  locations, num_locations);
	
	CGRect currentBounds = self.bounds;
	CGPoint topCenter = CGPointMake(CGRectGetMidX(currentBounds), 0.0f);
	CGPoint bottomCenter = CGPointMake(CGRectGetMidX(currentBounds), 30.0f);
	CGContextDrawLinearGradient(context, myGradient, topCenter, bottomCenter, 0);
	
    CGGradientRelease(myGradient);
    CGColorSpaceRelease(myColorspace);
	
	CGContextDrawPath(context, kCGPathStroke);

}

- (void)dealloc {
    [super dealloc];
}


@end
