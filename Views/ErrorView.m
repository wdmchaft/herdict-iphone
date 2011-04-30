//
//  ErrorView.m
//  Herdict
//
//  Created by Christian Brink on 4/30/11.
//  Copyright 2011 Herdict. All rights reserved.
//

#import "ErrorView.h"


@implementation ErrorView

@synthesize errorString;
@synthesize errorWebView;
@synthesize buttonOk;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
		
		self.layer.cornerRadius = 8.0f;
		self.layer.masksToBounds = YES;
		
		self.backgroundColor = [UIColor colorWithRed:modalTab__text__colorRed green:modalTab__text__colorGreen blue:modalTab__text__colorBlue alpha:1.0f];
		
		self.errorWebView = [[UIWebView alloc] initWithFrame:CGRectMake(self.frame.size.width * 0.1,
																		  self.frame.size.height * 0.1,
																		  self.frame.size.width * 0.8,
																		  self.frame.size.height * 0.8)];
		self.errorWebView.userInteractionEnabled = NO;
		self.errorWebView.backgroundColor = [UIColor clearColor];
		self.errorWebView.opaque = NO;
		[self addSubview:self.errorWebView];

		for (UIView *aSubview in [self.errorWebView subviews]) {
			if ([aSubview isKindOfClass:[UIScrollView class]]) {
				for (UIView *aSubSubview in [aSubview subviews]) {
					if ([aSubSubview isKindOfClass:[UIImageView class]]) {
						[aSubSubview setHidden:YES];
					}
				}
			}
		}
		
		self.buttonOk = [CustomUIButton buttonWithType:UIButtonTypeCustom];
		[self.buttonOk setTitle:@"OK" forState:UIControlStateNormal];
		[self.buttonOk addTarget:self.buttonOk action:@selector(setSelected) forControlEvents:UIControlEventTouchDown];
		[self.buttonOk addTarget:self action:@selector(selectButtonOk) forControlEvents:UIControlEventTouchUpInside];
		[self.buttonOk addTarget:self.buttonOk action:@selector(setNotSelected) forControlEvents:UIControlEventTouchUpOutside];
		[self.buttonOk setFrame:CGRectMake(0.5 * (self.frame.size.width - 160.0f),
										   self.frame.size.height - 50.0f,
										   160.0f,
										   33.0f)];
		[self.buttonOk setColorComponentsWithRed:modalTab__text__colorRed withGreen:modalTab__text__colorGreen withBlue:modalTab__text__colorBlue withAlpha:1.0f];
		[self.buttonOk setTitleColor:UIColorFromRGB(0x404040) forState:UIControlStateSelected];
		[self.buttonOk setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateSelected];
		[self.buttonOk setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[self.buttonOk setTitleShadowColor:UIColorFromRGB(0x404040) forState:UIControlStateNormal];
		[self addSubview:self.buttonOk];
		
	}
    return self;
}

- (void) setErrorMessage:(NSString *)theString {
	[self.errorWebView loadHTMLString:[NSString stringWithFormat:@"<body align='justify' style=\"background-color:transparent;font-family:Helvetica;font-size:15px;color:white;\"><b>%@</b></body>",theString] baseURL:nil];
}

- (void) selectButtonOk {
	[self.buttonOk setNotSelected];
	[self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.1f];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void)dealloc {
    [super dealloc];
}

@end
