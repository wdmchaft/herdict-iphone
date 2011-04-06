//
//  About.h
//  Herdict
//
//  Created by Christian Brink on 4/5/11.
//  Copyright 2011 Herdict. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Constants.h"
#import "CustomUIButton.h"


@interface About : UIView {

	UILabel *heading;
	UITextView *message;
	CustomUIButton *buttonLearnMore;	
	CustomUIButton *buttonDone;
}

@property (nonatomic, retain) UILabel *heading;
@property (nonatomic, retain) UITextView *message;
@property (nonatomic, retain) CustomUIButton *buttonLearnMore;
@property (nonatomic, retain) CustomUIButton *buttonDone;

- (void) show;
- (void) hide;
- (void) selectButtonLearnMore;
- (void) selectButtonDone;

@end
