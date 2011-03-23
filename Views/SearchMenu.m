//
//  SearchMenu.m
//  Herdict
//
//  Created by Christian Brink on 3/19/11.
//  Copyright 2011 Herdict. All rights reserved.
//

#import "SearchMenu.h"
#import <QuartzCore/QuartzCore.h>


@implementation SearchMenu

@synthesize menuOption1;
@synthesize menuOption2;
@synthesize menuOption3;

@synthesize selectionBackgroundBasicFrame;
@synthesize selectionBackground;

@synthesize rotationWhenHidden;


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];

	self.selectionBackgroundBasicFrame = CGRectMake(5, 28, 140, 30);
	
	// --	Set up selectionBackground.  We will manipulate its backgroundColor and origin.y (from VC_Home). 
	self.selectionBackground = [[UIView alloc] initWithFrame:self.selectionBackgroundBasicFrame];
	self.selectionBackground.backgroundColor = [UIColor clearColor];
	self.selectionBackground.alpha = 0.8;
	self.selectionBackground.layer.cornerRadius = 4;
	[self addSubview:self.selectionBackground];
	
	self.menuOption1 = [[UITextView alloc] initWithFrame:CGRectMake(5, 28, 150, 30)];
	self.menuOption1.layer.cornerRadius = 4;
	self.menuOption1.textColor = [UIColor whiteColor];
	self.menuOption1.backgroundColor = [UIColor clearColor];
	self.menuOption1.text = @"Test This Site";
	self.menuOption1.userInteractionEnabled = NO;
	self.menuOption1.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
	[self addSubview:self.menuOption1];
	self.menuOption2 = [[UITextView alloc] initWithFrame:CGRectMake(5, 58, 150, 30)];
	self.menuOption2.layer.cornerRadius = 4;
	self.menuOption2.textColor = [UIColor whiteColor];
	self.menuOption2.backgroundColor = [UIColor clearColor];
	self.menuOption2.text = @"Get a Report";
	self.menuOption2.userInteractionEnabled = NO;
	self.menuOption2.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
	[self addSubview:self.menuOption2];
	self.menuOption3 = [[UITextView alloc] initWithFrame:CGRectMake(5, 88, 150, 30)];
	self.menuOption3.layer.cornerRadius = 4;
	self.menuOption3.textColor = [UIColor whiteColor];
	self.menuOption3.backgroundColor = [UIColor clearColor];
	self.menuOption3.text = @"Submit a Report";
	self.menuOption3.userInteractionEnabled = NO;
	self.menuOption3.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
	[self addSubview:self.menuOption3];
		
	self.rotationWhenHidden = CATransform3DMakeRotation(M_PI * 0.25, 0, 0, 1);

	self.alpha = 0;
	self.backgroundColor = [UIColor clearColor];
	self.layer.anchorPoint = CGPointMake(1, 0);

	[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(rotateTuckedAway) userInfo:nil repeats:NO];	

    return self;
	
}

