//
//  ContainerViewReactor.swift
//  Openfield
//
//  Created by Eyal Prospera on 23/12/2019.
//  Copyright © 2019 Prospera. All rights reserved.
//

import Foundation
import ReactorKit
import Resolver
import RxCocoa
import RxSwift
import SwiftyUserDefaults
import Then

final class ContainerViewReactor: Reactor {
    let disposeBag = DisposeBag()
    var initialState: State
    var updateUserParamsUsecase: UpdateUserParamsUsecaseProtocol
    let userStreamUseCase : UserStreamUsecase
    let farmFilter: FarmFilterProtocol
    let allFarmsUseCase: GetAllFarmsUseCaseProtoocol

    init(farmFilter: FarmFilterProtocol, userStreamUseCase : UserStreamUsecase, allFarmsUseCase: GetAllFarmsUseCaseProtoocol, updateUserParamsUsecase: UpdateUserParamsUsecaseProtocol) {
        self.farmFilter = farmFilter
        self.userStreamUseCase = userStreamUseCase
        self.allFarmsUseCase = allFarmsUseCase
        self.updateUserParamsUsecase = updateUserParamsUsecase
      
        initialState = State(farms: [], farmFilters: [])

        self.userStreamUseCase
            .userStream()
            .map { Action.setUserData(user: $0, extUser: Defaults.extUser) }
            .bind(to: action)
            .disposed(by: disposeBag)

        self.allFarmsUseCase
            .farms()
            .map { Action.setFarms(farms: $0) }
            .bind(to: action)
            .disposed(by: disposeBag)

        self.farmFilter
            .farms
            .map { Action.setFarmFilters(farms: $0) }
            .bind(to: action)
            .disposed(by: disposeBag)
    }

    enum Action {
        case setUserData(user: User, extUser: ExtUser?)
        case checkNotificationPermissionState(askPermissionDialog: () -> Void)
        case setFarms(farms: [Farm])
        case setFarmFilters(farms: [FilteredFarm])
        case changedNotificationType
    }

    enum Mutation {
        case setUser(user: User, extUser: ExtUser)
        case setFarms(farms: [Farm])
        case setFarmFilters(farms: [FilteredFarm])
        case unChange
    }

    struct State: Then {
        var user: User?
        var extUser: ExtUser?
        var farms: [Farm]
        var farmFilters: [FilteredFarm]
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .setUserData(user, extUser):
            return extUser != nil ? Observable.just(Mutation.setUser(user: user, extUser: extUser!)) : Observable.just(Mutation.unChange)

        case .changedNotificationType:
            guard let user = currentState.user else { return Observable.empty() }
            var settings = user.settings
            settings.notificationsPush = !settings.notificationsPush
            EventTracker.track(event: AnalyticsEventFactory.buildEvent(EventCategory.settingsNotifications, .toggleNotificationsType, [EventParamKey.value: settings.notificationsPush ? "push" : "sms"]))
            let result = updateUserParamsUsecase
                .changeUserNotifications(user: user, settings: settings)
                .map { _ in Mutation.unChange }
            return result

        case let .checkNotificationPermissionState(askPermissionDialog):
            guard let user = currentState.user else { return Observable.empty() }
            let isNotificationEnbled = user.settings.notificationsEnabled
            let currentNotificationTypeIsPush = user.settings.notificationsPush
            if isNotificationEnbled && currentNotificationTypeIsPush {
                UNUserNotificationCenter.current().getNotificationSettings(completionHandler: { settings in
                    if settings.authorizationStatus == .denied || settings.authorizationStatus == .notDetermined {
                        askPermissionDialog()
                    } else {
                        log.info("Notification permission state is: \(settings.authorizationStatus)")
                    }
                })
            }
            return Observable.just(Mutation.unChange)
        case let .setFarms(farms: farms):
            return Observable.just(Mutation.setFarms(farms: farms))
        case let .setFarmFilters(farms: farms):
            return Observable.just(Mutation.setFarmFilters(farms: farms))
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        switch mutation {
        case let .setUser(user, extUser):
            var newState: State = state
            newState.user = user
            newState.extUser = extUser
            return newState

        case .unChange:
            let newState: State = state
            return newState
        case let .setFarms(farms: farms):
            var newState: State = state
            newState.farms = farms
            return newState
        case let .setFarmFilters(farms: farms):
            var newState: State = state
            newState.farmFilters = farms
            return newState
        }
    }
}
