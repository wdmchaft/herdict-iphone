//
//  FormMenuAccessible.m
//  Herdict
//
//  Created by Christian Brink on 4/4/11.
//  Copyright 2011 Herdict. All rights reserved.
//

#import "FormMenuAccessible.h"


@implementation FormMenuAccessible

@synthesize buttonYes;
@synthesize buttonNo;
@synthesize theDelegate;


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {

		self.backgroundColor = [UIColor clearColor];

		self.buttonYes = [CustomUIButton buttonWithType:UIButtonTypeCustom];
		[self.buttonYes addTarget:self.buttonYes action:@selector(setSelected) forControlEvents:UIControlEventTouchDown];
		[self.buttonYes addTarget:self.theDelegate action:@selector(selectButtonAccessibleYes) forControlEvents:UIControlEventTouchUpInside];
		[self.buttonYes addTarget:self.buttonYes action:@selector(setNotSelected) forControlEvents:UIControlEventTouchUpOutside];
		[self.buttonYes setFrame:CGRectMake(0, 0, formMenuAccessible_button__width, menuCategoryOption__height)];
		[self.buttonYes setTitle:@"Yes" forState:UIControlStateNormal];
		[self addSubview:self.buttonYes];
		
		self.buttonNo = [CustomUIButton buttonWithType:UIButtonTypeCustom];
		[self.buttonNo addTarget:self.buttonNo action:@selector(setSelected) forControlEvents:UIControlEventTouchDown];
		[self.buttonNo addTarget:self.theDelegate action:@selector(selectButtonAccessibleNo) forControlEvents:UIControlEventTouchUpInside];
		[self.buttonNo addTarget:self.buttonNo action:@selector(setNotSelected) forControlEvents:UIControlEventTouchUpOutside];
		[self.buttonNo setFrame:CGRectMake(formMenuAccessible_button__width + formMenuAccessible__gapBetweenButtons, 0, formMenuAccessible_button__width, menuCategoryOption__height)];
		[self.buttonNo setTitle:@"No" forState:UIControlStateNormal];
		[self addSubview:self.buttonNo];
	}
    return self;
}

- (void)dealloc {
	[buttonYes release];
	[buttonNo release];
	[super dealloc];
}


@end
