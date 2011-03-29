//
//  FormCell.m
//  Herdict
//
//  Created by Christian Brink on 3/24/11.
//  Copyright 2011 Herdict. All rights reserved.
//

#import "FormCell.h"


@implementation FormCell

@synthesize iconBackground;
@synthesize mainBackground;

@synthesize theIconView;

@synthesize cellLabel;
@synthesize cellDetailLabel;

@synthesize whiteScreen;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		
		/* --	Get rid of the default UITableViewCell backgroundView	-- */
		UIView *backView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
		backView.backgroundColor = [UIColor clearColor];
		self.backgroundView = backView;
		self.backgroundColor = [UIColor clearColor];
		self.layer.cornerRadius = 5;

		self.selectionStyle = UITableViewCellSelectionStyleNone;

//		self.iconBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
//		self.iconBackground.backgroundColor = [UIColor whiteColor];
//		[self addSubview:self.iconBackground];
//		self.mainBackground = [[UIView alloc] initWithFrame:CGRectMake(80, 0, 260, 80)];
//		self.mainBackground.backgroundColor = [UIColor whiteColor];
//		[self addSubview:self.mainBackground];
		
		self.cellLabel = [[UILabel alloc] initWithFrame:CGRectMake(93, 10, 240, 25)];
		self.cellLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
		self.cellLabel.textColor = [UIColor blackColor];
		self.cellLabel.alpha = 0.85;
		self.cellLabel.backgroundColor = [UIColor clearColor];
		[self addSubview:self.cellLabel];
		
		self.cellDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(93, 45, 240, 22)];
		self.cellDetailLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
		self.cellDetailLabel.textColor = [UIColor grayColor];
		self.cellDetailLabel.alpha = 0.85;
		self.cellDetailLabel.backgroundColor = [UIColor clearColor];
		[self addSubview:self.cellDetailLabel];
		
		self.theIconView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 12, diameterForFormCellIconView, diameterForFormCellIconView)];
		[self addSubview:self.theIconView];
		
//		self.whiteScreen = [[UIView alloc] initWithFrame:self.frame];
//		[self addSubview:self.whiteScreen];
//		self.whiteScreen.backgroundColor = [UIColor whiteColor];
//		self.whiteScreen.alpha = 0;
	}
    
    return self;
}

- (void) drawRect:(CGRect)rect {

	CGContextRef context = UIGraphicsGetCurrentContext();
	
//	CGFloat cornerRad = self.layer.cornerRadius;
//	CGFloat selfwidth = self.frame.size.width;
//	CGFloat selfheight = self.frame.size.height;
//	
//	CGContextSetLineJoin(context, kCGLineJoinRound);
//	CGContextSetLineWidth(context, 1);
//	CGContextSetRGBStrokeColor(context, 0.3, 0.3, 0.3, 0.4); 
//	
//	CGContextBeginPath(context);	
//	// --	Begin at top right corner.
//	CGContextMoveToPoint(context,
//						 selfwidth		- cornerRad,//			- stroke,
//						 0//				+ stroke
//						 );
//	// --	Line to top left corner.
//	CGContextAddLineToPoint(context,
//							0			+ cornerRad,//			+ stroke,
//							0//			+ stroke
//							);
//	// --	Arc around top left corner.
//	CGContextAddArcToPoint(context,
//						   0,//			+ stroke,
//						   0,//			+ stroke,
//						   0,//			+ stroke,
//						   0			+ cornerRad,//			+ stroke,
//						   cornerRad
//						   );
//	// --	Line to bottom left corner.
//	CGContextAddLineToPoint(context,
//							0,//			+ stroke,
//							selfheight//			- stroke
//							);
//	// --	Line to bottom right corner.
//	CGContextAddLineToPoint(context,
//							selfwidth,//			- stroke,
//							selfheight//	- stroke
//							);
//	// --	Line to top right corner.
//	CGContextAddLineToPoint(context,
//							selfwidth,//	- stroke,
//							0			+ cornerRad//			+ stroke
//							);
//	// --	Arc around top right corner.
//	CGContextAddArcToPoint(context,
//						   selfwidth,//	- stroke,
//						   0,//			+ stroke,
//						   selfwidth	- cornerRad,//			- stroke,
//						   0,//			+ stroke,
//						   cornerRad);
//	// --	Close the path.
//	CGContextClosePath(context);
//	
//	// --	Clip on the path.
//	CGContextClip(context);
//	
	CGGradientRef myGradient;
	
	CGFloat locations[5];
	CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
	NSMutableArray *colors = [NSMutableArray arrayWithCapacity:5];
	UIColor *color0 = [UIColor colorWithRed:themeRed green:themeGreen blue:themeBlue alpha:1];
	UIColor *color1 = [UIColor colorWithRed:(themeRed - 0.032) green:(themeGreen - 0.032) blue:(themeBlue - 0.032)  alpha:0.9];	
	UIColor *color2 = [UIColor colorWithRed:(themeRed - 0.082) green:(themeGreen - 0.082) blue:(themeBlue - 0.082)  alpha:0.9];
	UIColor *color3 = [UIColor colorWithRed:(themeRed - urlBarColorDelta) green:(themeGreen - urlBarColorDelta) blue:(themeBlue - urlBarColorDelta)  alpha:0.9];
	UIColor *color4 = [UIColor colorWithRed:(themeRed - 0.282) green:(themeGreen - 0.282) blue:(themeBlue - 0.282)  alpha:0.9];

	locations[0] = 0.00;
	[colors addObject:(id)[color0 CGColor]];
	locations[1] = 0.6;
	[colors addObject:(id)[color1 CGColor]];
	locations[2] = 0.85;
	[colors addObject:(id)[color2 CGColor]];
	locations[3] = 0.94;
	[colors addObject:(id)[color3 CGColor]];	
	locations[4] = 1.0;
	[colors addObject:(id)[color4 CGColor]];
	
	myGradient = CGGradientCreateWithColors(space, (CFArrayRef)colors, locations);
	CGColorSpaceRelease(space);
	
	CGRect currentBounds = self.bounds;
	CGPoint topCenter = CGPointMake(CGRectGetMidX(currentBounds), 0.0f);
	CGPoint bottomCenter = CGPointMake(CGRectGetMidX(currentBounds), heightForFormCell);
	CGContextDrawLinearGradient(context, myGradient, topCenter, bottomCenter, 0);
	
    CGGradientRelease(myGradient);
    CGColorSpaceRelease(space);
	
	CGContextDrawPath(context, kCGPathStroke);
}

- (void)dealloc {
    [super dealloc];
}


@end
