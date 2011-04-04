//
//  FormMenuComments.m
//  Herdict
//
//  Created by Christian Brink on 3/29/11.
//  Copyright 2011 Herdict. All rights reserved.
//

#import "FormMenuComments.h"

@implementation FormMenuComments

@synthesize theComments;

@synthesize selfwidth;
@synthesize selfheight;

@synthesize xPaddingLeft;
@synthesize xPaddingRight;
@synthesize yPaddingForCutout;

@synthesize tailHeight;
@synthesize tailWidth;
@synthesize tailxOffsetForBase;
@synthesize tailxOffsetForTip;

@synthesize cutoutCornerRad;
@synthesize cutoutOriginX;
@synthesize cutoutOriginY;
@synthesize cutoutSizeWidth;
@synthesize cutoutSizeHeight;	

@synthesize cornerRad;
@synthesize stroke;

- (id)initWithCutoutHeight:(CGFloat)theCutoutHeight withFrame:(CGRect)theFrame tailHeight:(CGFloat)theTailHeight {
	
    self = [super initWithFrame:theFrame];
	if (self) {
		
		self.cutoutSizeHeight = theCutoutHeight;
		self.yPaddingForCutout = 0.0f;
		if (self.cutoutSizeHeight > 0.0f) {
			self.yPaddingForCutout = yPaddingForBubbleMenuBody + 3.0f;
		}
		
		self.selfheight = theTailHeight + (self.yPaddingForCutout * 2.0) + self.cutoutSizeHeight;
		
		[self setFrame:CGRectMake(self.frame.origin.x,
								  self.frame.origin.y,
								  self.frame.size.width,
								  self.selfheight)];
		
		self.backgroundColor = [UIColor clearColor];
		self.userInteractionEnabled = YES;
		
		self.selfwidth = self.frame.size.width;
		self.xPaddingLeft = self.selfwidth * 0.065;
		self.xPaddingRight = self.selfwidth * 0.08;
		
		self.tailHeight = theTailHeight;
		self.tailWidth = self.selfwidth * 0.4;
		self.tailxOffsetForBase = self.selfwidth * 0.30;
		self.tailxOffsetForTip = self.selfwidth * 0.5;
		
		self.cutoutCornerRad = 4.0f;
		self.cutoutOriginX = self.xPaddingLeft;
		self.cutoutOriginY = self.tailHeight + self.yPaddingForCutout;
		self.cutoutSizeWidth = self.selfwidth - self.xPaddingLeft - self.xPaddingRight;
		
		self.cornerRad = 6.0;
		
		// --	Set up theComments.
		self.theComments = [[UITextView alloc] initWithFrame:CGRectMake(self.cutoutOriginX,
																	   self.cutoutOriginY,
																	   self.cutoutSizeWidth,
																	   self.cutoutSizeHeight)];
		self.theComments.textColor = [UIColor whiteColor];
		self.theComments.backgroundColor = [UIColor clearColor];
		self.theComments.editable = YES;
		self.theComments.tag = 0;
		self.theComments.scrollEnabled = NO;
		self.theComments.returnKeyType = UIReturnKeyDone;
		self.theComments.userInteractionEnabled = YES;
		self.theComments.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
		[self addSubview:self.theComments];
		
		// --	Make sure there's no tag confusion.
		self.tag = 0;
		for (UIView *aView in [self subviews]) {
			aView.tag = 0;
		}
				
	}
	
    return self;
	
}

- (void) addShadow {
	
	self.layer.masksToBounds = NO;
	self.layer.shadowColor = [UIColor blackColor].CGColor;
	self.layer.shadowOffset = CGSizeZero;
	self.layer.shadowRadius = 2.0f;
	self.layer.shadowOpacity = 0.8f;
	self.layer.shouldRasterize = YES;
	
	self.layer.shadowPath = [self getPath];
}


