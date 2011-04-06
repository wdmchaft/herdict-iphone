//
//  Network.m
//  Herdict
//
//  Created by Christian Brink on 4/5/11.
//  Copyright 2011 Herdict. All rights reserved.
//

#import "Network.h"


@implementation Network

@synthesize networkImageView;
@synthesize messageView;
@synthesize messageText;
@synthesize buttonDone;
@synthesize loadingIndicator;
@synthesize loadingText;

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
		
		UIImage *logoImage = [UIImage imageNamed:@"55-wifi@2x.png"];
		self.networkImageView = [[UIImageView alloc] initWithImage:logoImage];
		[self.networkImageView setFrame:CGRectMake((networkView__width - networkView_networkImageView__width) / 2.0,
													   networkView_networkImageView__yOffset,
													   networkView_networkImageView__width,
													   networkView_networkImageView__height)];
		self.networkImageView.alpha = 0.35;
		[self addSubview:self.networkImageView];
		
		// --	Set up loadingIndicator and loadingText
		self.loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		[self.loadingIndicator setFrame:CGRectMake(0.5 * (networkView__width - (siteSummary_loadingAnimation__diameter + 11 + siteSummary_loadingText__width)),
												   networkView_loadingIndicator__yOffset__stateLoading,
												   siteSummary_loadingAnimation__diameter,
												   siteSummary_loadingAnimation__diameter)];
		self.loadingIndicator.backgroundColor = [UIColor clearColor];
		[self.loadingIndicator startAnimating];
		[self addSubview:self.loadingIndicator];
		self.loadingText = [[UILabel alloc] initWithFrame:CGRectMake(12 + self.loadingIndicator.frame.origin.x + siteSummary_loadingAnimation__diameter,
																	 1 + networkView_loadingIndicator__yOffset__stateLoading,
																	 siteSummary_loadingText__width,
																	 siteSummary_loadingText__height + 5)];
		self.loadingText.text = @"Checking Connection...";
		self.loadingText.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
		self.loadingText.backgroundColor = [UIColor clearColor];
		self.loadingText.textColor = [UIColor grayColor];
		[self addSubview:self.loadingText];
		
		self.messageView = [[UIWebView alloc] initWithFrame:CGRectMake((networkView__width - networkView_messageView__width) / 2.0,
																   networkView_messageView__yOffset,
																   networkView_messageView__width,
																   networkView_messageView__height__stateCarrier)];
		self.messageView.userInteractionEnabled = NO;
		self.messageView.backgroundColor = [UIColor clearColor];
		self.messageView.opaque = NO;
						
		self.buttonDone = [CustomUIButton buttonWithType:UIButtonTypeCustom];		
		[self.buttonDone setTitle:@"OK" forState:UIControlStateNormal];
		[self.buttonDone addTarget:self.buttonDone action:@selector(setSelected) forControlEvents:UIControlEventTouchDown];
		[self.buttonDone addTarget:self action:@selector(selectButtonDone) forControlEvents:UIControlEventTouchUpInside];
		[self.buttonDone addTarget:self.buttonDone action:@selector(setNotSelected) forControlEvents:UIControlEventTouchUpOutside];
		[self.buttonDone setFrame:CGRectMake((networkView__width - networkView_messageView__width) / 2.0,
											 networkView_buttonDone__yOffset__stateLoading,
											 networkView_messageView__width,
											 30)];
		[self.buttonDone.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
		[self addSubview:self.buttonDone];
		
		// --	Get Reachability notifications.
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkReachabilityEvent:) name:kReachabilityChangedNotification object:nil];
	}
    return self;
}

- (void)dealloc {
	[loadingIndicator release];
	[loadingText release];
	[buttonDone release];
	[messageView release];
	[networkImageView release];
    [super dealloc];
}

- (void) networkReachabilityEvent: (NSNotification *) notification {
	NSLog(@"notified of a reachability event");
	Reachability *r = [notification object];
	if (![r isReachable]) {
		[self noConnectivity];
		return;
	}		
	BOOL requiresPassword = NO;
	if ([r isInterventionRequired]) {
		requiresPassword = YES;
	}
	if ([r isReachableViaWWAN]) {
		[self connectedVia:@"wwan" requiresPassword:requiresPassword];
		return;
	}
	if ([r isReachableViaWiFi]) {
		[self connectedVia:@"wifi" requiresPassword:requiresPassword];
		return;
	}	
}

