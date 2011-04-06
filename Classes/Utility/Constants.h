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


// --	themeColor
#define themeColorRed	0.984//0.915//0.949
#define themeColorGreen	0.964//0.906//0.937
#define themeColorBlue	0.920//0.769//0.914

// --	vcBase.aboutView
#define aboutView__height 277.0f
#define aboutView__width 250.0f
#define aboutView_berkmanLogo__height 90.0f
#define aboutView_berkmanLogo__width 195.0f
#define aboutView_messageView__height 100.0f
#define aboutView_message__width 190.0f
#define aboutView_buttonLearnMore__yOffset 196.0f
#define aboutView_buttonDone__yOffset 231.0f

// --	vcBase.networkView
#define networkView__width 240.0f
#define networkView_networkImageView__yOffset 16.0f
#define networkView_networkImageView__width 60.0f
#define networkView_networkImageView__height 46.0f
#define networkView_messageView__yOffset 67.0f
#define networkView_messageView__width 190.0f

#define networkView__height__stateLoading 161.0f
#define networkView_loadingIndicator__yOffset__stateLoading 73.0f
#define networkView_buttonDone__yOffset__stateLoading 115.0f

#define networkView__height__stateWifi__noIntervention 242.0f
#define networkView_messageView__height__stateWifi__noIntervention 120.0f
#define networkView_buttonDone__yOffset__stateWifi__noIntervention 195.0f

#define networkView__height__stateWifi__interventionRequired 315.0f
#define networkView_messageView__height__stateWifi__interventionRequired 193.0f
#define networkView_buttonDone__yOffset__stateWifi__interventionRequired 268.0f

#define networkView__height__stateCarrier 191.0f
#define networkView_messageView__height__stateCarrier 80.0f
#define networkView_buttonDone__yOffset__stateCarrier 145.0f

#define networkView__height__stateNoConnectivity 192.0f
#define networkView_messageView__height__stateNoConnectivity 70.0f
#define networkView_buttonDone__yOffset__stateNoConnectivity 145.0f

// --	VC_Base elements
#define statusBar__height 20.0
#define navBar__height 44.0
#define navBar__colorDelta 0.102
#define urlBar__yOrigin 40.0
#define urlBar__height 41.0
#define urlBar__colorDelta 0.132
#define bubbleMenu_body__yPadding 3.0f
#define bubbleMenuOption__height 33.0
#define tabTracker__height 11.0
#define tabTracker__width 16.0

// --	VC_CheckSite elements
#define siteLoadingAnimation__diameter 25.0
#define siteLoadingText__width 120.0
#define siteLoadingText__height 20.0

// --	SiteSummary elements
#define siteSummary__height 149.0
#define siteSummary_hideTab__xOffset 23.0
#define siteSummary_hideTab__width 110.0
#define siteSummary_hideTab__height 33.0
#define siteSummary_hideTab__text__stateShowing @"Summary"
#define siteSummary_hideTab__text__stateHidden @"Summary"
#define siteSummary_loadingAnimation__diameter 25.0
#define siteSummary_loadingText__width 158.0  // perfect for text "Getting Summary..." in Helvetica 18.
#define siteSummary_loadingText__height 18.0

// --	VC_ReportSite elements
#define formStateCell__height 110.0
#define formStateCell_iconView__diameter__full 48.0
#define formStateCell_iconView__diameter__shrunk 30.0
#define formClearCell__height 330.0;
#define formStateCell__heightToSubtractWhenShrinking 0.0
#define menuCategoryOption__height 27.0

// --	FormMenuAccessible elements
#define formMenuAccessible_button__width 75.0
#define formMenuAccessible__height 27.0
#define formMenuAccessible__gapBetweenButtons 6.0