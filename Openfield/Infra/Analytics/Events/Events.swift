//
//  Events.swift
//  Openfield
//
//  Created by Daniel Kochavi on 09/03/2020.
//  Copyright © 2020 Prospera. All rights reserved.
//

enum Events: String {
  case buttonClick = "button_click"
  case scroll

  // Account
  case notificationsConfirmOk = "notifications_confirm_ok"
  case notificationsConfirmCancel = "notifications_confirm_cancel"
  case logoutConfirmOk = "logout_confirm_ok"
  case logoutConfirmCancel = "logout_confirm_cancel"
  case toggleNotifications = "toggle_notifications"
  case toggleNotificationsType = "toggle_notifications_type"

  // Field Image Viewer
  case imageDoubleTapped = "image_double_tap"
  case imageZoom = "image_zoom"
  case imageZoomReset = "image_zoom_reset"
  case imageLegendClicked = "image_legend_click"
  case errorShown = "error_shown"
  case smallImageLoaded = "small_image_loaded"
  case bigImageLoaded = "big_image_loaded"

  // Layer guide
  case dialogShown = "dialog_shown"
  case carouselMove = "carousel_move"
  case carouselItemShown = "carousel_item_shown"
  case textLinkClick = "text_link_click"
  case dialogDismiss = "dialog_dismiss"

  // Welcome
  case navigateToLogin = "navigate_to_login"

  // Login
  case itemSelection = "item_selection"

  // Feed
  case feedInsightClick = "feed_insight_click"
  case feedImageryClick = "feed_imagery_click"
  case labelClick = "label_click"
  case imageryFieldClick = "imagery_field_click"
  case pullToRefresh = "pull_to_refresh"
  case loginToFeed = "login_to_feed"
  case openToFeed = "open_to_feed"

  // Mothly Report
  case monthlyReportView = "monthly_report_view"
  case openToMonthlyReport = "open_to_monthly_report"

  // Insight
  case insightView = "insight_view"
  case locationInsightView = "location_insight_view"
  case insightCardOpen = "insight_card_open"
  case insightCardClose = "insight_card_close"
  case toolTipShown = "tooltip_shown"
  case ratingStarClicked = "rating_star_click"
  case openToInsight = "open_to_insight"
  case openToUserReport = "open_to_userReport"
  case sawInsightWithoutRating = "saw_insight_without_rating"

  // Location Insights
  case viewIssueCard = "view_issue_card"
  case clickIssueCard = "click_issue_card"
  case viewLocationImage = "view_location_image"
  case zoomOnLocationImage = "zoom_on_location_image"
  case navigateToImageLocation = "navigate_to_image_location"
  case reportImageClick = "report_image_click"
  case insightZoomed = "insight_map_zoom"

  // Analysis
  case analysisView = "analysis_view"
  case layerSelected = "layer_selected"
  case itemToggle = "item_toggle"
  case dateChanged = "date_change"

  // Fields

  case fieldsFieldClick = "fields_field_click"
  case fieldView = "field_view"
  case fieldInsightClick = "field_insight_click"
  case categoryClick = "category_click"
  case impression

  // Role
  case roleSelection = "role_selection"
  case openRolePopUp = "open_role_popup"

  // Farm selection
  case farmSelection = "farm_selection"
  case openFarmPopup = "open_farm_popup"

  // FeedBack walkthrough
  case sawFeedbackWalktrough = "saw_feedback_walktrough"

  // No connection
  case sawNoConnectionError = "saw_no_connection_error"

  // Optional update
  case optionalUpdate = "optional_update"

  // feedback free text
  case feedbackFreeTextSelected = "feedback_free_text_selected"

  // Cloud indication
  case cloudIndicationButtonClick = "cloud_indication_button_click"

  // compare indication
  case compareButtonclick = "compare_button_click"

  // notifications
  case notification_recieve = "receive_notification"

  // Contracts
  case contractSign = "contract_sign"
  case contractAccept = "contract_accept_click"
  case navigateToContract = "navigate_contract"

  // localization
  case languageChanged = "language_switch"

  case highlightClick = "highlight_click"

  case reportRequestClick = "report_request_click"

  case mapClick = "map_click"

  case shareClick = "share_click"
  case shareBottomsheet = "share_bottomsheet"
  case redirectShapefile = "redirect_shapefile"
  case continueShapefile = "continue_shapefile"
  case cancelShapefile = "cancel_shapefile"
}
