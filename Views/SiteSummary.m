//
//  SiteSummary.m
//  Herdict
//
//  Created by Christian Brink on 3/22/11.
//  Copyright 2011 Herdict. All rights reserved.
//

#import "SiteSummary.h"
#import "Constants.h"

@implementation SiteSummary

@synthesize theBackground;
@synthesize textView1;
@synthesize textView2;
@synthesize theFooter;
@synthesize hideLabel;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
		self.backgroundColor = [UIColor clearColor];
		self.userInteractionEnabled = YES;
		
		self.theBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
		self.theBackground.backgroundColor = UIColorFromRGB(0x94cc00);
		self.theBackground.alpha = 0.95;
		self.theBackground.userInteractionEnabled = NO;
		[self addSubview:self.theBackground];

		self.textView1 = [[UITextView alloc] initWithFrame:CGRectMake(32, 5, 280, 55)];
		self.textView1.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
		self.textView1.backgroundColor = [UIColor clearColor];
		self.textView1.textColor = [UIColor whiteColor];
		self.textView1.editable = NO;
		self.textView1.text = @"This site has been\nreported inaccessible:";
		self.textView1.userInteractionEnabled = NO;
		[self addSubview:self.textView1];
		
		self.textView2 = [[UITextView alloc] initWithFrame:CGRectMake(32, 53, 280, 55)];
		self.textView2.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
		self.textView2.backgroundColor = [UIColor clearColor];
		self.textView2.textColor = [UIColor whiteColor];
		self.textView2.editable = NO;
		self.textView2.userInteractionEnabled = NO;
		[self addSubview:self.textView2];
		
		self.hideLabel = [[UILabel alloc] initWithFrame:CGRectMake(280, 7, 40, 14)];
		self.hideLabel.backgroundColor = [UIColor clearColor];
		self.hideLabel.textAlignment = UITextAlignmentCenter;
		self.hideLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
		self.hideLabel.textColor = [UIColor whiteColor];
		self.hideLabel.text = @"hide";
		self.hideLabel.userInteractionEnabled = NO;
		[self addSubview:self.hideLabel];
		
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}


@end
