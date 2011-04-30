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
@synthesize latestNotification;

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
		[self.loadingIndicator setFrame:CGRectMake(0.5 * (networkView__width - (siteSummaryTab_loadingAnimation__diameter + 11 + siteSummaryTab_loadingText__width)),
												   networkView_loadingIndicator__yOffset__stateLoading,
												   siteSummaryTab_loadingAnimation__diameter,
												   siteSummaryTab_loadingAnimation__diameter)];
		self.loadingIndicator.backgroundColor = [UIColor clearColor];
		[self.loadingIndicator startAnimating];
		[self addSubview:self.loadingIndicator];
		self.loadingText = [[UILabel alloc] initWithFrame:CGRectMake(12 + self.loadingIndicator.frame.origin.x + siteSummaryTab_loadingAnimation__diameter,
																	 1 + networkView_loadingIndicator__yOffset__stateLoading,
																	 siteSummaryTab_loadingText__width,
																	 siteSummaryTab_loadingText__height + 5)];
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
	//NSLog(@"notified of a reachability event");

	[[HerdictArrays sharedSingleton] setDetected_ispName:@""];
	[[WebservicesController sharedSingleton] getCurrentLocation:[HerdictArrays sharedSingleton]];

	self.latestNotification = [notification object];

	if (![self.latestNotification isReachable]) {
		[NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(show) userInfo:nil repeats:NO];
	}
}

- (void) show {
	
	[[self.delegate vcHerdometer] pauseAnnotatingReport];
	
	BOOL requiresPassword = NO;
	
	if (![self.latestNotification isReachable]) {
		[self noConnectivity];
	} else {
		if ([self.latestNotification isInterventionRequired]) {
			requiresPassword = YES;
		}
		if ([self.latestNotification isReachableViaWWAN]) {
			[self configureViewForConnectionVia:@"wwan" requiresPassword:requiresPassword];
		}
		if ([self.latestNotification isReachableViaWiFi]) {
			[self configureViewForConnectionVia:@"wifi" requiresPassword:requiresPassword];
		}
	}
	
	[UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
					 animations:^{
						 self.alpha = 1;
					 } completion:^(BOOL finished){
					 }
	 ];
}
		
- (void) noConnectivity {
	
	[self.loadingIndicator removeFromSuperview];
	[self.loadingText removeFromSuperview];
	
	[self.messageView loadHTMLString:[NSString stringWithFormat:@"<body align='justify' style=\"background-color:transparent;font-family:Helvetica;font-size:15px;color:black;\"><b>%@</b></body>",@"Your device does not have an active Internet connection at this time."] baseURL:nil];
	
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

- (void) configureViewForConnectionVia:(NSString *)connectionType requiresPassword:(BOOL)requiresPassword {
	NSLog(@"configureViewForConnectionVia:%@ requiresPassword:%@", connectionType, requiresPassword ? @"YES" : @"NO");
	
	self.networkImageView.alpha = 1;
	
	[self.loadingIndicator removeFromSuperview];
	[self.loadingText removeFromSuperview];

	NSString *networkTypeSubstring = [NSString stringWithString:@""];
	NSString *ispNameSubstring = [NSString stringWithString:@""];
	NSString *requiresPasswordSubstring = [NSString stringWithString:@""];
	CGFloat heightForNetworkView_messageView;
	CGFloat networkView_yOffset_buttonDone;
	CGFloat heightForNetworkView;
	
	if (requiresPassword) {
		requiresPasswordSubstring = @"  You may have to provide a password or accept terms of service before this connection will work properly.";
	}
	
	if ([connectionType isEqualToString:@"wwan"]) {
		networkTypeSubstring = @"You are connected to the Internet via your wireless service provider";	
		heightForNetworkView_messageView = networkView_messageView__height__stateCarrier;
		networkView_yOffset_buttonDone = networkView_buttonDone__yOffset__stateCarrier;
		heightForNetworkView = networkView__height__stateCarrier;
	} else if ([connectionType isEqualToString:@"wifi"]) {
		if ([[[HerdictArrays sharedSingleton] detected_ispName] isEqualToString:@""]) {
			networkTypeSubstring = @"a Wifi network";
			heightForNetworkView_messageView = networkView_messageView__height__stateWifi__notShowingIspName;
			networkView_yOffset_buttonDone = networkView_buttonDone__yOffset__stateWifi__notShowingIspName;
			heightForNetworkView = networkView__height__stateWifi__notShowingIspName;
		} else {
			networkTypeSubstring = [NSString stringWithFormat:@"You are connected to a Wi-Fi access point"];
			ispNameSubstring = [NSString stringWithFormat:@"; the Internet Service Provider is %@", [[HerdictArrays sharedSingleton] detected_ispName]];
			NSLog(@"[[HerdictArrays sharedSingleton] detected_ispName]: %@", [[HerdictArrays sharedSingleton] detected_ispName]);
			NSLog(@"[ispNameSubstring: %@", ispNameSubstring);			
			heightForNetworkView_messageView = networkView_messageView__height__stateWifi__showingIspName;
			networkView_yOffset_buttonDone = networkView_buttonDone__yOffset__stateWifi__showingIspName;
			heightForNetworkView = networkView__height__stateWifi__showingIspName;
		}
	}
	[self.messageView loadHTMLString:[NSString stringWithFormat:@"<body align='justify' style=\"background-color:transparent;font-family:Helvetica;font-size:14px;color:black;\"><b>%@%@%@</b></body>",
									  networkTypeSubstring,
									  ispNameSubstring,
									  @".",
									  requiresPasswordSubstring] baseURL:nil];
	
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


- (void) selectButtonDone {
	[self.buttonDone setNotSelected];
	[self hide];
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

@end