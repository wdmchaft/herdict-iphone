//
//  FormMenuAccessible.h
//  Herdict
//
//  Created by Christian Brink on 4/4/11.
//  Copyright 2011 Herdict. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Constants.h"
#import "Screen.h"
#import "CustomUIButton.h"

@class FormMenuAccessible;
@protocol FormMenuAccessibleDelegate
@optional
@end


@interface FormMenuAccessible : UIView {

	CustomUIButton *buttonYes;
	CustomUIButton *buttonNo;
	
	id <FormMenuAccessibleDelegate> theDelegate;
}

@property (nonatomic, retain) CustomUIButton *buttonYes;
@property (nonatomic, retain) CustomUIButton *buttonNo;

@property (nonatomic, retain) id <FormMenuAccessibleDelegate> theDelegate;

@end
