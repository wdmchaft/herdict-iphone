//
//  URLBar.h
//  Herdict
//
//  Created by Christian Brink on 3/23/11.
//  Copyright 2011 Herdict. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Constants.h"
#import "CustomUIButton.h"

@interface URLBar : UISearchBar {

	CustomUIButton *buttonSearch;
}

@property (nonatomic, retain) CustomUIButton *buttonSearch;

@end
