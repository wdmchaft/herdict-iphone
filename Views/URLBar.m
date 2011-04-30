//
//  URLBar.m
//  Herdict
//
//  Created by Christian Brink on 3/23/11.
//  Copyright 2011 Herdict. All rights reserved.
//

#import "URLBar.h"


@implementation URLBar

@synthesize buttonSearch;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
		
		self.placeholder = @"Enter URL to Get or Submit a Report";
		self.autocorrectionType = UITextAutocorrectionTypeNo;
		self.autocapitalizationType = UITextAutocapitalizationTypeNone;
		self.keyboardType = UIKeyboardTypeURL;
		
		UITextField *searchBarTextField = [[self subviews] objectAtIndex:1];
		searchBarTextField.returnKeyType = UIReturnKeyGo;
		searchBarTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
//		[searchBarTextField setFrame:CGRectMake(searchBarTextField.frame.origin.x,
//												searchBarTextField.frame.origin.y,
//												searchBarTextField.frame.size.width - 60,
//												searchBarTextField.frame.size.height)];
//		
//		self.buttonSearch = [CustomUIButton buttonWithType:UIButtonTypeCustom];
//		[self.buttonSearch addTarget:self.buttonSearch action:@selector(setSelected) forControlEvents:UIControlEventTouchDown];
//		[self.buttonSearch addTarget:self.delegate action:@selector(selectButtonAccessibleYes) forControlEvents:UIControlEventTouchUpInside];
//		[self.buttonSearch addTarget:self.buttonSearch action:@selector(setNotSelected) forControlEvents:UIControlEventTouchUpOutside];
//		[self.buttonSearch setFrame:CGRectMake(275, 0, 50, 30)];
//		[self.buttonSearch setTitle:@"Yes" forState:UIControlStateNormal];
//		[self addSubview:self.buttonSearch];
		
		UIImage *urlIcon = [UIImage imageNamed:@"globe.png"];	
		UIImageView *urlIconView = [[[UIImageView alloc] initWithImage:urlIcon] autorelease];
		[searchBarTextField.leftView addSubview:urlIconView];
		
		self.layer.masksToBounds = NO;
		self.layer.shadowOffset = CGSizeMake(0, 0);
		self.layer.shadowRadius = 5;
		self.layer.shadowOpacity = 0.8;
		self.layer.shouldRasterize = YES;
		self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}

- (void) drawRect:(CGRect)rect {
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGGradientRef myGradient;
	
	CGFloat locations[3];
	CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
	NSMutableArray *colors = [NSMutableArray arrayWithCapacity:2];

	UIColor *color0 = [UIColor colorWithRed:(themeColorRed - navBar__colorDelta) green:(themeColorGreen - navBar__colorDelta) blue:(themeColorBlue - navBar__colorDelta)  alpha:1.0];
	UIColor *color1 = [UIColor colorWithRed:(themeColorRed - urlBar__colorDelta) green:(themeColorGreen - urlBar__colorDelta) blue:(themeColorBlue - urlBar__colorDelta)  alpha:1.0];
	UIColor *color2 = [UIColor colorWithRed:(themeColorRed - 0.382) green:(themeColorGreen - 0.382) blue:(themeColorBlue - 0.382)  alpha:1.0];
	
	locations[0] = 0.25;
	[colors addObject:(id)[color0 CGColor]];
	locations[1] = 0.94;
	[colors addObject:(id)[color1 CGColor]];
	locations[2] = 1.00;
	[colors addObject:(id)[color2 CGColor]];	
	
	myGradient = CGGradientCreateWithColors(space, (CFArrayRef)colors, locations);
	CGColorSpaceRelease(space);
	
	CGRect currentBounds = self.bounds;
	CGPoint topCenter = CGPointMake(CGRectGetMidX(currentBounds), 0.0f);
	CGPoint bottomCenter = CGPointMake(CGRectGetMidX(currentBounds), (urlBar__height));
	CGContextDrawLinearGradient(context, myGradient, topCenter, bottomCenter, 0);
	
    CGGradientRelease(myGradient);
//    CGColorSpaceRelease(space);

	CGContextDrawPath(context, kCGPathStroke);
}


@end
