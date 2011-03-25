//
//  FormCell.m
//  Herdict
//
//  Created by Christian Brink on 3/24/11.
//  Copyright 2011 Herdict. All rights reserved.
//

#import "FormCell.h"


@implementation FormCell

@synthesize floatRed;
@synthesize floatGreen;
@synthesize floatBlue;

@synthesize iconBackground;
@synthesize mainBackground;

@synthesize theIconView;

@synthesize cellLabel;
@synthesize cellDetailLabel;

@synthesize whiteScreen;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		
		//	Get rid of the default UITableViewCell backgroundView.
		UIView *backView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
		backView.backgroundColor = [UIColor clearColor];
		self.backgroundView = backView;
		self.backgroundColor = [UIColor clearColor];
		self.layer.cornerRadius = 5;		
		self.selectionStyle = UITableViewCellSelectionStyleNone;

		self.iconBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
		self.iconBackground.backgroundColor = [UIColor whiteColor];
		self.iconBackground.layer.cornerRadius = 5;
		[self addSubview:self.iconBackground];
		self.mainBackground = [[UIView alloc] initWithFrame:CGRectMake(43, 0, 260-43, 40)];
		self.mainBackground.backgroundColor = [UIColor whiteColor];
		self.mainBackground.layer.cornerRadius = 5;
		[self addSubview:self.mainBackground];
		
		self.cellLabel = [[UILabel alloc] initWithFrame:CGRectMake(53, 4, 200, 18)];
		self.cellLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
		self.cellLabel.textColor = [UIColor blackColor];
		self.cellLabel.alpha = 0.85;
		self.cellLabel.backgroundColor = [UIColor clearColor];
		[self addSubview:self.cellLabel];
		
		self.cellDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(53, 20, 200, 17)];
		self.cellDetailLabel.font = [UIFont fontWithName:@"Helvetica" size:13];
		self.cellDetailLabel.textColor = [UIColor grayColor];
		self.cellDetailLabel.alpha = 0.85;
		self.cellDetailLabel.backgroundColor = [UIColor clearColor];
		[self addSubview:self.cellDetailLabel];
		
		self.theIconView = [[UIImageView alloc] initWithFrame:CGRectMake(6, 6, 28, 28)];
		[self addSubview:self.theIconView];
		
		self.whiteScreen = [[UIView alloc] initWithFrame:self.frame];
		[self addSubview:self.whiteScreen];
		self.whiteScreen.backgroundColor = [UIColor whiteColor];
		self.whiteScreen.alpha = 0;
	}
    
    return self;
}

