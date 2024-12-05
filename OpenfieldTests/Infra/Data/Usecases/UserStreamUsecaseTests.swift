//
//  UserStreamUsecaseTests.swift
//  OpenfieldTests
//
//  Created by Yoni Luz on 09/01/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import XCTest
import Cuckoo
import RxSwift
@testable import Openfield

final class UserStreamUsecaseTests: XCTestCase {
    
    private var mockUserRepository: MockUserRepositoryProtocol!
    private var mockUserModelMapper: UserModelMapper!
    
    override func setUpWithError() throws {
        mockUserRepository = MockUserRepositoryProtocol()
        mockUserModelMapper = UserModelMapper()
    }
    
    func testUserStreamCreation() {
        
        // Set up and mock behavior
        let mockUserSM = UserServerModel(
            email: "test@example.com",
            first_name: "John",
            id: 123,
            last_name: "Doe",
            phone: "123456789",
            username: "johndoe",
            insights: nil,
            user_reports: nil,
            settings: nil,
            tracking: nil,
            is_owner: true,
            subscription_types: ["aerial"]
        )
        stub(mockUserRepository) { mock in
            when(mock.createUserStream()).thenReturn(Observable.just(mockUserSM))
        }
        
        let userStreamUsecase = UserStreamUsecase(
            userRepository: mockUserRepository,
            userMapper: mockUserModelMapper
        )
        
        // Act
        var receivedUser: Openfield.User? = nil
        let disposeBag = DisposeBag()
        _ = userStreamUsecase.userStream().subscribe(onNext: { user in
            receivedUser = user
        })
        .disposed(by: disposeBag)
        
        // Assert
        XCTAssertNotNil(receivedUser)
        XCTAssertEqual(receivedUser?.phone, UserStreamUsecaseTests.expectedUser.phone)
        
        // Verify that createUserStream method was called on mockUserRepository
        verify(mockUserRepository).createUserStream()
    }
    
    private static let userSettings = UserSettings(notificationsEnabled: true,
                                                   notificationsPush: true,
                                                   notificationsSms: false,
                                                   languageCode: "en",
                                                   seenRolePopUp: nil,
                                                   seenFieldTooltip: nil,
                                                   userRole: nil)
    
    private static let userTracking = UserTracking(
        insightsFirstReadWithoutFeedback: 5,
        tsFeedbackPopupLastShown: nil,
        tsSawComparePopup: nil,
        insightsReadWithoutOpeningCard: 3,
        tsCardTooltipLastShown: nil,
        tsCardFirstOpen: nil,
        tsSawSubscribePopUp: nil,
        tsClickedSubscribePopUp: nil,
        signedContractVersion: 1.2,
        seenContractVersion: nil,
        tsSeenContract: nil
    )
    
    static let expectedUser = User(email: "test@example.com", firstName: "John", id: "123", lastName: "Doe", phone: "123456789", username: "johndoe", isOwner: true, insights: [Int : UserInsight](), userReports: [Int : UserReportStatus](), settings: userSettings, tracking: userTracking, subscriptionTypes: [UserSubscriptionType.valleyInsightsAerial])
    
}
