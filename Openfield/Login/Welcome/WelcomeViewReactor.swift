//
//  WelcomeViewReactor.swift
//  Openfield
//
//  Created by Yoni Luz on 22/07/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import RxSwift
import ReactorKit
import Resolver
import Then

class WelcomeViewReactor: Reactor {

    var disposeBag: DisposeBag = .init()
    let languageService: LanguageService
    let getSupportUrlUseCase : GetSupportUrlUseCaseProtocol

    var initialState: State

    init(languageService: LanguageService, getSupportUrlUseCase : GetSupportUrlUseCaseProtocol) {
        self.languageService = languageService
        self.getSupportUrlUseCase = getSupportUrlUseCase
        initialState = State(userLanguage: LanguageService.defaultLanguage)
        Resolver.cached.reset()
        self.languageService
            .currentLanguage
            .map { Action.setUserLanguage(language: $0) }
            .bind(to: action)
            .disposed(by: disposeBag)
    }

    enum Action {
        case setUserLanguage(language: LanguageData)
        case updateUserLanguage(language: LanguageData, splashNavigation: () -> Void)
        case navigateToLogin(navigate: () -> Void)
        case clickSubscription(navigation: (URL) -> Void)
        case showLanguagePopup(show: () -> Void)
        case goToSupport(navigation: (URL) -> Void)
        case nothing
    }

    enum Mutation {
        case setUserLanguage(language: LanguageData)

    }

    struct State: Then {
        var userLanguage: LanguageData
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .updateUserLanguage(let language, let navigation):
            EventTracker.track(event: AnalyticsEventFactory.buildClickEvent(EventCategory.welcome, "update_user_language", ["from_language": currentState.userLanguage.name, "to_language": language.name]))
            languageService.setLanguage(languageCode: language.locale.identifier)
            navigation()
            return Observable.empty()

        case .setUserLanguage(let language):
            return Observable.just(Mutation.setUserLanguage(language: language))
        case let .navigateToLogin(navigate):
            EventTracker.track(event: AnalyticsEventFactory.buildEvent(EventCategory.welcome, .navigateToLogin))
            navigate()
            return .empty()
        case let .clickSubscription(navigation):
            EventTracker.track(event: AnalyticsEventFactory.buildClickEvent(EventCategory.welcome, "click_subscription"))
            if let url: URL = URL(string: ConfigEnvironment.valueFor(key: .subscriptionURL)) {
                navigation(url)
            } else {
                log.warning("No subscription url link found, can't navigate")
            }
            return .empty()
        case let .showLanguagePopup(show: show):
            EventTracker.track(event: AnalyticsEventFactory.buildDialogEvent(EventCategory.welcome, "language_selection", true))
            show()
            return .empty()
        case let .goToSupport(navigation: navigation):
            EventTracker.track(event: AnalyticsEventFactory.buildClickEvent(EventCategory.welcome, "go_to_support"))
            let supportURL = getSupportUrlUseCase.url()
            navigation(supportURL)
            return Observable.empty()
        case .nothing:
          return Observable.empty()
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        switch mutation {
        case .setUserLanguage(let language):
            return state.with {
                $0.userLanguage = language
            }
        }
    }

}
