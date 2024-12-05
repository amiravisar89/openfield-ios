//
//  AccountViewReactor.swift
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

final class AccountViewReactor: Reactor {
    let disposeBag = DisposeBag()
    let authInteractor: AuthInteractor
    let languageService: LanguageService
    var initialState: State
    let updateUserParamsUsecase: UpdateUserParamsUsecaseProtocol
    let userUseCase: UserStreamUsecaseProtocol
    let getHelpCenterUrlUseCase: GetHelpCenterUrlUseCaseProtocol

    init(authInteractor: AuthInteractor, languageService: LanguageService, userUseCase: UserStreamUsecaseProtocol, updateUserParamsUsecase: UpdateUserParamsUsecaseProtocol, getHelpCenterUrlUseCase: GetHelpCenterUrlUseCaseProtocol) {
        self.languageService = languageService
        self.authInteractor = authInteractor
        self.userUseCase = userUseCase
        self.updateUserParamsUsecase = updateUserParamsUsecase
        self.getHelpCenterUrlUseCase = getHelpCenterUrlUseCase
        initialState = State()

        self.languageService
            .currentLanguage.take(1)
            .map { Action.setUserLanguage(language: $0) }
            .bind(to: action)
            .disposed(by: disposeBag)

        self.userUseCase
            .userStream()
            .map { Action.setUserData(user: $0, extUser: Defaults.extUser) }
            .bind(to: action)
            .disposed(by: disposeBag)
    }

    enum Action {
        case nothing
        case setUserData(user: User, extUser: ExtUser?)
        case changeNotificationState(to: Bool)
        case updateUserRole(role: UserRole)
        case updateUserSeenRole
        case flipNotificationState(disableDialog: () -> Void)
        case showYourRollView(yourRollDialog: () -> Void)
        case showLanguagePopup(show: () -> Void)
        case setUserLanguage(language: LanguageData)
        case updateUserLanguage(language: LanguageData, splashNavigation: () -> Void)
        case logOut(navigation: () -> Void)
        case showLogoutPopup(logoutConfirmationDialog: () -> Void)
        case clickedTeamCell(navigation: (URL) -> Void)
        case changedNotificationType
        case goToHelpCenter(navigation: (URL) -> Void)
    }

    enum Mutation {
        case setUser(user: User, extUser: ExtUser)
        case setUserLanguage(language: LanguageData)
        case unChange
    }

    struct State: Then {
        var user: User?
        var userLanguage: LanguageData?
        var extUser: ExtUser?
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .setUserData(user, extUser):
            return extUser != nil ? Observable.just(Mutation.setUser(user: user, extUser: extUser!)) : Observable.just(Mutation.unChange)

        case let .flipNotificationState(disableDialog):
            var settings = currentState.user!.settings
            let newNotificationStateEnabled = !settings.notificationsEnabled
            EventTracker.track(event: AnalyticsEventFactory.buildEvent(EventCategory.settingsNotifications, .toggleNotifications, [EventParamKey.value: newNotificationStateEnabled ? "on" : "off"]))
            if !newNotificationStateEnabled {
                disableDialog()
            } else {
              guard let user = currentState.user else {return .empty()}
                settings.notificationsEnabled = newNotificationStateEnabled
                return updateUserParamsUsecase
                    .changeUserNotifications(user: user, settings: settings)
                    .map { _ in Mutation.unChange }
            }
            return Observable.just(Mutation.unChange)

        case let .changeNotificationState(enabled):
            guard let user = currentState.user else {return .empty()}
            var settings = user.settings
            settings.notificationsEnabled = enabled
            if !enabled {
                EventTracker.track(event: AnalyticsEventFactory.buildEvent(EventCategory.settingsNotifications, .notificationsConfirmOk))
            } else {
                EventTracker.track(event: AnalyticsEventFactory.buildEvent(EventCategory.settingsNotifications, .notificationsConfirmCancel))
            }
            let result = updateUserParamsUsecase
                .changeUserNotifications(user: user, settings: settings)
                .map { _ in Mutation.unChange }
            return result

        case let .showYourRollView(youRollDoialog):
            EventTracker.track(event: AnalyticsEventFactory.buildClickEvent(EventCategory.settingsLogout, "your_roll"))
            youRollDoialog()
            return Observable.just(Mutation.unChange)

        case .changedNotificationType:
            guard let user = currentState.user else { return Observable.empty() }
            var settings = user.settings
            settings.notificationsPush = !settings.notificationsPush
            EventTracker.track(event: AnalyticsEventFactory.buildEvent(EventCategory.settingsNotifications, .toggleNotificationsType, [EventParamKey.value: settings.notificationsPush ? "push" : "sms"]))
            let result = updateUserParamsUsecase
                .changeUserNotifications(user: user, settings: settings)
                .map { _ in Mutation.unChange }
            return result

        case let .logOut(navigation):
            return updateUserParamsUsecase
                .clearUser()
                .flatMap { [weak self] _ -> Observable<Bool> in
                  guard let self = self else {return .empty()}
                  return self.authInteractor.logoutFormFirebase()
                }
                .delay(.milliseconds(300), scheduler: MainScheduler.instance)
                .do(onCompleted: { 
                    EventTracker.track(event: AnalyticsEventFactory.buildEvent(EventCategory.settingsLogout, .logoutConfirmOk))
                  navigation()
                })
                .flatMap { _ in
                  Observable.empty()
                }
        case let .showLogoutPopup(logoutConfirmationDialog):
            EventTracker.track(event: AnalyticsEventFactory.buildClickEvent(EventCategory.settingsLogout, "settings_logout"))
            logoutConfirmationDialog()
            return Observable.just(Mutation.unChange)

        case let .clickedTeamCell(navigation):
            EventTracker.track(event: AnalyticsEventFactory.buildClickEvent(EventCategory.settingsTeam, "settings_account"))
            if let url: URL = URL(string: ConfigEnvironment.valueFor(key: .accountURL)) {
                navigation(url)
            } else {
                log.warning("No team url link found, can't navigate")
            }
            return Observable.just(Mutation.unChange)
        case let .updateUserRole(role: role):
            let result = updateUserParamsUsecase.changeUserRole(user: currentState.user!, role: role).map { _ in Mutation.unChange }
            return result
        case .updateUserSeenRole:
            let result = updateUserParamsUsecase.updateUserRoleSeen(user: currentState.user!, timeStamp: Date())
                .map { _ in Mutation.unChange }
            return result
        case let .showLanguagePopup(show: show):
            show()
            return Observable.empty()
        case let .updateUserLanguage(language: language, splashNavigation: navigation):
            languageService.setLanguage(languageCode: language.locale.identifier)
            return updateUserParamsUsecase
                .updateUserLanguage(language: language)
                .delay(.milliseconds(300), scheduler: MainScheduler.instance)
                .do(onNext: { _ in
                  navigation()
                })
                .map { _ in Mutation.setUserLanguage(language: language) }

        case let .setUserLanguage(language: language):
            return Observable.just(Mutation.setUserLanguage(language: language))

        case let .goToHelpCenter(navigation: navigation):
          EventTracker.track(event: AnalyticsEventFactory.buildClickEvent(EventCategory.settingsHelp, "settings_help"))
          let supportURL = getHelpCenterUrlUseCase.getUrl()
          navigation(supportURL)
          return Observable.empty()

        case .nothing:
          return .empty()
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
        case let .setUserLanguage(language: language):
            var newState: State = state
            newState.userLanguage = language
            return newState
        }
    }
  
}
