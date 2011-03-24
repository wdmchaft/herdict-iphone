//
//  URLBar.m
//  Herdict
//
//  Created by Christian Brink on 3/23/11.
//  Copyright 2011 Herdict. All rights reserved.
//

#import "URLBar.h"


@implementation URLBar


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
		self.placeholder = @"Enter URL to Get or Submit a Report";
		self.tintColor = [UIColor colorWithRed:0.893 green:0.903 blue:0.923 alpha:0.9]; // UIColorFromRGB(0xe4eaec);
		self.barStyle = UIBarStyleDefault;
		self.autocorrectionType = UITextAutocorrectionTypeNo;
		self.autocapitalizationType = UITextAutocapitalizationTypeNone;
		self.keyboardType = UIKeyboardTypeURL;
		UITextField *searchBarTextField = [[self subviews] objectAtIndex:1];
		searchBarTextField.returnKeyType = UIReturnKeyGo;
		searchBarTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
		UIImage *urlIcon = [UIImage imageNamed:@"globe.png"];	
		UIImageView *urlIconView = [[UIImageView alloc] initWithImage:urlIcon];
		[searchBarTextField.leftView addSubview:urlIconView];
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}


@end
