//
//  FormDetailMenu.m
//  Herdict
//
//  Created by Christian Brink on 3/29/11.
//  Copyright 2011 Herdict. All rights reserved.
//

#import "FormDetailMenu.h"

@implementation FormDetailMenu

@synthesize theMessage;
@synthesize menuOptions;
@synthesize selectionBackground;

@synthesize stroke;
@synthesize tailHeight;
@synthesize tailWidth;
@synthesize tailxOffsetForBase;
@synthesize tailxOffsetForTip;
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
		
		self.selfwidth = self.frame.size.width;
		self.selfheight = self.frame.size.height;
		
		self.tailHeight = theTailHeight;
		self.tailWidth = selfwidth * 0.4;
		self.tailxOffsetForBase = selfwidth * 0.30;
		self.tailxOffsetForTip = selfwidth * 0.5;
		
		self.cornerRad = 6.0;
		
		CGFloat xPaddingLeft = selfwidth * 0.065;
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
		
	}
	
    return self;
	
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


- (void) drawRect:(CGRect)rect {
	
//	// trig vars
//	CGFloat l				= 5.0;
//	CGFloat diameter		= l * (tailWidth / tailHeight);
//	CGFloat m				= (tailWidth * (diameter / 2.0)) / sqrt(pow(tailHeight, 2.0) + pow(tailWidth, 2.0));
//	CGFloat q				= m * (tailHeight / tailWidth);
//	CGFloat n				= (diameter / 2.0) - q;
		
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetLineJoin(context, kCGLineJoinRound);
	CGContextSetLineWidth(context, 0);
	CGContextSetRGBStrokeColor(context, 0, 0, 0, 0.4); 
	CGContextSetRGBFillColor(context, 0, 0, 0, 0.7);
	
	CGContextBeginPath(context);
	
	// --	Begin at tail left side of tip.
	CGContextMoveToPoint(context,
						 selfwidth * 0.5 - 1,
						 0
						 );
	// --	Line to tail left base.
	CGContextAddLineToPoint(context,
							selfwidth - tailxOffsetForBase - tailWidth,
							tailHeight
							);
	// --	Line to top left corner.
	CGContextAddLineToPoint(context,
							cornerRad,
							tailHeight
							);
	// --	Arc around top left corner.
	CGContextAddArcToPoint(context,
						   0,
						   tailHeight,
						   0,
						   tailHeight + cornerRad,
						   cornerRad
						   );
	// --	Line to bottom left corner.
	CGContextAddLineToPoint(context,
							0,
							selfheight - cornerRad
							);
	// --	Arc around bottom left corner.
	CGContextAddArcToPoint(context,
						   0,
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
	// --	Add line to tail base.
	CGContextAddLineToPoint(context,
							selfwidth - tailxOffsetForBase,
							tailHeight
							);
	// --	Add line to tail right of tip.
	CGContextAddLineToPoint(context,
							selfwidth * 0.5 + 1,
							0
							);
	
	CGContextClosePath(context);
	
	CGContextDrawPath(context, kCGPathFillStroke);
}


- (void)dealloc {
    [super dealloc];
}



@end