//
//  FormStateCell.m
//  Herdict
//
//  Created by Christian Brink on 3/24/11.
//  Copyright 2011 Herdict. All rights reserved.
//

#import "FormStateCell.h"


@implementation FormStateCell

@synthesize theIconView;

@synthesize textPlate;
@synthesize cellLabel;
@synthesize cellDetailLabel;
@synthesize theDelegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		
		self.userInteractionEnabled = YES;
		
		// --	Get rid of the default UITableViewCell backgroundView
		UIView *backView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
		backView.backgroundColor = [UIColor clearColor];
		self.backgroundView = backView;
		self.layer.cornerRadius = 5;

		self.selectionStyle = UITableViewCellSelectionStyleNone;
		
		self.theIconView = [[UIImageView alloc] initWithFrame:CGRectMake(0,
																		 0,
																		 0,
																		 0)];
		[self addSubview:self.theIconView];
		
		self.textPlate = [[UIView alloc] initWithFrame:CGRectMake(0,
																  0,
																  320,
																  0)];
		self.textPlate.backgroundColor = [UIColor clearColor];
		[self addSubview:self.textPlate];
		
		self.cellLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,
																   -3,
																   0,
																   0)];
		self.cellLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:24];
		self.cellLabel.textColor = [UIColor blackColor];
		self.cellLabel.alpha = 1;
		self.cellLabel.backgroundColor = [UIColor clearColor];
		[self.textPlate addSubview:self.cellLabel];
		
		self.cellDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,
																		 0,
																		 0,
																		 0)];
		self.cellDetailLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
		self.cellDetailLabel.textColor = [UIColor grayColor];
		self.cellDetailLabel.alpha = 1;
		self.cellDetailLabel.backgroundColor = [UIColor clearColor];
		[self.textPlate addSubview:self.cellDetailLabel];
		
		self.layer.masksToBounds = NO;
		self.layer.shadowOffset = CGSizeMake(0, 0);
		self.layer.shadowRadius = 5;
		self.layer.shadowOpacity = 0.8;
		self.layer.shouldRasterize = YES;
//		self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;		
	}
    return self;
}

- (void)dealloc {
	[cellDetailLabel release];
	[cellLabel release];
	[textPlate release];
	[theIconView release];
    [super dealloc];
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	//NSLog(@"touchesBegan on the FormStateCell");
	
	[self.theDelegate touchesBegan:touches withEvent:event];
	[self.superview touchesBegan:touches withEvent:event];
}