- (void) drawRect:(CGRect)rect {

	CGFloat stroke = 2;
	CGFloat anchorHeight = 24;
	CGFloat cornerRad = 5;
	CGFloat selfwidth = self.frame.size.width;
	CGFloat selfheight = self.frame.size.height;
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetLineJoin(context, kCGLineJoinRound);
	CGContextSetLineWidth(context, 1);
	CGContextSetRGBStrokeColor(context, 0, 0, 0, 0.7); 
	CGContextSetRGBFillColor(context, 0, 0, 0, 0.85);

	CGContextBeginPath(context);
	
	// --	Begin at top right corner of layer, i.e. tip of anchor.
	CGContextMoveToPoint(context,
						 selfwidth		- stroke,
						 0				+ stroke
						 );
	// --	Diagonal line down left side of anchor.
	CGContextAddLineToPoint(context,
							130			- stroke,
							0			+ anchorHeight
							);
	// --	Line to top left corner.
	CGContextAddLineToPoint(context,
							0			+ cornerRad			+ stroke,
							0			+ anchorHeight
							);
	// --	Arc around top left corner.
	CGContextAddArcToPoint(context,
						   0			+ stroke,
						   0			+ anchorHeight,
						   0			+ stroke,
						   0			+ anchorHeight		+ cornerRad,
						   cornerRad
						   );
	// --	Line to bottom left corner.
	CGContextAddLineToPoint(context,
							0			+ stroke,
							selfheight	- cornerRad			- stroke
							);
	// --	Arc around bottom left corner.
	CGContextAddArcToPoint(context,
						   0			+ stroke,
						   selfheight	- stroke,
						   0			+ cornerRad			+ stroke,
						   selfheight	- stroke,
						   cornerRad
						   );
	// --	Line to bottom right corner.
	CGContextAddLineToPoint(context,
							selfwidth	- cornerRad			- stroke,
							selfheight	- stroke
							);
	// --	Arc around bottom right corner.
	CGContextAddArcToPoint(context,
						   selfwidth	- stroke,
						   selfheight	- stroke,
						   selfwidth	- stroke,
						   selfheight	- cornerRad			- stroke,
						   cornerRad
						   );
	// --	Line to top right corner.
	CGContextAddLineToPoint(context,
							selfwidth	- stroke,
							stroke
							);
	
	CGContextClosePath(context);
	CGContextDrawPath(context, kCGPathFillStroke);
}


- (void) show {
	
	[self.superview bringSubviewToFront:self];
	[self rotateForUse];
	[UIView animateWithDuration:0.1 delay:0.1 options:UIViewAnimationOptionCurveEaseIn animations:^{
		self.alpha = 1;
	}
					 completion:^(BOOL finished){
					 }
	 ];
}

- (void) hide {
	
	[self rotateTuckedAway];
	[UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
		self.alpha = 0;
	}
					 completion:^(BOOL finished){
//						 [self.superview sendSubviewToBack:self];
					 }
	 ];
	
}

- (void) rotateForUse {
	CAKeyframeAnimation *theAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
	
	NSArray *scaleValues = [NSArray arrayWithObjects:
							[NSValue valueWithCATransform3D:self.rotationWhenHidden],
							[NSValue valueWithCATransform3D:CATransform3DIdentity],
							nil];
	[theAnimation setValues:scaleValues];
	
	NSArray *timingFunctions = [NSArray arrayWithObjects:
								[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
								nil];
	[theAnimation setTimingFunctions:timingFunctions];
	[theAnimation setRemovedOnCompletion:NO];
	theAnimation.fillMode = kCAFillModeForwards;
	theAnimation.duration = 0.25;
	
	[self.layer addAnimation:theAnimation forKey:@"scale"];
	
}

- (void) rotateTuckedAway {	
	CAKeyframeAnimation *theAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
	
	NSArray *scaleValues = [NSArray arrayWithObjects:
							[NSValue valueWithCATransform3D:CATransform3DIdentity],
							[NSValue valueWithCATransform3D:self.rotationWhenHidden],
							nil];
	[theAnimation setValues:scaleValues];
	
	NSArray *timingFunctions = [NSArray arrayWithObjects:
								[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
								nil];
	[theAnimation setTimingFunctions:timingFunctions];
	[theAnimation setRemovedOnCompletion:NO];
	theAnimation.fillMode = kCAFillModeForwards;
	theAnimation.duration = 0.25;
	
	[self.layer addAnimation:theAnimation forKey:@"scale"];
}

- (void)dealloc {
    [super dealloc];
}

- (BOOL) point:(CGPoint)thePoint isInFrame:(CGRect)theFrame {

	if (thePoint.x >= theFrame.origin.x && thePoint.x <= (theFrame.origin.x + theFrame.size.width) && thePoint.y >= theFrame.origin.y && thePoint.y <= (theFrame.origin.y + theFrame.size.height)) {
		return TRUE;
	}
	return FALSE;
}

- (void) removeSelectionBackground {

	self.selectionBackground.backgroundColor = [UIColor clearColor];
}

@end