//
//  Screen.m
//  Herdict
//
//  Created by Christian Brink on 3/28/11.
//  Copyright 2011 Herdict. All rights reserved.
//

#import "Screen.h"


@implementation Screen


//- (id)initWithFrame:(CGRect)frame {
//    
//    self = [super initWithFrame:frame];
//    if (self) {
//
//    }
//    return self;
//}

//- (UIView *) hitTest:(CGPoint)point withEvent:(UIEvent *)event {
//	NSLog(@"hitTest on the special view");
//
//	return [self.superview hitTest:point withEvent:event];
//}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	NSLog(@"touchesBegan on the special view");
	[self.superview touchesBegan:touches withEvent:event];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

//- (void)dealloc {
//    [super dealloc];
//}


@end
