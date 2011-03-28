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


#define heightForNavBar 44
#define heightForURLBar 41
#define overlapOnBars 4

#define navBarColorDelta 0.142
#define urlBarColorDelta 0.182

#define heightForSiteSummary 117

#define themeRed	1//0.915//0.949
#define themeGreen	0.974//0.906//0.937
#define themeBlue	0.930//0.769//0.914

#define heightForTabTracker 7
#define widthForTabTracker 9

//	Notes on UITableViewAnimations...
//	Consider using reloadSections instead of deleteRowsAtIndexPaths.  The reload animation for deleteRowsAtIndexPaths doesn't look as good (deleted rows collapse upward while their contents appear to fall out the bottom).
//	Consider invoking reloadSections 2x in any given case.  With a single invocation, new rows pass in front of existing rows when sliding into view, whereas with a double invocation they slide out from behind existing rows.. it looks way better.