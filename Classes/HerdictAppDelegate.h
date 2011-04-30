//
//  HerdictAppDelegate.h
//  Herdict
//
//  Created by Christian Brink on 3/7/11.
//  Copyright 2011 Herdict, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "VC_Base.h"

@interface HerdictAppDelegate : NSObject <UIApplicationDelegate> {

    UIWindow *window;
	UIView *viewSplash;
	VC_Base *vcBase;
	
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) UIView *viewSplash;
@property (nonatomic, retain) VC_Base *vcBase;

@end
