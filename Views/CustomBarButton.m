//
//  CustomBarButton.m
//  Herdict
//
//  Created by Christian Brink on 3/23/11.
//  Copyright 2011 Herdict. All rights reserved.
//

#import "CustomBarButton.h"
#import "Constants.h"

@implementation CustomBarButton

@synthesize theTitle;
@synthesize notSelectedBackground;
@synthesize selectedBackground;


- (id) initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:CGRectMake(0, 0, 57, 30)];
    if (self) {
		
		self.userInteractionEnabled = YES;
		
		self.layer.cornerRadius = 6;
		self.layer.masksToBounds = YES;
		self.backgroundColor = [UIColor whiteColor];
		self.notSelectedBackground = [[GradientBackground alloc] initWithFrame:CGRectMake(0, 0, 57, 30)];
		self.notSelectedBackground.alpha = 1;
		self.notSelectedBackground.userInteractionEnabled = NO;
		[self addSubview:self.notSelectedBackground];
		
		self.selectedBackground = [[GradientBackground alloc] initWithFrame:CGRectMake(0, 0, 57, 30)];
		self.selectedBackground.floatRed = 0.141;
		self.selectedBackground.floatGreen = 0.555;
		self.selectedBackground.floatBlue = 0.995;
		self.selectedBackground.alpha = 0;
		self.selectedBackground.userInteractionEnabled = NO;
		[self addSubview:self.selectedBackground];
		
		self.theTitle = [[[UILabel alloc] initWithFrame:CGRectMake(-1, 5, 57, 20)] autorelease];
		self.theTitle.textColor = UIColorFromRGB(0x404040);
		self.theTitle.alpha = 0.9;
		self.theTitle.textAlignment = UITextAlignmentCenter;
		self.theTitle.backgroundColor = [UIColor clearColor];
		[self.theTitle setFont:[UIFont boldSystemFontOfSize:12]];
		self.theTitle.shadowOffset = CGSizeMake(0, 1);
		self.theTitle.shadowColor = [UIColor whiteColor];
		self.theTitle.userInteractionEnabled = NO;
		[self addSubview:self.theTitle];
		
	}
    return self;
}

- (void) setSelected {

	self.notSelectedBackground.alpha = 0;
	self.selectedBackground.alpha = 1;
	self.theTitle.textColor = [UIColor whiteColor];
	self.theTitle.shadowColor = [UIColor blackColor];
//	self.theTitle.shadowOffset = CGSizeMake(0, -1);
}

- (void) setNotSelected {

	self.selectedBackground.alpha = 0;
	self.notSelectedBackground.alpha = 1;
	self.theTitle.textColor = UIColorFromRGB(0x404040);
	self.theTitle.shadowColor = [UIColor whiteColor];
	self.theTitle.shadowOffset = CGSizeMake(0, 1);	
}

- (void)dealloc {
    [super dealloc];
}


@end
