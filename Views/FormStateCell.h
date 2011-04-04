//
//  FormStateCell.h
//  Herdict
//
//  Created by Christian Brink on 3/24/11.
//  Copyright 2011 Herdict. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "BubbleMenu.h"


@class FormStateCell;
@protocol FormStateCellDelegate <NSObject>
@optional
@end


@interface FormStateCell : UITableViewCell {

	UIImageView *theIconView;
	
	UIView *textPlate;
	UILabel *cellLabel;
	UILabel *cellDetailLabel;
	
	id <FormStateCellDelegate> theDelegate;
}

@property (nonatomic, retain) UIImageView *theIconView;

@property (nonatomic, retain) UIView *textPlate;
@property (nonatomic, retain) UILabel *cellLabel;
@property (nonatomic, retain) UILabel *cellDetailLabel;
@property (nonatomic, retain) id <FormStateCellDelegate> theDelegate;

- (void) arrangeSubviewsForNewHeight:(CGFloat)theNewHeight;

@end
