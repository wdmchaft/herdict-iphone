//
//  Constants.h
//  Herdict
//
//  Created by Christian Brink on 3/7/11.
//  Copyright 2011 Herdict, Inc. All rights reserved.
//

#define UIColorFromRGB(rgbValue) [UIColor \
		colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
		green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
		blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//	for UITableViewCells
#define alphaForCustomToolbar 0.5
#define alphaForTableViewCells 0.75
#define heightUsedBySHC 44
#define widthUsedBySHC 290	//	In fact self.frame.size.width is 320, because that's how UITableViewCells work.
#define gapBtwnBgrdViewsInSHC 3
#define cornerRadForBgrdViewsInSHC 5
#define xOriginForSHCLabelAfterExitingStageLeft -75
#define xOriginForSHCLabelAfterExitingStageRight 350
#define xOriginOfWidthUsedBySHC 15
#define xOriginForLabel__ButtonNonCancel__PreparedToEnterStageRight 60
#define	xOriginForLabel__ButtonCancel__PreparedToEnterStageRight 300
#define yOffsetOfDiscViewFromMapViewCenter 25

#define forMenuButtonNonCancel @"0"
#define forMenuButtonCancel @"1"
#define forFormHeader @"2"

//	Note (x3):  We could use deleteRowsAtIndexPaths instead of reloadSections in the statement below, but we don't need any extra granularity in this use case, and the reload animation for deleteRowsAtIndexPaths doesn't look as good (deleted rows collapse upward while their contents appear to fall out the bottom).

//	Note (x6):  We invoke reloadSections 2x on purpose.  With a single invocation, new rows slide into view IN FRONT OF existing rows, whereas (don't ask me why) with a double invocation they slide out from behind existing rows, which looks much better.