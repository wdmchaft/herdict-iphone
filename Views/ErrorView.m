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

@synthesize componentRed;
@synthesize componentGreen;
@synthesize componentBlue;
@synthesize componentAlpha;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {

		self.backgroundColor = [UIColor clearColor];
		self.componentRed = 0.0f;
		self.componentGreen = 0.0f;
		self.componentBlue = 0.0f;
		self.componentAlpha = 0.7f;
		
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

- (void) drawRect:(CGRect)rect {
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextSetLineJoin(context, kCGLineJoinRound);
	CGContextSetLineWidth(context, 2);
	
	CGContextSetRGBStrokeColor(context, self.componentRed, self.componentGreen, self.componentBlue, self.componentAlpha * 0.6f);
	CGContextSetRGBFillColor(context, self.componentRed, self.componentGreen, self.componentBlue, self.componentAlpha);
	
	CGContextAddPath(context, [self newPath]);
	
	CGContextDrawPath(context, kCGPathFillStroke);		
}

- (CGPathRef) newPath {
	
	CGFloat offsetForStroke = 1.0f;
	CGFloat cornerRad = 8.0f;
	CGFloat selfWidth = self.frame.size.width;
	CGFloat selfHeight = self.frame.size.height;
	
	CGMutablePathRef thePath = CGPathCreateMutable();
	
	// --	Begin at right edge to the right of hideTab, proceed counterclockwise.
	CGPathMoveToPoint(thePath, NULL, selfWidth - cornerRad, 0);
	CGPathAddLineToPoint(thePath, NULL, cornerRad, 0);
	CGPathAddArcToPoint(thePath, NULL, 0, 0, 0, cornerRad, cornerRad);
	CGPathAddLineToPoint(thePath, NULL, 0, selfHeight - cornerRad);
	CGPathAddArcToPoint(thePath, NULL, 0, selfHeight, cornerRad, selfHeight, cornerRad);
	CGPathAddLineToPoint(thePath, NULL, selfWidth - cornerRad, selfHeight);
	CGPathAddArcToPoint(thePath, NULL, selfWidth, selfHeight, selfWidth, selfHeight - cornerRad, cornerRad);
	CGPathAddLineToPoint(thePath, NULL, selfWidth, cornerRad);
	CGPathAddArcToPoint(thePath, NULL, selfWidth, 0, selfWidth - cornerRad, 0, cornerRad);
	
	return thePath;
}

- (void) setErrorMessage:(NSString *)theString {
	[self.errorWebView loadHTMLString:[NSString stringWithFormat:@"<body align='justify' style=\"background-color:transparent;font-family:Helvetica;font-size:15px;color:white;\"><b>%@</b></body>",theString] baseURL:nil];
}

- (void) selectButtonOk {
	[self.buttonOk setNotSelected];
	[self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.1f];
}

- (void)dealloc {
    [super dealloc];
}

@end
