//
//  ModalTab.h
//  Herdict
//
//  Created by Christian Brink on 4/16/11.
//  Copyright 2011 Herdict. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Constants.h"

@class ModalTab;
@protocol ModalTabDelegate
@optional
- (CGFloat) gapWidth;
- (BOOL) isAnyModalTabPositionedInView;
- (ModalTab *)modalTabInFront;
- (void) positionAllModalTabsOutOfViewExcept:(ModalTab *)thisModalTab;
- (void) positionAllModalTabsInViewBehind:(ModalTab*)thisModalTab;
- (void) positionAllModalTabsInViewWithYOrigin:(CGFloat)yOriginNew;
@end

@interface ModalTab : UIView {

	id <ModalTabDelegate> delegate;

	UILabel *tabLabel;

	CGFloat tabLabel__xOrigin;
	CGFloat yOrigin__default;
	CGFloat yOrigin__current;

	// color components
	CGFloat componentRed;
	CGFloat componentGreen;
	CGFloat componentBlue;
	CGFloat componentAlpha;	
}

@property (nonatomic, retain) id <ModalTabDelegate> delegate;
@property (nonatomic, retain) UILabel *tabLabel;
@property (nonatomic) CGFloat tabLabel__xOrigin;
@property (nonatomic) CGFloat yOrigin__default;
@property (nonatomic) CGFloat yOrigin__current;
@property (nonatomic) CGFloat componentRed;
@property (nonatomic) CGFloat componentGreen;
@property (nonatomic) CGFloat componentBlue;
@property (nonatomic) CGFloat componentAlpha;

- (id) initAsModalTabNumber:(CGFloat)tabNumber defaultYOrigin:(CGFloat)yOriginDefault withTabLabelText:(NSString *)tabLabelText;
- (void) setColorComponentsWithRed:(CGFloat)theRed withGreen:(CGFloat)theGreen withBlue:(CGFloat)theBlue withAlpha:(CGFloat)theAlpha;
- (CGPathRef) newPath;
- (void) positionTabInViewWithYOrigin:(CGFloat)yOriginNew;
- (void) positionTabOutOfViewForDelegate:(id)callbackDelegate forNewForegroundTab:(ModalTab*)theNewForegroundTab;
- (BOOL) isPositionedInView;

- (void) configureDefault;

@end
