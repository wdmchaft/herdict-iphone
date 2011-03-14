//
//  ReportAnnotation.m
//  Herdict
//
//  Created by Christian Brink on 3/12/11.
//  Copyright 2011 Herdict, Inc. All rights reserved.
//

#import "ReportAnnotation.h"

@implementation ReportAnnotation

@synthesize coordinate;
@synthesize title;
@synthesize subtitle;
@synthesize sheepColor;

- (id) initWithBasics:(double)longitude latitude:(double)latitude title:(NSString *)theTitle subtitle:(NSString *)theSubtitle sheepColor:(int)theColor {
	self = [super init];
	if (self != nil) {
		coordinate.longitude = longitude;
		coordinate.latitude = latitude;
		self.title = theTitle;
		self.subtitle = theSubtitle;
		self.sheepColor = theColor;
	}
	return self;
}

@end
