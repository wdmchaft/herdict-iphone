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
#define barThemeRed	0.984//0.915//0.949
#define barThemeGreen	0.964//0.906//0.937
#define barThemeBlue	0.920//0.769//0.914
#define menuThemeRed 0.906
#define menuThemeGreen 0.945
#define menuThemeBlue 0.973

/* --	VC_Base elements	-- */
#define heightForStatusBar_nonBaseViews 0
#define heightForStatusBar_real 20.0

#define heightForNavBar 44.0
#define yOverhangForNavBar 4.0
#define navBarColorDelta 0.102
#define urlBarColorDelta 0.132

#define heightForURLBar 41.0

#define yPaddingForBubbleMenuBody 3.0
#define heightForBubbleMenuOption 33.0

#define heightForTabTracker 11.0
#define widthForTabTracker 16.0

/* --	VC_CheckSite elements	-- */
#define diameterForSiteLoadingAnimation 25.0
#define widthForSiteLoadingText 120.0
#define heightForSiteLoadingText 20.0

/* --	SiteSummary elements	-- */
#define heightForSiteSummary 149.0
#define xOffsetForSiteSummaryHideTab 40.0
#define widthForSiteSummaryHideTab 150.0
#define heightForSiteSummaryHideTab 33.0
#define textForSiteSummaryHideTabStateShowing @"Hide Summary"
#define textForSiteSummaryHideTabStateHidden @"Show Summary"
#define diameterForSiteSummaryLoadingAnimation 25.0
#define widthForSiteSummaryLoadingText 158.0  // perfect for text "Getting Summary..." in Helvetica 18.
#define heightForSiteSummaryLoadingText 18.0

/* --	VC_ReportSite elements	-- */
#define heightForFormStateCell 110.0
#define diameterForFormStateCellIconView_full 48.0
#define diameterForFormStateCellIconView_shrunk 30.0
#define heightForFormClearCell 330.0;
#define heightForMenuCategoryOption 27.0
#define heightToSubtractWhenFormStateCellShrinks 0.0

//	Notes on UITableViewAnimations...
//	Consider using reloadSections instead of deleteRowsAtIndexPaths.  The reload animation for deleteRowsAtIndexPaths doesn't look as good (deleted rows collapse upward while their contents appear to fall out the bottom).
//	Consider invoking reloadSections 2x in any given case.  With a single invocation, new rows pass in front of existing rows when sliding into view, whereas with a double invocation they slide out from behind existing rows.. it looks way better.