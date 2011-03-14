//
//  ReportAnnotation.h
//  Herdict
//
//  Created by Christian Brink on 3/12/11.
//  Copyright 2011 Herdict, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface ReportAnnotation : NSObject <MKAnnotation> {
	CLLocationCoordinate2D coordinate;
	NSString *title;
	NSString *subtitle;
	int sheepColor;
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *subtitle;
@property (nonatomic) int sheepColor;

- (id) initWithBasics:(double)theLongitude
			 latitude:(double)theLatitude
				title:(NSString *)theTitle
			 subtitle:(NSString *)theSubtitle
		   sheepColor:(int)theColor;

@end
