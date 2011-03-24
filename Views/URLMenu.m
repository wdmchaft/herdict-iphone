//
//  URLMenu.m
//  Herdict
//
//  Created by Christian Brink on 3/19/11.
//  Copyright 2011 Herdict. All rights reserved.
//

#import "URLMenu.h"
#import <QuartzCore/QuartzCore.h>


@implementation URLMenu

@synthesize menuOption1;
@synthesize menuOption2;
@synthesize menuOption3;

@synthesize selectionBackgroundBasicFrame;
@synthesize selectionBackground;

@synthesize rotationWhenHidden;


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
	self.userInteractionEnabled = YES;
	
	self.selectionBackgroundBasicFrame = CGRectMake(5, 28, 140, 30);
	
	// --	Set up selectionBackground.  We will manipulate its backgroundColor and origin.y (from VC_Home). 
	self.selectionBackground = [[UIView alloc] initWithFrame:self.selectionBackgroundBasicFrame];
	self.selectionBackground.backgroundColor = [UIColor clearColor];
	self.selectionBackground.alpha = 0.8;
	self.selectionBackground.layer.cornerRadius = 4;
	self.selectionBackground.userInteractionEnabled = NO;
	[self addSubview:self.selectionBackground];
	
	self.menuOption1 = [[UITextView alloc] initWithFrame:CGRectMake(5, 28, 140, 30)];
	self.menuOption1.layer.cornerRadius = 4;
	self.menuOption1.textColor = [UIColor whiteColor];
	self.menuOption1.backgroundColor = [UIColor clearColor];
	self.menuOption1.text = @"Test Site";
	self.menuOption1.editable = NO;
	self.menuOption1.userInteractionEnabled = NO;
	self.menuOption1.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
	[self addSubview:self.menuOption1];
	self.menuOption2 = [[UITextView alloc] initWithFrame:CGRectMake(5, 58, 140, 30)];
	self.menuOption2.layer.cornerRadius = 4;
	self.menuOption2.textColor = [UIColor whiteColor];
	self.menuOption2.backgroundColor = [UIColor clearColor];
	self.menuOption2.text = @"Get a Report";
	self.menuOption2.editable = NO;
	self.menuOption2.userInteractionEnabled = NO;
	self.menuOption2.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
	[self addSubview:self.menuOption2];
	self.menuOption3 = [[UITextView alloc] initWithFrame:CGRectMake(5, 88, 140, 30)];
	self.menuOption3.layer.cornerRadius = 4;
	self.menuOption3.textColor = [UIColor whiteColor];
	self.menuOption3.backgroundColor = [UIColor clearColor];
	self.menuOption3.text = @"Submit a Report";
	self.menuOption3.editable = NO;
	self.menuOption3.userInteractionEnabled = NO;
	self.menuOption3.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
	[self addSubview:self.menuOption3];
		
	self.rotationWhenHidden = CATransform3DMakeRotation(-(M_PI * 0.25), 0, 0, 1);

	self.alpha = 0;
	self.backgroundColor = [UIColor clearColor];
	self.layer.anchorPoint = CGPointMake(0, 0);

	[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(rotateTuckedAway) userInfo:nil repeats:NO];	

    return self;
	
}

- (void) drawRect:(CGRect)rect {

	CGFloat stroke = 2;
	CGFloat tailHeight = 22;
	CGFloat tailWidth = 25;
	CGFloat tailBaseOffset = 105;
	CGFloat tailTipOffset = 130;
	CGFloat cornerRad = 5;
	CGFloat selfwidth = self.frame.size.width;
	CGFloat selfheight = self.frame.size.height;
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetLineJoin(context, kCGLineJoinRound);
	CGContextSetLineWidth(context, 1);
	CGContextSetRGBStrokeColor(context, 0, 0, 0, 0.7); 
	CGContextSetRGBFillColor(context, 0, 0, 0, 0.85);

	CGContextBeginPath(context);
	
	// --	Begin at top right corner of layer, i.e. tip of tail.
	CGContextMoveToPoint(context,
						 selfwidth	- tailTipOffset - stroke,
						 0				+ stroke
						 );
	// --	Diagonal line down left side of tail.
	CGContextAddLineToPoint(context,
							selfwidth - tailBaseOffset - tailWidth - stroke,
							0			+ tailHeight		+ stroke
							);
	// --	Line to top left corner.
	CGContextAddLineToPoint(context,
							0			+ cornerRad			+ stroke,
							0			+ tailHeight		+ stroke
							);
	// --	Arc around top left corner.
	CGContextAddArcToPoint(context,
						   0			+ stroke,
						   0			+ tailHeight		+ stroke,
						   0			+ stroke,
						   0			+ tailHeight		+ cornerRad,
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
							tailHeight + cornerRad		+ stroke
							);
	// --	Arc around top right corner.
	CGContextAddArcToPoint(context,
						   selfwidth	- stroke,
						   0			+ tailHeight		+ stroke,
						   selfwidth	- cornerRad			- stroke,
						   0			+ tailHeight		+ stroke,
						   cornerRad);
	// --	Add line to base of tail.
	CGContextAddLineToPoint(context,
							selfwidth	- tailBaseOffset	- stroke,
							0			+ tailHeight		+ stroke
							);
	// --	Add line to tip of tail.
	CGContextAddLineToPoint(context,
							selfwidth - tailTipOffset - stroke,
							0			+ stroke
							);
	
	CGContextClosePath(context);
	CGContextDrawPath(context, kCGPathFillStroke);
}


- (void) show {
	
	[self setCenter:CGPointMake(self.center.x, self.center.y + 200)];
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
	[UIView animateWithDuration:0.05 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
		self.alpha = 0;
	}
					 completion:^(BOOL finished){
						 [self setCenter:CGPointMake(self.center.x, self.center.y - 200)];
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