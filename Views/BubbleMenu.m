//
//  BubbleMenu.m
//  Herdict
//
//  Created by Christian Brink on 3/19/11.
//  Copyright 2011 Herdict. All rights reserved.
//

//	To set up a BubbleMenu object, create an array of strings and pass in this array in the init call.
//	On the menu's parent object, use touchesBegan to catch touches on the menu's subviews.  If a subview has a tag,
//	it's one of the menu options.  Proceed according to its tag...
//	When catching the touch, it looks better if selectionBackground is used.
//	Use drawRect to make any real changes to the tail, other than its height.


#import "BubbleMenu.h"

@implementation BubbleMenu

@synthesize menuOptions;

@synthesize selectionBackgroundBasicFrame;
@synthesize selectionBackground;

@synthesize rotationWhenHidden;

@synthesize stroke;
@synthesize tailHeight;
@synthesize tailWidth;
@synthesize tailBaseOffset;
@synthesize tailTipOffset;
@synthesize cornerRad;
@synthesize selfwidth;
@synthesize selfheight;


- (id)initWithFrame:(CGRect)frame menuOptionsArray:(NSMutableArray *)theOptionsArray tailHeight:(CGFloat)theTailHeight anchorPoint:(CGPoint)theAnchorPoint {

    self = [super initWithFrame:frame];
	if (self) {
		
		// --	Fix height, which was prob passed in as 0 in the init call.
		CGFloat totalHeight = theTailHeight + 6 + 12 + ([theOptionsArray count] * 30);
		[self setFrame:CGRectMake(self.frame.origin.x,
								  self.frame.origin.y,
								  self.frame.size.width,
								  totalHeight)];
		
		self.alpha = 0;
		self.backgroundColor = [UIColor clearColor];
		self.layer.anchorPoint = theAnchorPoint;
		self.userInteractionEnabled = YES;
		
		rotationWhenHidden = CATransform3DMakeRotation(-(M_PI * 0.25), 0, 0, 1);

		tailHeight = theTailHeight;
		tailWidth = 25;
		tailBaseOffset = 105;
		tailTipOffset = 130;
		
		stroke = 2;
		cornerRad = 5;
		selfwidth = self.frame.size.width;
		selfheight = self.frame.size.height;	

		// --	Basic setup for self.selectionBackground.  The parent object will manipulate its backgroundColor and origin.y. 
		self.selectionBackground = [[UIView alloc] initWithFrame:CGRectZero];
		self.selectionBackground.backgroundColor = [UIColor clearColor];
		self.selectionBackground.alpha = 0.8;
		self.selectionBackground.layer.cornerRadius = 4;
		self.selectionBackground.userInteractionEnabled = NO;
		[self addSubview:self.selectionBackground];		
		
		for (UIView *aView in self.subviews) {
			aView.tag = -1;
		}
		self.tag = -1;
		
		// --	Set up the Menu Options.
		for (NSString *optionText in theOptionsArray) {
			UITextView *menuOption = [[UITextView alloc] initWithFrame:CGRectMake(5,
																				  self.tailHeight + 6 + (30 * [theOptionsArray indexOfObject:optionText]),
																				  self.frame.size.width - 12,
																				  30)];
			menuOption.text = [NSString stringWithString:optionText];
			menuOption.tag = [theOptionsArray indexOfObject:optionText];
			NSLog(@"adding option to menu, tag: %i", menuOption.tag);
			menuOption.layer.cornerRadius = 4;
			menuOption.textColor = [UIColor whiteColor];
			menuOption.backgroundColor = [UIColor clearColor];
			menuOption.editable = NO;
			menuOption.userInteractionEnabled = NO;
			menuOption.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
			[self addSubview:menuOption];
		}
		
		[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(rotateTuckedAway) userInfo:nil repeats:NO];
	}

    return self;
	
}

- (void) drawRect:(CGRect)rect {
	
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


- (void) showBubbleMenu {
	
	[self.superview bringSubviewToFront:self];
	[self setCenter:CGPointMake(self.center.x, self.center.y + 200)];
	[self rotateForUse];
	[UIView animateWithDuration:0.1 delay:0.1 options:UIViewAnimationOptionCurveEaseIn animations:^{
		self.alpha = 1;
	}
					 completion:^(BOOL finished){
					 }
	 ];
}

- (void) hideBubbleMenu {
	
	[self rotateTuckedAway];
	[UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
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

- (void) showSelectionBackgroundForOption:(int)optionNumber {
	UITextView *selectedOption = [self viewWithTag:optionNumber];
	self.selectionBackground.backgroundColor = UIColorFromRGB(0x5AabF7);
	[self.selectionBackground setFrame:CGRectMake(selectedOption.frame.origin.x,
												   selectedOption.frame.origin.y + 3,
												   selectedOption.frame.size.width,
												   selectedOption.frame.size.height)]; 
}

- (void) removeSelectionBackground {
	self.selectionBackground.backgroundColor = [UIColor clearColor];
}

	
@end