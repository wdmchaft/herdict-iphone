//
//  URLBar.m
//  Herdict
//
//  Created by Christian Brink on 3/23/11.
//  Copyright 2011 Herdict. All rights reserved.
//

#import "URLBar.h"


@implementation URLBar


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
		UIImage *urlIcon = [UIImage imageNamed:@"globe.png"];	
		UIImageView *urlIconView = [[UIImageView alloc] initWithImage:urlIcon];
		[searchBarTextField.leftView addSubview:urlIconView];
    }
    return self;
}

- (void) drawRect:(CGRect)rect {
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGGradientRef myGradient;
	
	CGFloat locations[3];
	CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
	NSMutableArray *colors = [NSMutableArray arrayWithCapacity:2];

	UIColor *color0 = [UIColor colorWithRed:(themeRed - navBarColorDelta) green:(themeGreen - navBarColorDelta) blue:(themeBlue - navBarColorDelta)  alpha:0.9];
	UIColor *color1 = [UIColor colorWithRed:(themeRed - urlBarColorDelta) green:(themeGreen - urlBarColorDelta) blue:(themeBlue - urlBarColorDelta)  alpha:0.9];
	UIColor *color2 = [UIColor colorWithRed:(themeRed - 0.482) green:(themeGreen - 0.482) blue:(themeBlue - 0.482)  alpha:0.9];
	
	locations[0] = 0.25;
	[colors addObject:(id)[color0 CGColor]];
	locations[1] = 0.96;
	[colors addObject:(id)[color1 CGColor]];
	locations[2] = 1.00;
	[colors addObject:(id)[color2 CGColor]];
	
	
//	UIColor *color0 = [UIColor colorWithRed:(themeRed - 0.392) green:(themeGreen - 0.392) blue:(themeBlue - 0.392)  alpha:0.9];
//	UIColor *color1 = [UIColor colorWithRed:themeRed green:themeGreen blue:themeBlue alpha:1];
//	UIColor *color2 = [UIColor colorWithRed:(themeRed - 0.252) green:(themeGreen - 0.252) blue:(themeBlue - 0.252)  alpha:0.9];
//	
//	locations[0] = 0.0;
//	[colors addObject:(id)[color0 CGColor]];
//	locations[1] = 0.02;
//	[colors addObject:(id)[color1 CGColor]];
//	locations[2] = 0.2;
//	[colors addObject:(id)[color1 CGColor]];
//	locations[3] = 0.98;
//	[colors addObject:(id)[color2 CGColor]];
//	locations[4] = 1.0;
//	[colors addObject:(id)[color0 CGColor]];
	
	myGradient = CGGradientCreateWithColors(space, (CFArrayRef)colors, locations);
	CGColorSpaceRelease(space);
	
	CGRect currentBounds = self.bounds;
	CGPoint topCenter = CGPointMake(CGRectGetMidX(currentBounds), 0.0f);
	CGPoint bottomCenter = CGPointMake(CGRectGetMidX(currentBounds), (heightForURLBar));
	CGContextDrawLinearGradient(context, myGradient, topCenter, bottomCenter, 0);
	
    CGGradientRelease(myGradient);
    CGColorSpaceRelease(space);
	
	CGContextDrawPath(context, kCGPathStroke);
	
}


- (void)dealloc {
    [super dealloc];
}


@end
