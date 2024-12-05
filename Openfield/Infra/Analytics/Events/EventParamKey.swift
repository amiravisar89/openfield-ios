//
//  EventParamKey.swift
//  Openfield
//
//  Created by Daniel Kochavi on 27/03/2020.
//  Copyright © 2020 Prospera. All rights reserved.
//

import FirebaseAnalytics

enum EventParamKey {
  static let itemId = AnalyticsParameterItemID
  static let itemList = AnalyticsParameterItemListID
  static let itemVariant = AnalyticsParameterItemVariant
  static let category = AnalyticsParameterItemCategory
  static let value = AnalyticsParameterValue
  static let itemCount = "item_count"
  static let highlight = "highlight"
  static let imageId = "image_id"
  static let zoom = "zoom"
  static let imageUrl = "image_url"
  static let imageLayer = "image_layer"
  static let error = "error"
  static let toggleAction = "toggle_action"
  static let tagsCount = "tags_count"
  static let carouselItem = "carousel_item"
  static let origin = "origin"
  static let monthlyReportUid = "monthly_report_uid"
  static let insightUid = "insight_uid"
  static let imagery_date = "imagery_date"
  static let userReportUid = "user_report_uid"
  static let insightType = "insight_type"
  static let imageryDate = "imagery_date"
  static let filterCount = "filter_count"
  static let animation = "animation"
  static let direction = "direction"
  static let fieldId = "field_id"
  static let farmId = "farm_id"
  static let cycleId = "cycle_id"
  static let rolesList = "roles_list"
  static let farmList = "farm_list"
  static let sawFeedBackWalkthrough = "saw_feedback_walkthrough"
  static let feedbackFreeText = "feddback_free_text"
  static let rating = "rating"
  static let reason = "reason"
  static let previousRating = "previous_rating"
  static let selectedFeedback = "selected_feedback"
  static let action = "action"
  static let totalItems = "total_items"
  static let visibileItems = "visible_items"
  static let imageLoadingTime = "image_loading_time"
  static let listFiltered = "list_filtered"
  static let hasImagery = "has_imagery"
  static let issueName = "issue_name"
  static let issueId = "issue_id"
  static let presentedIndex = "presented_index"
  static let totalIssues = "total_issues"
  static let language = "language"
  static let previousLanguage = "previous_language"
  static let deviceLanguage = "device_language"
  static let contractVersion = "contract_version"
  static let contractIsAccept = "contract_is_accept"
  static let contractType = "contract_type"
  static let reportType = "report_type"
  static let totalImages = "total_images"
  static let imageIndex = "image_index"
  static let cardIndex = "card_index"
  static let scrollAll = "scroll_all"
  static let index = "index"
  static let fromDate = "from_date"
  static let insightUnread = "insight_unread"
  static let insightCategory = "category"
  static let numCategories = "num_categories"
  static let numCategoriesUnread = "num_categories_unread"
  static let numHighlights = "num_highlights"
  static let position = "position"
  static let numHighlightsShowAll = "num_highlights_show_all"
  static let highlightType = "highlight_type"
  static let currentSeason = "current_season"
  static let newSeason = "new_season"
  static let shareStrategy = "share_strategy"
  static let currentReport = "current_report"
  static let userSelection = "user_selection"
  static let currentCycle = "current_cycle"
  static let reportRequest = "report_request"
}
