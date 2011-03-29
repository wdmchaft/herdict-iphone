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


/* --	App theme	-- */
#define barThemeRed	1//0.915//0.949
#define barThemeGreen	0.964//0.906//0.937
#define barThemeBlue	0.920//0.769//0.914
#define menuThemeRed 0.906
#define menuThemeGreen 0.945
#define menuThemeBlue 0.973

/* --	VC_Base elements	-- */
#define heightForNavBar 44
#define yOverhangForNavBar 4
#define navBarColorDelta 0.102
#define urlBarColorDelta 0.132

#define heightForURLBar 41

#define yPaddingForBubbleMenuBody 3
#define heightForBubbleMenuOption 33

#define heightForTabTracker 7
#define widthForTabTracker 9

/* --	VC_CheckSite elements	-- */
#define diameterForSiteLoadingAnimation 25
#define widthForSiteLoadingText 120
#define heightForSiteLoadingText 20

/* --	SiteSummary elements	-- */
#define heightForSiteSummary 149
#define xOffsetForSiteSummaryHideTab 40
#define widthForSiteSummaryHideTab 150
#define heightForSiteSummaryHideTab 33
#define textForSiteSummaryHideTabStateShowing @"Hide Summary"
#define textForSiteSummaryHideTabStateHidden @"Show Summary"
#define diameterForSiteSummaryLoadingAnimation 40
#define widthForSiteSummaryLoadingText 180
#define heightForSiteSummaryLoadingText 18

/* --	VC_ReportSite elements	-- */
#define heightForFormStateCell 82
#define diameterForFormStateCellIconView 48

//	Notes on UITableViewAnimations...
//	Consider using reloadSections instead of deleteRowsAtIndexPaths.  The reload animation for deleteRowsAtIndexPaths doesn't look as good (deleted rows collapse upward while their contents appear to fall out the bottom).
//	Consider invoking reloadSections 2x in any given case.  With a single invocation, new rows pass in front of existing rows when sliding into view, whereas with a double invocation they slide out from behind existing rows.. it looks way better.