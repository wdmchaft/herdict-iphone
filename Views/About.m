//
//  About.m
//  Herdict
//
//  Created by Christian Brink on 4/5/11.
//  Copyright 2011 Herdict. All rights reserved.
//

#import "About.h"

@implementation About

@synthesize berkmanLogoImageView;
@synthesize message;
@synthesize buttonLearnMore;
@synthesize buttonDone;

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
		
		self.backgroundColor = [UIColor colorWithRed:1 green:0.985 blue:0.955 alpha:0.95];
		self.layer.cornerRadius = 10.0f;
		self.layer.shadowRadius = 5.0f;
		self.layer.shouldRasterize = YES;
		self.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
		self.layer.shadowOpacity = 0.4f;
		
		self.alpha = 0;
		
//		UIImage *logoImage = [UIImage imageNamed:@"berkmanlogo.png"];
//		self.berkmanLogoImageView = [[UIImageView alloc] initWithImage:logoImage];
//		[self.berkmanLogoImageView setFrame:CGRectMake((aboutView__width - aboutView_berkmanLogo__width) / 2.0,
//													   12,
//													   aboutView_berkmanLogo__width,
//													   aboutView_berkmanLogo__height)];
//		[self addSubview:self.berkmanLogoImageView];
		
		self.message = [[UIWebView alloc] initWithFrame:CGRectMake((aboutView__width - aboutView_message__width) / 2.0,
																   12,
																   aboutView_message__width,
																   aboutView_messageView__height)];
		self.message.userInteractionEnabled = NO;
		self.message.backgroundColor = [UIColor clearColor];
		self.message.opaque = NO;
		[self.message loadHTMLString:[NSString stringWithFormat:@"<body align='justify' style=\"background-color:transparent;font-family:Helvetica;font-size:13px;color:black;\"><b>%@</b></body>",@"Have you ever come across a web site that you could not access and wondered, \"Am I the only one?\" Herdict Web aggregates reports of inaccessible sites, allowing users to compare data to see if inaccessibility is a shared problem. By crowdsourcing data from around the world, we can document accessibility for any web site, anywhere."] baseURL:nil];
		[self addSubview:self.message];
		
		self.buttonLearnMore = [CustomUIButton buttonWithType:UIButtonTypeCustom];		
		[self.buttonLearnMore setTitle:@"Learn More" forState:UIControlStateNormal];
		[self.buttonLearnMore addTarget:self.buttonLearnMore action:@selector(setSelected) forControlEvents:UIControlEventTouchDown];
		[self.buttonLearnMore addTarget:self action:@selector(selectButtonLearnMore) forControlEvents:UIControlEventTouchUpInside];
		[self.buttonLearnMore addTarget:self.buttonLearnMore action:@selector(setNotSelected) forControlEvents:UIControlEventTouchUpOutside];
		[self.buttonLearnMore setFrame:CGRectMake((aboutView__width - aboutView_message__width) / 2.0,
												  aboutView_buttonLearnMore__yOffset,
												  aboutView_message__width,
												  30)];
		[self.buttonLearnMore.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
		[self addSubview:self.buttonLearnMore];
		
		self.buttonDone = [CustomUIButton buttonWithType:UIButtonTypeCustom];		
		[self.buttonDone setTitle:@"Done" forState:UIControlStateNormal];
		[self.buttonDone addTarget:self.buttonDone action:@selector(setSelected) forControlEvents:UIControlEventTouchDown];
		[self.buttonDone addTarget:self action:@selector(selectButtonDone) forControlEvents:UIControlEventTouchUpInside];
		[self.buttonDone addTarget:self.buttonDone action:@selector(setNotSelected) forControlEvents:UIControlEventTouchUpOutside];
		[self.buttonDone setFrame:CGRectMake((aboutView__width - aboutView_message__width) / 2.0,
											 aboutView_buttonDone__yOffset,
											 aboutView_message__width,
											 30)];
		[self.buttonDone.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
		[self addSubview:self.buttonDone];
	}
    return self;
}

- (void)dealloc {
	[buttonDone release];
	[buttonLearnMore release];
	[message release];
//	[berkmanLogoImageView release];
    [super dealloc];
}

- (void) show {
	
	[[self.delegate vcHerdometer] pauseAnnotatingReport];
	
	[UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
					 animations:^{
						 self.alpha = 1;
					 } completion:^(BOOL finished){
					 }
	 ];
}

- (void) hide {
	
	[[self.delegate vcHerdometer] resumeAnnotatingReport];

	[UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
					 animations:^{
						 self.alpha = 0;
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
