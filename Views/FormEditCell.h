//
//  FormEditCell.h
//  Herdict
//
//  Created by Christian Brink on 3/29/11.
//  Copyright 2011 Herdict. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "BubbleMenu.h"

@interface FormEditCell : UITableViewCell {
	
	UITextView *theMessage;
	NSMutableArray *menuOptions;
	UIView *selectionBackground;
	
	CGFloat selfwidth;
	CGFloat selfheight;
	
}

@property (nonatomic, retain) UITextView *theMessage;
@property (nonatomic, retain) NSMutableArray *menuOptions;
@property (nonatomic, retain) UIView *selectionBackground;

@property (nonatomic) CGFloat selfwidth;
@property (nonatomic) CGFloat selfheight;

@end
