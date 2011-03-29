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

@synthesize theMessage;
@synthesize menuOptions;
@synthesize selectionBackground;

@synthesize frameForShowMenu;
@synthesize rotationWhenHidden;
@synthesize stroke;
@synthesize tailHeight;
@synthesize tailWidth;
@synthesize tailOffset;
@synthesize cornerRad;
@synthesize selfwidth;
@synthesize selfheight;


- (id)initWithMessageHeight:(CGFloat)theMessageHeight withFrame:(CGRect)theFrame menuOptionsArray:(NSMutableArray *)theOptionsArray tailHeight:(CGFloat)theTailHeight anchorPoint:(CGPoint)theAnchorPoint {

    self = [super initWithFrame:theFrame];
	if (self) {
		
		CGFloat yPaddingForMessage = 0;
		if (theMessageHeight > 0) {
			yPaddingForMessage = yPaddingForBubbleMenuBody;
		}
		
		[self setFrame:CGRectMake(self.frame.origin.x,
								  self.frame.origin.y,
								  self.frame.size.width,
								  theTailHeight + (yPaddingForBubbleMenuBody * 4) + theMessageHeight + yPaddingForMessage + ([theOptionsArray count] * heightForBubbleMenuOption))];
		
		self.alpha = 0;
		self.backgroundColor = [UIColor clearColor];
		self.layer.anchorPoint = theAnchorPoint;
		self.userInteractionEnabled = YES;
		
		self.layer.masksToBounds = NO;
		self.layer.shadowOffset = CGSizeMake(0, 0);
		self.layer.shadowRadius = 5;
		self.layer.shadowOpacity = 0.8;
		
		self.frameForShowMenu = self.frame;

		self.selfwidth = self.frame.size.width;
		self.selfheight = self.frame.size.height;

		self.tailHeight = theTailHeight;
		self.tailWidth = selfwidth * 0.175;
		self.tailOffset = selfwidth * 0.725;
				
		self.cornerRad = 6.0;
		self.rotationWhenHidden = CATransform3DMakeRotation(-(M_PI * 0.25), 0, 0, 1);

		CGFloat xPaddingLeft = selfwidth * 0.04;
		CGFloat xPaddingRight = selfwidth * 0.08;
		
		// --	Basic setup for self.selectionBackground.  The parent object will manipulate its backgroundColor and origin.y. 
		self.selectionBackground = [[UIView alloc] initWithFrame:CGRectZero];
		self.selectionBackground.tag = 0;
		self.selectionBackground.backgroundColor = [UIColor clearColor];
		self.selectionBackground.alpha = 0.8;
		self.selectionBackground.layer.cornerRadius = 4;
		self.selectionBackground.userInteractionEnabled = NO;
		[self addSubview:self.selectionBackground];
		
		// --	Set up the Message.
		self.theMessage = [[UITextView alloc] initWithFrame:CGRectMake(xPaddingLeft,
																	   tailHeight + yPaddingForMessage,
																	   selfwidth - xPaddingRight,
																	   theMessageHeight)];
		self.theMessage.textColor = [UIColor whiteColor];
		self.theMessage.backgroundColor = [UIColor clearColor];
		self.theMessage.editable = NO;
		self.theMessage.tag = 0;
		self.theMessage.userInteractionEnabled = NO;
		self.theMessage.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
		[self addSubview:self.theMessage];
		
		// --	Make sure there's no tag confusion.
		self.tag = 0;
		for (UIView *aView in [self subviews]) {
			aView.tag = 0;
		}
		
		// --	Set up each Menu Option.
		for (NSString *optionText in theOptionsArray) {
			UITextView *menuOption = [[UITextView alloc] initWithFrame:CGRectMake(xPaddingLeft,
																				  tailHeight + yPaddingForBubbleMenuBody + theMessageHeight + yPaddingForMessage + (heightForBubbleMenuOption * [theOptionsArray indexOfObject:optionText]),
																				  selfwidth - xPaddingRight,
																				  heightForBubbleMenuOption)];
			menuOption.contentMode = UIViewContentModeCenter;
			menuOption.text = [NSString stringWithString:optionText];
			menuOption.tag = [theOptionsArray indexOfObject:optionText] + 1;
			menuOption.layer.cornerRadius = 4;
			menuOption.textColor = [UIColor whiteColor];
			menuOption.backgroundColor = [UIColor clearColor];
			menuOption.editable = NO;
			menuOption.userInteractionEnabled = NO;
			menuOption.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
			[self addSubview:menuOption];
		}
		
		[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(hideBubbleMenu) userInfo:nil repeats:NO];
	}

    return self;
	
}