- (CGPathRef) getPath {
	
	//	// trig vars
	//	CGFloat l				= 5.0;
	//	CGFloat diameter		= l * (self.tailWidth / self.tailHeight);
	//	CGFloat m				= (self.tailWidth * (diameter / 2.0)) / sqrt(pow(self.tailHeight, 2.0) + pow(self.tailWidth, 2.0));
	//	CGFloat q				= m * (self.tailHeight / self.tailWidth);
	//	CGFloat n				= (diameter / 2.0) - q;	
	
	CGMutablePathRef thePath = CGPathCreateMutable();
	
	// --	Exterior subpath.  Begin at tail left side of tip, proceed clockwise.
	CGPathMoveToPoint(thePath, NULL, self.selfwidth * 0.5 - 1.0f, 0.0f);
	CGPathAddLineToPoint(thePath, NULL, self.selfwidth - self.tailxOffsetForBase - self.tailWidth, self.tailHeight);
	CGPathAddLineToPoint(thePath, NULL, self.cornerRad, self.tailHeight);
	CGPathAddArcToPoint(thePath, NULL, 0.0f, self.tailHeight, 0.0f, self.tailHeight + self.cornerRad, self.cornerRad);
	CGPathAddLineToPoint(thePath, NULL, 0.0f, self.selfheight - self.cornerRad);
	CGPathAddArcToPoint(thePath, NULL, 0.0f, self.selfheight, self.cornerRad, self.selfheight, self.cornerRad);
	CGPathAddLineToPoint(thePath, NULL, self.selfwidth - self.cornerRad, self.selfheight);
	CGPathAddArcToPoint(thePath, NULL, self.selfwidth, self.selfheight, self.selfwidth, self.selfheight - self.cornerRad, self.cornerRad);
	CGPathAddLineToPoint(thePath, NULL, self.selfwidth, self.tailHeight + self.cornerRad);
	CGPathAddArcToPoint(thePath, NULL, self.selfwidth, self.tailHeight, self.selfwidth - self.cornerRad, self.tailHeight, self.cornerRad);
	CGPathAddLineToPoint(thePath, NULL, self.selfwidth - self.tailxOffsetForBase, self.tailHeight);
	CGPathAddLineToPoint(thePath, NULL, self.selfwidth * 0.5 + 1.0f, 0.0f);
	CGPathCloseSubpath(thePath);
	
	// --	Cutout subpath.  Begin below cutout's top left corner, proceed counterclockwise.
	CGPathMoveToPoint(thePath, NULL, self.cutoutOriginX, self.cutoutOriginY + self.cutoutCornerRad);
	CGPathAddLineToPoint(thePath, NULL, self.cutoutOriginX, self.cutoutOriginY + self.cutoutSizeHeight - self.cutoutCornerRad);
	CGPathAddArcToPoint(thePath, NULL, self.cutoutOriginX, self.cutoutOriginY + self.cutoutSizeHeight, self.cutoutOriginX + self.cutoutCornerRad, self.cutoutOriginY + self.cutoutSizeHeight, self.cutoutCornerRad);
	CGPathAddLineToPoint(thePath, NULL, self.cutoutOriginX + self.cutoutSizeWidth - self.cutoutCornerRad, self.cutoutOriginY + self.cutoutSizeHeight);
	CGPathAddArcToPoint(thePath, NULL, self.cutoutOriginX + self.cutoutSizeWidth, self.cutoutOriginY + self.cutoutSizeHeight, self.cutoutOriginX + self.cutoutSizeWidth, self.cutoutOriginY + self.cutoutSizeHeight - self.cutoutCornerRad, self.cutoutCornerRad);
	CGPathAddLineToPoint(thePath, NULL, self.cutoutOriginX + self.cutoutSizeWidth, self.cutoutOriginY + self.cutoutCornerRad);	
	CGPathAddArcToPoint(thePath, NULL, self.cutoutOriginX + self.cutoutSizeWidth, self.cutoutOriginY, self.cutoutOriginX + self.cutoutSizeWidth - self.cutoutCornerRad, self.cutoutOriginY, self.cutoutCornerRad);
	CGPathAddLineToPoint(thePath, NULL, self.cutoutOriginX + self.cutoutCornerRad, self.cutoutOriginY);
	CGPathAddArcToPoint(thePath, NULL, self.cutoutOriginX, self.cutoutOriginY, self.cutoutOriginX, self.cutoutOriginY + self.cutoutCornerRad, self.cutoutCornerRad);	
	CGPathCloseSubpath(thePath);
	
	return thePath;
}