/*
- (void) drawRect:(CGRect)rect {

	CGContextRef context = UIGraphicsGetCurrentContext();
	
	// --	Geometry.
	
	CGFloat stroke = 3;
	CGFloat cornerRad = self.layer.cornerRadius;
	CGFloat offsetFromEdge = 2;
	CGFloat drawWidth = self.frame.size.width;
	CGFloat drawHeight = self.frame.size.height;
	
	
		
	CGContextBeginPath(context);	
	// --	Begin at top right corner.
	CGContextMoveToPoint(context,
						 - offsetFromEdge + drawWidth - cornerRad,			//			- stroke,
						 offsetFromEdge										//			+ stroke
						 );
	// --	Line to top left corner.
	CGContextAddLineToPoint(context,
							offsetFromEdge + cornerRad,			//			+ stroke,
							offsetFromEdge						//			+ stroke
							);
	// --	Arc around top left corner.
	CGContextAddArcToPoint(context,
						   offsetFromEdge,						//			+ stroke,
						   offsetFromEdge,						//			+ stroke,
						   offsetFromEdge,						//			+ stroke,
						   offsetFromEdge + cornerRad,			//			+ stroke,
						   cornerRad
						   );
	// --	Line to bottom left corner.
	CGContextAddLineToPoint(context,
							offsetFromEdge,						//			+ stroke,
							- offsetFromEdge + drawHeight - cornerRad				//			- stroke
							);
	// --	Arc around bottom left corner.
	CGContextAddArcToPoint(context,
						   offsetFromEdge,						//			+ stroke,
						   - offsetFromEdge + drawHeight,		//			- stroke,
						   offsetFromEdge + cornerRad,			//			+ stroke,
						   - offsetFromEdge + drawHeight,		//			- stroke,
						   cornerRad
						   );
	// --	Line to bottom right corner.
	CGContextAddLineToPoint(context,
							- offsetFromEdge + drawWidth - cornerRad,		//			- stroke,
							- offsetFromEdge + drawHeight					//	- stroke
							);
	// --	Arc around bottom right corner.
	CGContextAddArcToPoint(context,
						   - offsetFromEdge + drawWidth,				//	- stroke,
						   - offsetFromEdge + drawHeight,				//	- stroke,
						   - offsetFromEdge + drawWidth,				//	- stroke,
						   - offsetFromEdge + drawHeight - cornerRad,	//			- stroke,
						   cornerRad
						   );
	// --	Line to top right corner.
	CGContextAddLineToPoint(context,
							- offsetFromEdge + drawWidth,				//	- stroke,
							offsetFromEdge + cornerRad					//	+ stroke
							);
	// --	Arc around top right corner.
	CGContextAddArcToPoint(context,
						   - offsetFromEdge + drawWidth,				//	- stroke,
						   offsetFromEdge,								//			+ stroke,
						   - offsetFromEdge + drawWidth - cornerRad,	//			- stroke,
						   offsetFromEdge,								//			+ stroke,
						   cornerRad);
	
	CGContextClosePath(context);

	CGContextBeginPath(context);	
	// --	Begin at top right corner.
	CGContextMoveToPoint(context,
						 - offsetFromEdge + drawWidth - cornerRad,			//			- stroke,
						 offsetFromEdge										//			+ stroke
						 );
	// --	Line to top left corner.
	CGContextAddLineToPoint(context,
							offsetFromEdge + cornerRad,			//			+ stroke,
							offsetFromEdge						//			+ stroke
							);
	// --	Arc around top left corner.
	CGContextAddArcToPoint(context,
						   offsetFromEdge,						//			+ stroke,
						   offsetFromEdge,						//			+ stroke,
						   offsetFromEdge,						//			+ stroke,
						   offsetFromEdge + cornerRad,			//			+ stroke,
						   cornerRad
						   );
	// --	Line to bottom left corner.
	CGContextAddLineToPoint(context,
							offsetFromEdge,						//			+ stroke,
							- offsetFromEdge + drawHeight - cornerRad				//			- stroke
							);
	// --	Arc around bottom left corner.
	CGContextAddArcToPoint(context,
						   offsetFromEdge,						//			+ stroke,
						   - offsetFromEdge + drawHeight,		//			- stroke,
						   offsetFromEdge + cornerRad,			//			+ stroke,
						   - offsetFromEdge + drawHeight,		//			- stroke,
						   cornerRad
						   );
	// --	Line to bottom right corner.
	CGContextAddLineToPoint(context,
							- offsetFromEdge + drawWidth - cornerRad,		//			- stroke,
							- offsetFromEdge + drawHeight					//	- stroke
							);
	// --	Arc around bottom right corner.
	CGContextAddArcToPoint(context,
						   - offsetFromEdge + drawWidth,				//	- stroke,
						   - offsetFromEdge + drawHeight,				//	- stroke,
						   - offsetFromEdge + drawWidth,				//	- stroke,
						   - offsetFromEdge + drawHeight - cornerRad,	//			- stroke,
						   cornerRad
						   );
	// --	Line to top right corner.
	CGContextAddLineToPoint(context,
							- offsetFromEdge + drawWidth,				//	- stroke,
							offsetFromEdge + cornerRad					//	+ stroke
							);
	// --	Arc around top right corner.
	CGContextAddArcToPoint(context,
						   - offsetFromEdge + drawWidth,				//	- stroke,
						   offsetFromEdge,								//			+ stroke,
						   - offsetFromEdge + drawWidth - cornerRad,	//			- stroke,
						   offsetFromEdge,								//			+ stroke,
						   cornerRad);
	
	CGContextClosePath(context);	
	
	CGContextSetLineJoin(context, kCGLineJoinRound);
	CGContextSetLineWidth(context, 1);
	CGContextSetRGBStrokeColor(context, 1, 1, 1, 1);
	CGContextSetRGBFillColor(context, 1, 1, 1, 1);
	
	CGContextDrawPath(context, kCGPathFill);

//	CGGradientRef myGradient;
//	
//	CGFloat locations[4];
//	CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
//	NSMutableArray *colors = [NSMutableArray arrayWithCapacity:3];
//	UIColor *color2 = [UIColor colorWithRed:self.floatRed green:self.floatGreen blue:self.floatBlue alpha:0.925];
//	UIColor *color1 = [UIColor colorWithRed:(self.floatRed - 0.042) green:(self.floatGreen - 0.042) blue:(self.floatBlue - 0.042)  alpha:1];
//	UIColor *color3 = [UIColor colorWithRed:(self.floatRed - 0.032) green:(self.floatGreen - 0.032) blue:(self.floatBlue - 0.032)  alpha:1];
//	
//	locations[3] = 0.0;
//	[colors addObject:(id)[color1 CGColor]];
//	locations[2] = 0.1;
//	[colors addObject:(id)[color2 CGColor]];
//	locations[1] = 0.3;
//	[colors addObject:(id)[color2 CGColor]];
//	locations[0] = 1.0;
//	[colors addObject:(id)[color3 CGColor]];
//	
//	myGradient = CGGradientCreateWithColors(space, (CFArrayRef)colors, locations);
//	CGColorSpaceRelease(space);
//	
//	CGRect currentBounds = self.bounds;
//	CGPoint topCenter = CGPointMake(CGRectGetMidX(currentBounds), 0.0f);
//	CGPoint bottomCenter = CGPointMake(CGRectGetMidX(currentBounds), drawHeight);
//	CGContextDrawLinearGradient(context, myGradient, topCenter, bottomCenter, 0);
//	
//    CGGradientRelease(myGradient);
//    CGColorSpaceRelease(space);
		
}
*/

- (void)dealloc {
    [super dealloc];
}


@end