- (void) drawRect:(CGRect)rect {
	
	// trig vars
	CGFloat l				= 5.0;
	CGFloat diameter		= l * (tailWidth / tailHeight);
	CGFloat m				= (tailWidth * (diameter / 2.0)) / sqrt(pow(tailHeight, 2.0) + pow(tailWidth, 2.0));
	CGFloat q				= m * (tailHeight / tailWidth);
	CGFloat n				= (diameter / 2.0) - q;
	
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetLineJoin(context, kCGLineJoinRound);
	CGContextSetLineWidth(context, 0);
	CGContextSetRGBStrokeColor(context, 0, 0, 0, 0.4); 
	CGContextSetRGBFillColor(context, 0, 0, 0, 0.7);

	CGContextBeginPath(context);
	
	// --	Begin at top right corner of layer, i.e. tip of tail.
	CGContextMoveToPoint(context,
						 0,
						 l
						 );
	// --	Line to bottom left corner.
	CGContextAddLineToPoint(context,
							stroke,
							selfheight - cornerRad
							);
	// --	Arc around bottom left corner.
	CGContextAddArcToPoint(context,
						   stroke,
						   selfheight,
						   cornerRad,
						   selfheight,
						   cornerRad
						   );
	// --	Line to bottom right corner.
	CGContextAddLineToPoint(context,
							selfwidth - cornerRad,
							selfheight
							);
	// --	Arc around bottom right corner.
	CGContextAddArcToPoint(context,
						   selfwidth,
						   selfheight,
						   selfwidth,
						   selfheight - cornerRad,
						   cornerRad
						   );
	// --	Line to top right corner.
	CGContextAddLineToPoint(context,
							selfwidth,
							tailHeight + cornerRad
							);
	// --	Arc around top right corner.
	CGContextAddArcToPoint(context,
						   selfwidth,
						   tailHeight,
						   selfwidth - cornerRad,
						   tailHeight,
						   cornerRad);
	// --	Add line to base of tail.
	CGContextAddLineToPoint(context,
							tailWidth,
							tailHeight
							);
	// --	Add line to near tip of tail.
	CGContextAddLineToPoint(context,
							diameter - n,
							l - m
							);
	// --	Arc around tip.
	CGContextAddArc(context,
					(diameter / 2.0),
					l,
					(diameter / 2.0),
					-asin(m / (diameter / 2.0)),
					M_PI,
					1
					);
	
	CGContextClosePath(context);

	CGContextDrawPath(context, kCGPathFillStroke);
}


- (void) showBubbleMenuWithAnimation:(NSNumber *)withAnimation {
	
	[self setFrame:self.frameForShowMenu];
	[self.superview bringSubviewToFront:self];
	
	BOOL animated = [withAnimation boolValue];
	
	if (animated) {
		[self rotateForUse];
		[UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseIn
						 animations:^{
							 self.alpha = 1;
						 }
						 completion:^(BOOL finished){
						 }
		 ];
	} else {
		self.layer.transform = CATransform3DIdentity;
		self.alpha = 1;
	}
}

- (void) hideBubbleMenu {
	
	[self rotateTuckedAway];
	[UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveEaseIn
					 animations:^{
						 self.alpha = 0;
					 }
					 completion:^(BOOL finished){
						 [self setFrame:CGRectZero];
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

- (void) hideSelectionBackground {
	self.selectionBackground.backgroundColor = [UIColor clearColor];
}

	
@end