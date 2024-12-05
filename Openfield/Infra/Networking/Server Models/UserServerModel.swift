//
//  UserServerModel.swift
//  Openfield
//
//  Created by Daniel Kochavi on 13/12/2019.
//  Copyright © 2019 Prospera. All rights reserved.
//

import Firebase

struct UserServerModel: Decodable {
    let email: String?
    let first_name: String?
    let id: Int
    let last_name: String?
    let phone: String
    let username: String?
    let insights: [Int: UserInsightServerModel]?
    let user_reports: [Int: UserReportStatusServerModel]?
    let settings: UserSettingsServerModel?
    let tracking: UserTrackingServerModel?
    let is_owner: Bool?
    let subscription_types: [String]?
}

struct UserTrackingServerModel: Decodable {
    let insights_first_read_without_feedback: Int?
    let ts_saw_compare_popup: Timestamp?
    let ts_feedback_popup_last_shown: Timestamp?
    let insights_read_without_opening_card: Int?
    let ts_card_tooltip_last_shown: Timestamp?
    let ts_card_first_open: Timestamp?
    let ts_saw_subscribe_popup: Timestamp?
    let ts_clicked_subscribe_popup: Timestamp?
    let signed_contract_version: Double?
    let seen_contract_version: Double?
    let ts_seen_contract: Timestamp?
}

struct UserSettingsServerModel: Decodable {
    let notifications_enabled: Bool
    let notifications_types: [String]
    var ts_seen_role_popup: Timestamp?
    var ts_seen_field_tooltip: Timestamp?
    var language_code: String?
    let user_role: UserRoleServerModel?
}

struct UserRoleServerModel: Decodable {
    let roles: [String]?
    let other_text: String?
}

struct UserInsightServerModel: Decodable {
    let ts_first_read: Timestamp?
    let ts_read: Timestamp?
    let feedback: UserFeedbackServerModel?
}

struct UserReportStatusServerModel: Decodable {
    let ts_first_read: Timestamp?
    let ts_read: Timestamp?
}

struct UserFeedbackServerModel: Decodable {
    var other_reason: String?
    var rating: Int?
    var reason: FeedbackAnswer?
}

enum NotificationType: String {
    case push = "Push"
    case sms = "SMS"
}

enum FeedbackAnswer: String, Hashable, CaseIterable, Decodable {
    case missingInfo = "missing_info"
    case late
    case cantFix = "cant_fix"
    case notFound = "not_found"
    case other

    var displayString: String {
        switch self {
        case .missingInfo:
            return R.string.localizable.feedbackReasonMissing_info()
        case .late:
            return R.string.localizable.feedbackReasonLate()
        case .cantFix:
            return R.string.localizable.feedbackReasonCant_fix()
        case .notFound:
            return R.string.localizable.feedbackReasonNot_found()
        case .other:
            return R.string.localizable.feedbackReasonOther()
        }
    }
}