- (void) show {
	[UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
					 animations:^{
						 self.alpha = 1;
					 } completion:^(BOOL finished){
					 }
	 ];
}

- (void) hide {
	[UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
					 animations:^{
						 self.alpha = 0;
					 } completion:^(BOOL finished){
						 [self removeFromSuperview];
					 }
	 ];
}

- (void) connectedVia:(NSString *)connectionType requiresPassword:(BOOL)requiresPassword {
	NSLog(@"connectedVia:%@ requiresPassword:%@", connectionType, requiresPassword ? @"YES" : @"NO");

	self.networkImageView.alpha = 1;

	[self.loadingIndicator removeFromSuperview];
	[self.loadingText removeFromSuperview];

	NSString *messageSubstring = @"your wireless service provider.";	
	CGFloat heightForNetworkView_messageView = networkView_messageView__height__stateCarrier;
	CGFloat networkView_yOffset_buttonDone = networkView_buttonDone__yOffset__stateCarrier;
	CGFloat heightForNetworkView = networkView__height__stateCarrier;
	requiresPassword = YES;
	if ([connectionType isEqualToString:@"wifi"]) {
		if (requiresPassword) {
			messageSubstring = @"a Wi-Fi access point, but you may have to provide a password or accept terms of service before it will work properly.\n\nYou can see the network name (SSID) in your phone's Settings menu.";
			heightForNetworkView_messageView = networkView_messageView__height__stateWifi__interventionRequired;
			networkView_yOffset_buttonDone = networkView_buttonDone__yOffset__stateWifi__interventionRequired;
			heightForNetworkView = networkView__height__stateWifi__interventionRequired;			
		} else {
			messageSubstring = @"a Wi-Fi access point.  You can see the network name (SSID) in your phone's Settings menu.";
			heightForNetworkView_messageView = networkView_messageView__height__stateWifi__noIntervention;
			networkView_yOffset_buttonDone = networkView_buttonDone__yOffset__stateWifi__noIntervention;
			heightForNetworkView = networkView__height__stateWifi__noIntervention;
		}			
	}
	[self.messageView loadHTMLString:[NSString stringWithFormat:@"<body align='justify' style=\"background-color:transparent;font-family:Helvetica;font-size:14px;color:black;\"><b>%@%@</b></body>",@"You are connected to the Internet via ", messageSubstring] baseURL:nil];	
	[self.messageView setFrame:CGRectMake((networkView__width - networkView_messageView__width) / 2.0,
										  networkView_messageView__yOffset,
										  networkView_messageView__width,
										  heightForNetworkView_messageView)];
	[self addSubview:self.messageView];
	
	[self.buttonDone setFrame:CGRectMake((networkView__width - networkView_messageView__width) / 2.0,
										  networkView_yOffset_buttonDone,
										  networkView_messageView__width,
										  30)];
	
	[self setFrame:CGRectMake(0.5 * (320.0 - networkView__width),
							  0.5 * (480.0 - heightForNetworkView),
							  networkView__width,
							  heightForNetworkView)];
}

- (void) noConnectivity {

	[self.loadingIndicator removeFromSuperview];
	[self.loadingText removeFromSuperview];
	
	[self.messageView loadHTMLString:[NSString stringWithFormat:@"<body align='justify' style=\"background-color:transparent;font-family:Helvetica;font-size:15px;color:black;\"><b>%@%@</b></body>",@"Your device does not have an active Internet connection at this time."] baseURL:nil];
	[self.messageView setFrame:CGRectMake((networkView__width - networkView_messageView__width) / 2.0,
										  networkView_messageView__yOffset,
										  networkView_messageView__width,
										  networkView_messageView__height__stateNoConnectivity)];
	[self addSubview:self.messageView];
	
	[self.buttonDone setFrame:CGRectMake((networkView__width - networkView_messageView__width) / 2.0,
										 networkView_buttonDone__yOffset__stateNoConnectivity,
										 networkView_messageView__width,
										 30)];
	
	[self setFrame:CGRectMake(0.5 * (320.0 - networkView__width),
							  0.5 * (480.0 - networkView__height__stateNoConnectivity),
							  networkView__width,
							  networkView__height__stateNoConnectivity)];
}

- (void) selectButtonDone {
	[self.buttonDone setNotSelected];
	[self hide];
}

@end