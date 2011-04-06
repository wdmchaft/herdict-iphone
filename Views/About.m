//
//  About.m
//  Herdict
//
//  Created by Christian Brink on 4/5/11.
//  Copyright 2011 Herdict. All rights reserved.
//

#import "About.h"

@implementation About

@synthesize heading;
@synthesize message;
@synthesize buttonLearnMore;
@synthesize buttonDone;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
		
		self.backgroundColor = [UIColor colorWithRed:barThemeRed green:barThemeGreen blue:barThemeBlue alpha:1];
		
		self.heading = [[UILabel alloc] initWithFrame:CGRectMake(25, 27, 270, 30)];
		self.heading.font = [UIFont fontWithName:@"Helvetica-Bold" size:24];
		self.heading.textAlignment = UITextAlignmentCenter;
		self.heading.backgroundColor = [UIColor clearColor];
		self.heading.textColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.9];
		self.heading.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
		self.heading.layer.shadowColor = [UIColor grayColor].CGColor;
		self.heading.layer.shadowRadius = 1.0f;
		self.heading.layer.shadowOpacity = 0.5f;
		self.heading.layer.shouldRasterize = YES;		
		self.heading.text = @"About Herdict";
		[self addSubview:self.heading];
		
		
		self.message = [[UITextView alloc] initWithFrame:CGRectMake(30, 62, 260, 210)];
		self.message.scrollEnabled = NO;
		self.message.editable = NO;
		self.message.font = [UIFont fontWithName:@"Helvetica" size:15];
		self.message.textAlignment = UITextAlignmentLeft;
		self.message.backgroundColor = [UIColor clearColor];
		self.message.textColor = [UIColor blackColor];
		self.message.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
		self.message.layer.shadowColor = [UIColor grayColor].CGColor;
		self.message.layer.shadowRadius = 1.0f;
		self.message.layer.shadowOpacity = 0.3f;
		self.message.layer.shouldRasterize = YES;
		self.message.text = @"Herdict is a project of the Berkman Center for Internet & Society at Harvard University. Herdict is a portmanteau of 'herd' and 'verdict' and seeks to show the verdict of the users (the herd). Herdict Web seeks to gain insight into what users around the world are experiencing in terms of web accessibility; or in other words, determine the herdict.";
		[self addSubview:self.message];
		
		self.buttonLearnMore = [CustomUIButton buttonWithType:UIButtonTypeCustom];		
		[self.buttonLearnMore setTitle:@"Learn More" forState:UIControlStateNormal];
		[self.buttonLearnMore addTarget:self.buttonLearnMore action:@selector(setSelected) forControlEvents:UIControlEventTouchDown];
		[self.buttonLearnMore addTarget:self action:@selector(selectButtonLearnMore) forControlEvents:UIControlEventTouchUpInside];
		[self.buttonLearnMore addTarget:self.buttonLearnMore action:@selector(setNotSelected) forControlEvents:UIControlEventTouchUpOutside];
		[self.buttonLearnMore setFrame:CGRectMake(35,277,250,33)];
		[self.buttonLearnMore.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
		[self addSubview:self.buttonLearnMore];
		
		self.buttonDone = [CustomUIButton buttonWithType:UIButtonTypeCustom];		
		[self.buttonDone setTitle:@"Done" forState:UIControlStateNormal];
		[self.buttonDone addTarget:self.buttonDone action:@selector(setSelected) forControlEvents:UIControlEventTouchDown];
		[self.buttonDone addTarget:self action:@selector(selectButtonDone) forControlEvents:UIControlEventTouchUpInside];
		[self.buttonDone addTarget:self.buttonDone action:@selector(setNotSelected) forControlEvents:UIControlEventTouchUpOutside];
		[self.buttonDone setFrame:CGRectMake(35,317,250,33)];
		[self.buttonDone.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
		[self addSubview:self.buttonDone];
	}
    return self;
}

- (void)dealloc {
	[buttonDone release];
	[buttonLearnMore release];
	[message release];
	[heading release];	
    [super dealloc];
}

- (void) show {
	[UIView animateWithDuration:0.35 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
					 animations:^{
						 [self setFrame:CGRectMake(self.frame.origin.x,
												   heightForNavBar - yOverhangForNavBar + heightForURLBar,
												   self.frame.size.width,
												   self.frame.size.height)];
					 } completion:^(BOOL finished){
					 }
	 ];
}

- (void) hide {
	[UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
					 animations:^{
						 [self setFrame:CGRectMake(self.frame.origin.x,
												   460,
												   self.frame.size.width,
												   self.frame.size.height)];
					 } completion:^(BOOL finished){
						 [self removeFromSuperview];
					 }
	 ];
}

- (void) selectButtonLearnMore {
	[self.buttonLearnMore setNotSelected];

	NSURL *url = [NSURL URLWithString:@"http://www.herdict.org"];	
	if (![[UIApplication sharedApplication] openURL:url])
		NSLog(@"%@%@",@"Failed to open url:",[url description]);
	[self selectButtonDone];
}

- (void) selectButtonDone {
	[self.buttonDone setNotSelected];
	[self hide];
}

@end
