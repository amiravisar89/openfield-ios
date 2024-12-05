//
//  UserFaker.swift
//  Openfield
//
//  Created by amir avisar on 02/05/2022.
//  Copyright © 2022 Prospera. All rights reserved.
//

import Fakery
import Foundation

class UserFaker: FakerProvider {
    let faker: Faker

    init(faker: Faker) {
        self.faker = faker
    }

    func createUser() -> User {
        return User(email: "test@prospera.ag",
                    firstName: "test",
                    id: "9999999",
                    lastName: "qa",
                    phone: "+972544444444",
                    username: "test",
                    isOwner: false,
                    insights: [:],
                    userReports: [:],
                    settings: UserSettings(notificationsEnabled: false, notificationsPush: false, notificationsSms: false, userRole: UserRole(rolesIds: [], otherText: nil)),
                    tracking: UserTracking(insightsFirstReadWithoutFeedback: 0,
                                           tsFeedbackPopupLastShown: nil,
                                           tsSawComparePopup: Date(),
                                           insightsReadWithoutOpeningCard: 0,
                                           tsCardTooltipLastShown: nil,
                                           signedContractVersion: 1.0,
                                           seenContractVersion: 1.0,
                                           tsSeenContract: Date()),
                    subscriptionTypes: [])
    }
}

class MockUserFakerContractVersionLow: UserFaker {
    override func createUser() -> User {
        var user = super.createUser()
        user.tracking.signedContractVersion = 1.0
        return user
    }
}

class MockUserFakerContractVersionEqual: UserFaker {
    override func createUser() -> User {
        var user = super.createUser()
        user.tracking.signedContractVersion = 2.0
        return user
    }
}