- (void) drawRect:(CGRect)rect {
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetLineJoin(context, kCGLineJoinRound);
	CGContextSetLineWidth(context, 0);
	CGContextSetRGBStrokeColor(context, 1, 1, 1, 0.4); 
	CGContextSetRGBFillColor(context, 0, 0, 0, 0.4);
	
	CGPathRef thePath = [self getPath];
	CGContextAddPath(context, thePath);
	
	CGContextDrawPath(context, kCGPathFillStroke);
	
	//	// --	Exterior subpath.  Begin at tail left side of tip, proceed clockwise.
	//	CGContextMoveToPoint(context, self.selfwidth * 0.5 - 1.0f, 0.0f);
	//	CGContextAddLineToPoint(context, self.selfwidth - self.tailxOffsetForBase - self.tailWidth, self.tailHeight);
	//	CGContextAddLineToPoint(context, self.cornerRad, self.tailHeight);
	//	CGContextAddArcToPoint(context, 0.0f, self.tailHeight, 0.0f, self.tailHeight + self.cornerRad, self.cornerRad);
	//	CGContextAddLineToPoint(context, 0.0f, self.selfheight - self.cornerRad);
	//	CGContextAddArcToPoint(context, 0.0f, self.selfheight, self.cornerRad, self.selfheight, self.cornerRad);
	//	CGContextAddLineToPoint(context, self.selfwidth - self.cornerRad, self.selfheight);
	//	CGContextAddArcToPoint(context, self.selfwidth, self.selfheight, self.selfwidth, self.selfheight - self.cornerRad, self.cornerRad);
	//	CGContextAddLineToPoint(context, self.selfwidth, self.tailHeight + self.cornerRad);
	//	CGContextAddArcToPoint(context, self.selfwidth, self.tailHeight, self.selfwidth - self.cornerRad, self.tailHeight, self.cornerRad);
	//	CGContextAddLineToPoint(context, self.selfwidth - self.tailxOffsetForBase, self.tailHeight);
	//	CGContextAddLineToPoint(context, self.selfwidth * 0.5 + 1.0f, 0.0f);
	//	CGContextClosePath(context);
	//	
	//	// --	Cutout subpath.  Begin below cutout's top left corner, proceed counterclockwise.
	//	CGContextMoveToPoint(context, self.cutoutOriginX, self.cutoutOriginY + self.cutoutCornerRad);
	//	CGContextAddLineToPoint(context, self.cutoutOriginX, self.cutoutOriginY + self.cutoutSizeHeight - self.cutoutCornerRad);
	//	CGContextAddArcToPoint(context, self.cutoutOriginX, self.cutoutOriginY + self.cutoutSizeHeight, self.cutoutOriginX + self.cutoutCornerRad, self.cutoutOriginY + self.cutoutSizeHeight, self.cutoutCornerRad);
	//	CGContextAddLineToPoint(context, self.cutoutOriginX + self.cutoutSizeWidth - self.cutoutCornerRad, self.cutoutOriginY + self.cutoutSizeHeight);
	//	CGContextAddArcToPoint(context, self.cutoutOriginX + self.cutoutSizeWidth, self.cutoutOriginY + self.cutoutSizeHeight, self.cutoutOriginX + self.cutoutSizeWidth, self.cutoutOriginY + self.cutoutSizeHeight - self.cutoutCornerRad, self.cutoutCornerRad);
	//	CGContextAddLineToPoint(context, self.cutoutOriginX + self.cutoutSizeWidth, self.cutoutOriginY + self.cutoutCornerRad);	
	//	CGContextAddArcToPoint(context, self.cutoutOriginX + self.cutoutSizeWidth, self.cutoutOriginY, self.cutoutOriginX + self.cutoutSizeWidth - self.cutoutCornerRad, self.cutoutOriginY, self.cutoutCornerRad);
	//	CGContextAddLineToPoint(context, self.cutoutOriginX + self.cutoutCornerRad, self.cutoutOriginY);
	//	CGContextAddArcToPoint(context, self.cutoutOriginX, self.cutoutOriginY, self.cutoutOriginX, self.cutoutOriginY + self.cutoutCornerRad, self.cutoutCornerRad);	
	//	CGContextClosePath(context);
	
}


- (void)dealloc {
    [super dealloc];
}



@end