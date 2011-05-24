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
#define aboutView__height 342.0f
#define aboutView__width 250.0f
#define aboutView_berkmanLogo__height 90.0f
#define aboutView_berkmanLogo__width 195.0f
#define aboutView_messageView__height 265.0f
#define aboutView_message__width 190.0f
#define aboutView_buttonLearnMore__yOffset 261.0f
#define aboutView_buttonDone__yOffset 296.0f

// --	vcBase.networkView
#define detected_ispName_notFoundString @"notYetFound"

#define networkView__width 240.0f
#define networkView_networkImageView__yOffset 16.0f
#define networkView_networkImageView__width 60.0f
#define networkView_networkImageView__height 46.0f
#define networkView_messageView__yOffset 67.0f
#define networkView_messageView__width 190.0f

#define networkView__height__stateLoading 161.0f
#define networkView_loadingIndicator__yOffset__stateLoading 73.0f
#define networkView_buttonDone__yOffset__stateLoading 115.0f

#define networkView__height__stateWifi__notShowingIspName 202.0f
#define networkView_messageView__height__stateWifi__notShowingIspName 80.0f
#define networkView_buttonDone__yOffset__stateWifi__notShowingIspName 155.0f

#define networkView__height__stateWifi__showingIspName 227.0f
#define networkView_messageView__height__stateWifi__showingIspName 125.0f
#define networkView_buttonDone__yOffset__stateWifi__showingIspName 180.0f

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
#define loadingBar__xOrigin 0.0f
#define loadingBar__yOrigin__stateShow 37.0f
#define loadingBar__yOrigin__stateHide 7.0f
#define loadingBar__width 180.0f
#define loadingBar__height 30.0f
#define loadingBarAnimation__diameter 19.0f
#define loadingBarGap 8.0f
#define loadingBarText__width 86.0f
#define loadingBarText__height 20.0f
#define navBar__height 44.0f
#define navBar__colorDelta 0.102f
#define urlBar__yOrigin 40.0f
#define urlBar__height 41.0f
#define urlBar__colorDelta 0.132f
#define bubbleMenu_body__yPadding 3.0f
#define bubbleMenuOption__height 33.0
#define tabTracker__height 11.0f
#define tabTracker__width 16.0
#define controllerVc__yOrigin 36.0f
#define controllerVc__height 380.0f

// --	VC_CheckSite
#define vcCheckSite__height 417.0f

// --	ModalTab
#define modalTab__count 2.0f
#define modalTab__heightTotal 440.0f
#define modalTab__tabLabel__width 130.0f
#define modalTab__tabLabel__heightDefault 33.0f
#define modalTab__text__colorRed 0.37f//0.694f
#define modalTab__text__colorGreen 0.37f//0.69f
#define modalTab__text__colorBlue 0.37f//0.69f

// --	SiteSummary (subclass of ModalTab)
#define siteSummaryTab__tabLabel__text @"Summary"
#define siteSummaryTab_loadingAnimation__diameter 22.0f
#define siteSummaryTab__yOrigin__configurationDomainOnly 266.0f
#define siteSummaryTab_domainLoadingText__width 141.0f
#define siteSummaryTab_domainLoadingText__height 16.0f
#define siteSummaryTab_domainLoadingText__fontSize 15.0f
#define siteSummaryTab__yOrigin__configurationDomainAndPath 266.0f
#define siteSummaryTab_domainAndPathLoadingText__width 141.0f
#define siteSummaryTab_domainAndPathLoadingText__height 16.0f
#define siteSummaryTab_domainAndPathLoadingText__fontSize 15.0f

// --	ReportSiteTab (subclass of ModalTab)
#define modalTab__duration__changeConfiguration 0.2f
#define modalTab__duration__addRemoveCommentsSubviews 0.15f
#define reportSiteTab__yOrigin__configurationDefault 247.0f
#define reportSiteTab__yOrigin__configurationAddComments 4.0f
#define reportSiteTab__yOrigin__configurationSelectCategory 50.0f
#define reportSiteTab__tabLabel__xOrigin 22.0f
#define reportSiteTab__tabLabel__text @"Report Site"
#define reportSiteTab__labels__xGapAfterImages 15.0f
#define reportSiteTab__imageViewAddComments__yOrigin 52.0f
#define reportSiteTab__imageViewAddComments__width 20.0f
#define reportSiteTab__imageViewAddComments__height 20.0f
#define reportSiteTab__labelAddComments__yOrigin 52.0f
#define reportSiteTab__labelAddComments__width 190.0f
#define reportSiteTab__labelAddComments__height 18.0f
#define reportSiteTab__labelAddComments__text__configurationDefault @"Tap to Add a Comment"
#define reportSiteTab__imageViewSelectCategory__yOrigin 82.0f
#define reportSiteTab__imageViewSelectCategory__width 20.0f
#define reportSiteTab__imageViewSelectCategory__height 20.0f
#define reportSiteTab__labelSelectCategory__yOrigin 82.0f
#define reportSiteTab__labelSelectCategory__width 190.0f
#define reportSiteTab__labelSelectCategory__height 18.0f
#define reportSiteTab__labelSelectCategory__text__configurationDefault @"Tap to Select a Category"
#define reportSiteTab__mainButtons__yOrigin_default 118.0f
#define reportSiteTab__mainButtons__width 142.0f
#define reportSiteTab__mainButtons__height 34.0f
#define reportSiteTab__mainButtons__gapBetween 10.0f
#define reportSiteTab__menuComments__yOrigin 50.0f
#define reportSiteTab__menuComments__width 280.0f
#define reportSiteTab__menuComments__height 118.0f
#define reportSiteTab__menuComments__textInitial @"Your comments..."
#define reportSiteTab__menuCategoryOption__height 25.0f
#define reportSiteTab__menuCategoryOption__fontSize 14.0f
#define reportSiteTab__menuCategory__yOrigin 57.0f
#define reportSiteTab__menuCategory__width 280.0f