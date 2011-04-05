//
//  FormMenuAccessible.m
//  Herdict
//
//  Created by Christian Brink on 4/4/11.
//  Copyright 2011 Herdict. All rights reserved.
//

#import "FormMenuAccessible.h"


@implementation FormMenuAccessible

@synthesize backgroundPlate1;
@synthesize button1;
@synthesize backgroundPlate2;
@synthesize button2;

@synthesize selectionBackground;
@synthesize cornerRad;

@synthesize theScreen;


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {

		self.backgroundColor = [UIColor clearColor];

		self.cornerRad = 4.0;
		self.layer.masksToBounds = YES;
		
		CGFloat ourAlpha = 0.75; 
		
		// --	Make sure there's no tag confusion.
		self.tag = 0;
		for (UIView *aView in [self subviews]) {
			aView.tag = 0;
		}
		
		self.backgroundPlate1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, heightForMenuCategoryOption - 2)];
		self.backgroundPlate1.backgroundColor = [UIColor blackColor];
		self.backgroundPlate1.alpha = ourAlpha;
		self.backgroundPlate1.layer.cornerRadius = self.cornerRad;
		[self addSubview:self.backgroundPlate1];
		self.backgroundPlate2 = [[UIView alloc] initWithFrame:CGRectMake(66, 0, 60, heightForMenuCategoryOption - 2)];
		self.backgroundPlate2.backgroundColor = [UIColor blackColor];
		self.backgroundPlate2.alpha = ourAlpha;
		self.backgroundPlate2.layer.cornerRadius = self.cornerRad;
		[self addSubview:self.backgroundPlate2];
		
		// --	Basic setup for self.selectionBackground. 
		self.selectionBackground = [[UIView alloc] initWithFrame:CGRectZero];
		self.selectionBackground.tag = 0;
		self.selectionBackground.backgroundColor = [UIColor clearColor];
		self.selectionBackground.alpha = 1;
		self.selectionBackground.layer.cornerRadius = self.cornerRad;
		self.selectionBackground.userInteractionEnabled = NO;
		[self addSubview:self.selectionBackground];
		
		self.button1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, heightForMenuCategoryOption - 2)];
		self.button1.textAlignment = UITextAlignmentCenter;
		self.button1.text = @"Yes";
		self.button1.tag = 1;
		self.button1.layer.cornerRadius = self.cornerRad;
		self.button1.textColor = [UIColor whiteColor];
		self.button1.backgroundColor = [UIColor clearColor];
		self.button1.userInteractionEnabled = NO;
		self.button1.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];		
		[self addSubview:self.button1];

		self.button2 = [[UILabel alloc] initWithFrame:CGRectMake(66, 0, 60, heightForMenuCategoryOption - 2)];
		self.button2.textAlignment = UITextAlignmentCenter;
		self.button2.text = @"No";
		self.button2.tag = 2;
		self.button2.layer.cornerRadius = self.cornerRad;
		self.button2.textColor = [UIColor whiteColor];
		self.button2.backgroundColor = [UIColor clearColor];
		self.button2.userInteractionEnabled = NO;
		self.button2.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];		
		[self addSubview:self.button2];	
		
	}
    return self;
}


- (void) showSelectionBackgroundForOption:(int)optionNumber {
	UITextView *selectedOption = [self viewWithTag:optionNumber];
	
	self.selectionBackground.backgroundColor = UIColorFromRGB(0x5AabF7);
	[self.selectionBackground setFrame:CGRectMake(selectedOption.frame.origin.x,
												  selectedOption.frame.origin.y,
												  selectedOption.frame.size.width,
												  selectedOption.frame.size.height)]; 
}

- (void) hideSelectionBackground {
	self.selectionBackground.backgroundColor = [UIColor clearColor];
}

- (void)dealloc {
	[theScreen release];
	[selectionBackground release];
	[button2 release];
	[backgroundPlate2 release];
	[button1 release];
	[backgroundPlate1 release];
    [super dealloc];
}


@end
