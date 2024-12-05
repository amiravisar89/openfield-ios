//
//  User.swift
//  Openfield
//
//  Created by Daniel Kochavi on 13/12/2019.
//  Copyright © 2019 Prospera. All rights reserved.
//

import Firebase

struct User {
    let email: String?
    let firstName: String?
    let id: String
    let lastName: String?
    let phone: String
    let username: String?
    let isOwner: Bool
    var insights: [Int: UserInsight]
    var userReports: [Int: UserReportStatus]
    var settings: UserSettings
    var tracking: UserTracking
    var subscriptionTypes: [UserSubscriptionType]

    func isSubscribed() -> Bool {
        return !subscriptionTypes.isEmpty
    }
}

struct UserTracking {
    var insightsFirstReadWithoutFeedback: Int
    var tsFeedbackPopupLastShown: Date?
    var tsSawComparePopup: Date?
    var insightsReadWithoutOpeningCard: Int
    var tsCardTooltipLastShown: Date?
    var tsCardFirstOpen: Date?
    var tsSawSubscribePopUp: Date?
    var tsClickedSubscribePopUp: Date?
    var signedContractVersion: Double?
    var seenContractVersion: Double?
    var tsSeenContract: Date?
}

struct UserSettings: Equatable {
    var notificationsEnabled: Bool
    var notificationsPush: Bool
    var notificationsSms: Bool
    var languageCode: String?
    var seenRolePopUp: Timestamp?
    var seenFieldTooltip: Timestamp?
    var userRole: UserRole?
}

struct UserRole: Equatable {
    let rolesIds: [String]?
    let otherText: String?
}

struct UserInsight {
    var tsFirstRead: Timestamp?
    var tsRead: Timestamp?
    var feedback: UserFeedback?
}

struct UserReportStatus {
    var tsFirstRead: Timestamp?
    var tsRead: Timestamp?
}

struct UserFeedback {
    var rating: Int?
    var reason: FeedbackAnswer?
    var otherReasonText: String?
}

enum UserSubscriptionType: String, Decodable {
    case valleyInsightsPanda = "panda",
         valleyInsightsAerial = "aerial"
}
