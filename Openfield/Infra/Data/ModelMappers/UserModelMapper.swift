//
//  UserModelMapper.swift
//  Openfield
//
//  Created by Daniel Kochavi on 13/12/2019.
//  Copyright © 2019 Prospera. All rights reserved.
//

import Foundation

struct UserModelMapper {
    func map(userServerModel: UserServerModel) -> User {
        let userRole = userServerModel.settings?.user_role == nil ? nil : UserRole(rolesIds: userServerModel.settings?.user_role?.roles, otherText: userServerModel.settings?.user_role?.other_text)

        return User(email: userServerModel.email,
                    firstName: userServerModel.first_name,
                    id: String(userServerModel.id),
                    lastName: userServerModel.last_name,
                    phone: userServerModel.phone,
                    username: userServerModel.username,
                    isOwner: userServerModel.is_owner ?? false,
                    insights: map(insights: userServerModel.insights ?? [:]),
                    userReports: map(userReports: userServerModel.user_reports ?? [:]),
                    settings: UserSettings(notificationsEnabled: userServerModel.settings?.notifications_enabled ?? false,
                                           notificationsPush: userServerModel.settings?.notifications_types.contains(NotificationType.push.rawValue) ?? false,
                                           notificationsSms: userServerModel.settings?.notifications_types.contains(NotificationType.sms.rawValue) ?? false, languageCode: userServerModel.settings?.language_code, seenRolePopUp: userServerModel.settings?.ts_seen_role_popup, seenFieldTooltip: userServerModel.settings?.ts_seen_field_tooltip,
                                           userRole: userRole),
                    tracking: UserTracking(insightsFirstReadWithoutFeedback: userServerModel.tracking?.insights_first_read_without_feedback ?? 0,
                                           tsFeedbackPopupLastShown: userServerModel.tracking?.ts_feedback_popup_last_shown?.dateValue(),
                                           tsSawComparePopup: userServerModel.tracking?.ts_saw_compare_popup?.dateValue(),
                                           insightsReadWithoutOpeningCard: userServerModel.tracking?.insights_read_without_opening_card ?? 0,
                                           tsCardTooltipLastShown: userServerModel.tracking?.ts_card_tooltip_last_shown?.dateValue(),
                                           tsCardFirstOpen: userServerModel.tracking?.ts_card_first_open?.dateValue(),
                                           tsSawSubscribePopUp: userServerModel.tracking?.ts_saw_subscribe_popup?.dateValue(),
                                           tsClickedSubscribePopUp: userServerModel.tracking?.ts_clicked_subscribe_popup?.dateValue(),
                                           signedContractVersion: userServerModel.tracking?.signed_contract_version,
                                           seenContractVersion: userServerModel.tracking?.seen_contract_version,
                                           tsSeenContract: userServerModel.tracking?.ts_seen_contract?.dateValue()),
                    subscriptionTypes: userServerModel.subscription_types?.compactMap { map(subscriptionType: $0) } ?? [])
    }

    private func map(insights: [Int: UserInsightServerModel]) -> [Int: UserInsight] {
        var result: [Int: UserInsight] = [:]
        for (id, insight) in insights {
            result[id] = UserInsight(
                tsFirstRead: insight.ts_first_read,
                tsRead: insight.ts_read,
                feedback: UserFeedback(
                    rating: insight.feedback?.rating,
                    reason: insight.feedback?.reason,
                    otherReasonText: insight.feedback?.other_reason
                )
            )
        }
        return result
    }

    private func map(userReports: [Int: UserReportStatusServerModel]) -> [Int: UserReportStatus] {
        var result: [Int: UserReportStatus] = [:]
        for (id, report) in userReports {
            result[id] = UserReportStatus(
                tsFirstRead: report.ts_first_read,
                tsRead: report.ts_read
            )
        }
        return result
    }

    private func map(subscriptionType: String) -> UserSubscriptionType? {
        if let type = UserSubscriptionType(rawValue: subscriptionType) {
            return type
        } else {
            log.warning("Subscription type \(subscriptionType) dropped")
            return nil
        }
    }
}
