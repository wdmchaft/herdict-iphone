//
//  SiteSummary.h
//  Herdict
//
//  Created by Christian Brink on 3/22/11.
//  Copyright 2011 Herdict. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "FooterBar.h"

@interface SiteSummary : UIView {

	UIView *theBackground;
	UITextView *textView1;
	UITextView *textView2;
	FooterBar *theFooter;
	UILabel *hideLabel;
		
}

@property (nonatomic, retain) UIView *theBackground;
@property (nonatomic, retain) UITextView *textView1;
@property (nonatomic, retain) UITextView *textView2;
@property (nonatomic, retain) FooterBar *theFooter;
@property (nonatomic, retain) UILabel *hideLabel;

@end