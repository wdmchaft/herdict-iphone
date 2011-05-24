//
//  FormMenuCategory.m
//  Herdict
//
//  Created by Christian Brink on 3/29/11.
//  Copyright 2011 Herdict. All rights reserved.
//

#import "FormMenuCategory.h"

@implementation FormMenuCategory

@synthesize selectionBackground;

@synthesize theMessage;
@synthesize menuOptions;

@synthesize selfOriginX;
@synthesize selfOriginY;
@synthesize selfWidth;
@synthesize selfHeight;

@synthesize xPaddingLeft;
@synthesize xPaddingRight;
@synthesize yPaddingForMessage;

@synthesize messageHeight;
@synthesize tailHeight;
@synthesize tailWidth;
@synthesize tailxOffsetForBase;
@synthesize tailxOffsetForTip;

@synthesize stroke;
@synthesize cornerRad;


- (id)initWithMessageHeight:(CGFloat)theMessageHeight withFrame:(CGRect)theFrame tailHeight:(CGFloat)theTailHeight {
	
    self = [super initWithFrame:theFrame];
	if (self) {

		self.selfOriginX = theFrame.origin.x;
		self.selfOriginY = theFrame.origin.y;
		self.selfWidth = theFrame.size.width;

		self.yPaddingForMessage = 0.0;
		if (theMessageHeight > 0.0) {
			self.yPaddingForMessage = bubbleMenu_body__yPadding;
		}
		
		self.messageHeight = theMessageHeight;
		self.tailHeight = theTailHeight;
		self.tailWidth = self.selfWidth * 0.4;
		self.tailxOffsetForBase = self.selfWidth * 0.30;
		self.tailxOffsetForTip = self.selfWidth * 0.5;
		
		self.selfHeight = self.tailHeight + (bubbleMenu_body__yPadding * 4.0) + self.messageHeight + self.yPaddingForMessage;

		self.xPaddingLeft = self.selfWidth * 0.065;
		self.xPaddingRight = self.selfWidth * 0.08;

		[self setFrame:CGRectMake(self.selfOriginX,
								  self.selfOriginY,
								  self.selfWidth,
								  self.selfHeight)];
		
		self.backgroundColor = [UIColor clearColor];
		self.userInteractionEnabled = YES;
				
		self.cornerRad = 6.0;
				
		// --	Basic setup for self.selectionBackground.  The parent object will manipulate its backgroundColor and origin.y. 
		self.selectionBackground = [[UIView alloc] initWithFrame:CGRectZero];
		self.selectionBackground.tag = 0;
		self.selectionBackground.backgroundColor = [UIColor clearColor];
		self.selectionBackground.alpha = 0.8;
		self.selectionBackground.layer.cornerRadius = 4;
		self.selectionBackground.userInteractionEnabled = NO;
		[self addSubview:self.selectionBackground];
		
		// --	Set up the Message.
		self.theMessage = [[UITextView alloc] initWithFrame:CGRectMake(self.xPaddingLeft,
																	   self.tailHeight + self.yPaddingForMessage,
																	   self.selfWidth - self.xPaddingRight,
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
	}
	
    return self;
}

- (void)dealloc {
	[theMessage release];
	[selectionBackground release];
    [super dealloc];
}

- (void) setUpMenuOptionsArray:(NSMutableArray *)theOptionsArray optionHeight:(CGFloat)theOptionHeight optionFontSize:(CGFloat)theOptionFontSize {
//	NSLog(@"[formMenuCategory setUpMenuOptionsArray], self.frame.size.height: %f", self.frame.size.height);

	int theCount = 0;
	if ([theOptionsArray count] - 1 > 0) {
		theCount = [theOptionsArray count] - 1;
	}
	self.selfHeight = self.tailHeight + (bubbleMenu_body__yPadding * 4) + self.messageHeight + self.yPaddingForMessage + (theOptionHeight * theCount);	
	
	[self setFrame:CGRectMake(self.selfOriginX,
							  self.selfOriginY,
							  self.selfWidth,
							  self.selfHeight)];
	
	// --	Scrap existing menu options.
	for (UIView *aView in self.subviews) {
		if (aView.tag > 0) {
			[aView removeFromSuperview];
		}
	}
	
	// --	Set up each Menu Option.
	for (NSString *optionText in theOptionsArray) {
		if ([theOptionsArray indexOfObject:optionText] > 0) {
			UITextView *menuOption = [[[UITextView alloc] initWithFrame:CGRectMake(self.xPaddingLeft,
																				  self.tailHeight + self.messageHeight + self.yPaddingForMessage + (theOptionHeight * (-1 + [theOptionsArray indexOfObject:optionText])),
																				  self.selfWidth - self.xPaddingRight,
																				  theOptionHeight)] autorelease];
			menuOption.contentMode = UIViewContentModeCenter;
			menuOption.text = [NSString stringWithString:optionText];
			menuOption.tag = [theOptionsArray indexOfObject:optionText];
			menuOption.layer.cornerRadius = 4;
			menuOption.textColor = [UIColor whiteColor];
			menuOption.backgroundColor = [UIColor clearColor];
			menuOption.editable = NO;
			menuOption.userInteractionEnabled = NO;
			menuOption.font = [UIFont fontWithName:@"Helvetica-Bold" size:theOptionFontSize];
			[self addSubview:menuOption];
		}
	}
//	NSLog(@"formMenuCategory leaving setUpMenuOptionsArray.  self.frame.size.height: %f", self.frame.size.height);
}

- (void) addShadow {
	
	self.layer.masksToBounds = NO;
	self.layer.shadowColor = [UIColor blackColor].CGColor;
	self.layer.shadowOffset = CGSizeZero;
	self.layer.shadowRadius = 5.0f;
	self.layer.shadowOpacity = 0.8f;
	self.layer.shouldRasterize = YES;
	
	self.layer.shadowPath = [self newPath];
}

- (void) showSelectionBackgroundForOption:(int)optionNumber {
	UITextView *selectedOption = (UITextView *)[self viewWithTag:optionNumber];
	
	self.selectionBackground.backgroundColor = UIColorFromRGB(0x5AabF7);
	[self.selectionBackground setFrame:CGRectMake(selectedOption.frame.origin.x - 6,
												  selectedOption.frame.origin.y + 5,
												  selectedOption.frame.size.width,
												  selectedOption.frame.size.height)]; 
}

- (void) hideSelectionBackground {
	self.selectionBackground.backgroundColor = [UIColor clearColor];
}


- (CGPathRef) newPath {

	//	// trig vars
	//	CGFloat l				= 5.0;
	//	CGFloat diameter		= l * (self.tailWidth / self.tailHeight);
	//	CGFloat m				= (self.tailWidth * (diameter / 2.0)) / sqrt(pow(self.tailHeight, 2.0) + pow(self.tailWidth, 2.0));
	//	CGFloat q				= m * (self.tailHeight / self.tailWidth);
	//	CGFloat n				= (diameter / 2.0) - q;	
	
	CGMutablePathRef thePath = CGPathCreateMutable();
	
	// --	Begin at tail left side of tip.
	CGPathMoveToPoint(thePath, NULL, self.selfWidth * 0.5 - 1.0f, 0.0f);
	// --	Line to tail left base.
	CGPathAddLineToPoint(thePath, NULL, self.selfWidth - self.tailxOffsetForBase - self.tailWidth, self.tailHeight);
	// --	Line to top left corner.
	CGPathAddLineToPoint(thePath, NULL, self.cornerRad, self.tailHeight);
	// --	Arc around top left corner.
	CGPathAddArcToPoint(thePath, NULL, 0.0f, self.tailHeight, 0.0f, self.tailHeight + self.cornerRad, self.cornerRad);
	// --	Line to bottom left corner.
	CGPathAddLineToPoint(thePath, NULL, 0.0f, self.selfHeight - self.cornerRad);
	// --	Arc around bottom left corner.
	CGPathAddArcToPoint(thePath, NULL, 0.0f, self.selfHeight, self.cornerRad, self.selfHeight, self.cornerRad);
	// --	Line to bottom right corner.
	CGPathAddLineToPoint(thePath, NULL, self.selfWidth - self.cornerRad, self.selfHeight);
	// --	Arc around bottom right corner.
	CGPathAddArcToPoint(thePath, NULL, self.selfWidth, self.selfHeight, self.selfWidth, self.selfHeight - self.cornerRad, self.cornerRad);
	// --	Line to top right corner.
	CGPathAddLineToPoint(thePath, NULL, self.selfWidth, self.tailHeight + self.cornerRad);
	// --	Arc around top right corner.
	CGPathAddArcToPoint(thePath, NULL, self.selfWidth, self.tailHeight, self.selfWidth - self.cornerRad, self.tailHeight, self.cornerRad);
	// --	Add line to tail base.
	CGPathAddLineToPoint(thePath, NULL, self.selfWidth - self.tailxOffsetForBase, self.tailHeight);
	// --	Add line to tail right of tip.
	CGPathAddLineToPoint(thePath, NULL, self.selfWidth * 0.5 + 1.0f, 0.0f);
	
	CGPathCloseSubpath(thePath);
	
	return thePath;
}

- (void) drawRect:(CGRect)rect {
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetLineJoin(context, kCGLineJoinRound);
	CGContextSetLineWidth(context, 0);
	CGContextSetRGBStrokeColor(context, 0, 0, 0, 0.4); 
	CGContextSetRGBFillColor(context, 0, 0, 0, 0.7);
	
	CGPathRef thePath = [self newPath];
	CGContextAddPath(context, thePath);
	
	CGContextDrawPath(context, kCGPathFillStroke);
}

@end