//
//  FooterBar.m
//  Herdict
//
//  Created by Christian Brink on 3/21/11.
//  Copyright 2011 Herdict. All rights reserved.
//

#import "FooterBar.h"


@implementation FooterBar

@synthesize theBackground;
@synthesize textViewLeft;
@synthesize textViewRight;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];

	if (self) {
		self.theBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
		self.theBackground.backgroundColor = [UIColor blackColor];
		self.theBackground.alpha = 0.85;
		self.theBackground.userInteractionEnabled = NO;
		[self addSubview:self.theBackground];
		
		self.textViewLeft = [[UITextView alloc] initWithFrame:CGRectMake(26, 3, 70, 30)];
		self.textViewLeft.backgroundColor = [UIColor clearColor];
		self.textViewLeft.textColor = [UIColor whiteColor];
		self.textViewLeft.textAlignment = UITextAlignmentLeft;
		self.textViewLeft.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
		self.textViewLeft.userInteractionEnabled = NO;
		[self addSubview:self.textViewLeft];
		
		self.textViewRight = [[UITextView alloc] initWithFrame:CGRectMake(79, 3, 170, 30)];
		self.textViewRight.backgroundColor = [UIColor clearColor];
		self.textViewRight.textColor = [UIColor whiteColor];
		self.textViewRight.textAlignment = UITextAlignmentLeft;
		self.textViewRight.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
		self.textViewRight.userInteractionEnabled = NO;
		[self addSubview:self.textViewRight];
		
		UIImage *triangleImage = [UIImage imageNamed:@"triangle.png"];
		UIImageView *triangleImageView = [[UIImageView alloc] initWithImage:triangleImage];
		[triangleImageView setFrame:CGRectMake(261, 14, 24, 15)];
		triangleImageView.contentMode = UIViewContentModeScaleToFill;
		triangleImageView.userInteractionEnabled = NO;
		[self addSubview:triangleImageView];
				
	}    
	return self;
}

- (void)dealloc {
    [super dealloc];
}


@end
