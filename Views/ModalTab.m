//
//  ModalTab.m
//  Herdict
//
//  Created by Christian Brink on 4/16/11.
//  Copyright 2011 Herdict. All rights reserved.
//

#import "ModalTab.h"


@implementation ModalTab

@synthesize delegate;
@synthesize tabLabel;
@synthesize tabLabel__xOrigin;
@synthesize yOrigin__default;
@synthesize yOrigin__current;
@synthesize componentRed;
@synthesize componentGreen;
@synthesize componentBlue;
@synthesize componentAlpha;

- (id) initAsModalTabNumber:(CGFloat)tabNumber defaultYOrigin:(CGFloat)yOriginDefault withTabLabelText:(NSString *)tabLabelText {

	self = [super initWithFrame:CGRectMake(0, vcCheckSite__height - modalTab__tabLabel__heightDefault, 320, modalTab__heightTotal)];
	if (self) {
		
		CGFloat gapWidth = (320 - (modalTab__count * modalTab__tabLabel__width)) / (modalTab__count + 1);
		//NSLog(@"gapWidth: %f", gapWidth);
		self.tabLabel__xOrigin = (gapWidth * (tabNumber + 1)) + (modalTab__tabLabel__width * (tabNumber));		
		self.yOrigin__default = yOriginDefault;
		self.yOrigin__current = yOriginDefault;
		
		self.backgroundColor = [UIColor clearColor];
		self.userInteractionEnabled = YES;
		
		self.layer.masksToBounds = NO;
		self.layer.shadowOffset = CGSizeMake(0, 0);
		self.layer.shadowRadius = 5;
		self.layer.shadowOpacity = 0.8;	
		self.layer.shouldRasterize = YES;
		self.layer.shadowPath = [self newPath];
		
		self.tabLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.tabLabel__xOrigin,
																  0,
																  modalTab__tabLabel__width,
																  modalTab__tabLabel__heightDefault)];
		self.tabLabel.text = tabLabelText;
		self.tabLabel.backgroundColor = [UIColor clearColor];
		self.tabLabel.textAlignment = UITextAlignmentCenter;
		self.tabLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
		self.tabLabel.textColor = [UIColor colorWithRed:modalTab__text__colorRed green:modalTab__text__colorGreen blue:modalTab__text__colorBlue alpha:1];
		self.tabLabel.userInteractionEnabled = NO;
		[self addSubview:self.tabLabel];
    }
    return self;
}

- (void)dealloc {
	[tabLabel release];
    [super dealloc];
}


- (void) setColorComponentsWithRed:(CGFloat)theRed withGreen:(CGFloat)theGreen withBlue:(CGFloat)theBlue withAlpha:(CGFloat)theAlpha {
	self.componentRed = theRed;
	self.componentGreen = theGreen;
	self.componentBlue = theBlue;
	self.componentAlpha = theAlpha;
}

- (void) drawRect:(CGRect)rect {
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextSetLineJoin(context, kCGLineJoinRound);
	CGContextSetLineWidth(context, 2);
	
	CGContextSetRGBStrokeColor(context, self.componentRed, self.componentGreen, self.componentBlue, 0.4);
	CGContextSetRGBFillColor(context, self.componentRed, self.componentGreen, self.componentBlue, self.componentAlpha);
	
	CGContextAddPath(context, [self newPath]);
	
	CGContextDrawPath(context, kCGPathFillStroke);		
}

- (CGPathRef) newPath {
	
	CGFloat offsetForStroke = 1;
	CGFloat cornerRad = 4;
	CGFloat selfWidth = self.frame.size.width;
	CGFloat selfHeight = self.frame.size.height;
	
	CGMutablePathRef thePath = CGPathCreateMutable();
	
	// --	Begin at right edge to the right of hideTab, proceed counterclockwise.
	CGPathMoveToPoint(thePath, NULL, selfWidth + 2, modalTab__tabLabel__heightDefault);
	CGPathAddLineToPoint(thePath, NULL, self.tabLabel__xOrigin + modalTab__tabLabel__width, modalTab__tabLabel__heightDefault);
	CGPathAddLineToPoint(thePath, NULL, self.tabLabel__xOrigin + modalTab__tabLabel__width, cornerRad);
	CGPathAddArcToPoint(thePath, NULL, self.tabLabel__xOrigin + modalTab__tabLabel__width, 0 + offsetForStroke, self.tabLabel__xOrigin + modalTab__tabLabel__width - cornerRad, 0 + offsetForStroke, cornerRad);
	CGPathAddLineToPoint(thePath, NULL, self.tabLabel__xOrigin + cornerRad, 0 + offsetForStroke);
	CGPathAddArcToPoint(thePath, NULL, self.tabLabel__xOrigin, 0 + offsetForStroke, self.tabLabel__xOrigin, cornerRad, cornerRad);
	CGPathAddLineToPoint(thePath, NULL, self.tabLabel__xOrigin, modalTab__tabLabel__heightDefault);
	CGPathAddLineToPoint(thePath, NULL, 0 - 2, modalTab__tabLabel__heightDefault);
	CGPathAddLineToPoint(thePath, NULL, 0 - offsetForStroke, selfHeight + 2);
	CGPathAddLineToPoint(thePath, NULL, selfWidth + offsetForStroke, selfHeight + 2);
	CGPathAddLineToPoint(thePath, NULL, selfWidth + 2, modalTab__tabLabel__heightDefault);
	
	return thePath;
}

- (void) configureDefault {

	self.yOrigin__current = self.yOrigin__default;
	
	[UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseOut
					 animations:^{
						 [self setFrame:CGRectMake(0, self.yOrigin__current, 320, modalTab__heightTotal)];
					 }
					 completion:^(BOOL finished){
					 }
	 ];
}

- (void) positionTabInViewWithYOrigin:(CGFloat)yOriginNew {
	NSLog(@"%@ positionTabInViewWithYOrigin: %f", [self class], yOriginNew);

	[UIView animateWithDuration:modalTab__duration__changeConfiguration delay:0.0f options:UIViewAnimationOptionCurveEaseOut
					 animations:^{
						 [self setFrame:CGRectMake(0, yOriginNew, 320, modalTab__heightTotal)];
					 }
					 completion:^(BOOL finished){
					 }
	 ];
}

- (void) positionTabOutOfViewForDelegate:(id)callbackDelegate forNewForegroundTab:(ModalTab*)theNewForegroundTab {
	//NSLog(@"%@ positionTabOutOfViewForDelegate: %@ forNewForegroundTab: %@", [self class], [callbackDelegate class], [theNewForegroundTab class]);
	
	[UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveEaseOut
					 animations:^{
						 [self setFrame:CGRectMake(0,
												   vcCheckSite__height - modalTab__tabLabel__heightDefault,
												   320,
												   self.frame.size.height)];
					 } completion:^(BOOL finished){
						 if (callbackDelegate) {
							 [callbackDelegate positionAllModalTabsInViewBehind:theNewForegroundTab];
						 }
					 }
	 ];
}

- (BOOL) isPositionedInView {
	
	if (self.frame.origin.y < vcCheckSite__height - modalTab__tabLabel__heightDefault) {
		return YES;
	}
	return NO;
}

@end