- (void) arrangeSubviewsForNewHeight:(CGFloat)theNewHeight {
//	NSLog(@"arrangeSubviewsForNewHeight: %f", theNewHeight);
	
	if (self.cellDetailLabel.alpha > 0.5) {
		[UIView animateWithDuration:0.15 delay:0.0 options:nil
						 animations:^{
//							 self.cellLabel.alpha = 0;
//							 self.cellDetailLabel.alpha = 0;
//							 self.theIconView.alpha = 0;
						 } completion:^(BOOL finished){
//							 [self.cellLabel setFrame:CGRectMake(formStateCell__height - 5.0,
//																 (0.5 * (formStateCell_iconView__diameter__shrunk - 5.0)),
//																 self.frame.size.width,
//																 20.0)];
//							 self.cellLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
//							 [self.textPlate setFrame:CGRectMake(0.0,
//																 (0.5 * (theNewHeight - formStateCell_iconView__diameter__full)),
//																 320.0,
//																 formStateCell_iconView__diameter__full)];
							 //		[UIView animateWithDuration:0.3
							 //						 animations:^{
							 //							 [self.theIconView setFrame:CGRectMake(0.5 * (formStateCell__height - formStateCell_iconView__diameter__full),
							 //																   (0.5 * (theNewHeight - formStateCell_iconView__diameter__full)),
							 //																   formStateCell_iconView__diameter__full,
							 //																   formStateCell_iconView__diameter__full)];							 
						 }
		 ];
		[UIView animateWithDuration:0.1 delay:0.25 options:nil
						 animations:^{
//							 self.cellLabel.alpha = 1;
						 } completion:^(BOOL finished){
						 }
		 ];		
	} else {
		[UIView animateWithDuration:0.075 delay:0.0 options:nil
						 animations:^{
//							 self.cellLabel.alpha = 0;
						 } completion:^(BOOL finished){
//							 [self.cellLabel setFrame:CGRectMake(formStateCell__height,
//																 -3.0,
//																 320.0 - formStateCell__height,
//																 30.0)];
//							 self.cellLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:24];
//							 //	Make sure textPlate, superview to cellLabel, knows the new values...
//							 [self.textPlate setFrame:CGRectMake(0.0,
//																 (0.5 * (theNewHeight - formStateCell_iconView__diameter__shrunk)),
//																 320.0,
//																 formStateCell_iconView__diameter__shrunk)];
							 //		[UIView animateWithDuration:0.3
							 //						 animations:^{
							 //							 [self.theIconView setFrame:CGRectMake(0.5 * (formStateCell__height - formStateCell_iconView__diameter__shrunk),
							 //																   (0.5 * (theNewHeight - formStateCell_iconView__diameter__shrunk)),
							 //																   formStateCell_iconView__diameter__shrunk,
							 //																   formStateCell_iconView__diameter__shrunk)];							 
						 }
		 ];
		[UIView animateWithDuration:0.075 delay:0.2 options:nil
						 animations:^{
//							 self.cellLabel.alpha = 1;
//							 self.cellDetailLabel.alpha = 1;
//							 self.theIconView.alpha = 1;
						 } completion:^(BOOL finished) {
						 }
		 ];		
	}
}

- (void) drawRect:(CGRect)rect {

	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGGradientRef myGradient;
	
	CGFloat locations[5];
	CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
	NSMutableArray *colors = [NSMutableArray arrayWithCapacity:5];
	UIColor *color0 = [UIColor colorWithRed:themeColorRed green:themeColorGreen blue:themeColorBlue alpha:1];
//	UIColor *color1 = [UIColor colorWithRed:(themeColorRed - 0.022) green:(themeColorGreen - 0.022) blue:(themeColorBlue - 0.022)  alpha:1];	
//	UIColor *color2 = [UIColor colorWithRed:(themeColorRed - 0.062) green:(themeColorGreen - 0.062) blue:(themeColorBlue - 0.062)  alpha:1];
//	UIColor *color3 = [UIColor colorWithRed:(themeColorRed - 0.092) green:(themeColorGreen - 0.092) blue:(themeColorBlue - 0.092)  alpha:0.9];
	UIColor *color4 = [UIColor colorWithRed:(themeColorRed - 0.182) green:(themeColorGreen - 0.182) blue:(themeColorBlue - 0.182)  alpha:1];

	locations[0] = 0.00;
	[colors addObject:(id)[color0 CGColor]];
	locations[1] = 0.4;
	[colors addObject:(id)[color0 CGColor]];
	locations[2] = 0.8;
	[colors addObject:(id)[color0 CGColor]];
	locations[3] = 0.94;
	[colors addObject:(id)[color0 CGColor]];	
	locations[4] = 1.0;
	[colors addObject:(id)[color4 CGColor]];
	
	myGradient = CGGradientCreateWithColors(space, (CFArrayRef)colors, locations);
	CGColorSpaceRelease(space);
	
	CGRect currentBounds = self.bounds;
	CGPoint topCenter = CGPointMake(CGRectGetMidX(currentBounds), 0.0f);
	CGPoint bottomCenter = CGPointMake(CGRectGetMidX(currentBounds), self.frame.size.height);
	CGContextDrawLinearGradient(context, myGradient, topCenter, bottomCenter, 0);
	
    CGGradientRelease(myGradient);
//    CGColorSpaceRelease(space);
	
	CGContextDrawPath(context, kCGPathStroke);
}

@end
