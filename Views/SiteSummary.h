//
//  SiteSummary.h
//  Herdict
//
//  Created by Christian Brink on 3/22/11.
//  Copyright 2011 Herdict. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface SiteSummary : UIView {

	UITextView *textView1;
	UITextView *textView2;
	UILabel *hideLabel;
	UIActivityIndicatorView *loadingIndicator;
	UILabel *loadingText;		
}

@property (nonatomic, retain) UITextView *textView1;
@property (nonatomic, retain) UITextView *textView2;
@property (nonatomic, retain) UILabel *hideLabel;
@property (nonatomic, retain) UIActivityIndicatorView *loadingIndicator;
@property (nonatomic, retain) UILabel *loadingText;

- (CGPathRef) getPath;
- (void) positionSiteSummaryInView;
- (void) positionSiteSummaryOutOfView;
- (void) setStateLoading;
- (void) setStateLoaded:(NSString *)theMessageString theColor:(int)theSheepColor;

@end
