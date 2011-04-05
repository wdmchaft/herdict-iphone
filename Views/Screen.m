//
//  Screen.m
//  Herdict
//
//  Created by Christian Brink on 3/28/11.
//  Copyright 2011 Herdict. All rights reserved.
//

#import "Screen.h"


@implementation Screen


- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	//NSLog(@"touchesBegan on the special view");
	[self.superview touchesBegan:touches withEvent:event];
}


@end
