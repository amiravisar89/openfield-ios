//
//  LoginViewReactor.swift
//  Openfield
//
//  Created by Eyal Prospera on 05/01/2020.
//  Copyright © 2020 Prospera. All rights reserved.
//

import Foundation
import PhoneNumberKit
import ReactorKit
import Resolver
import RxCocoa
import RxSwift
import SwiftyUserDefaults
import Then

final class LoginViewReactor: Reactor {
    var disposeBag: DisposeBag = .init()
    var initialState: State
    let authAdapter: RxMoyaAdapter<AuthMoyaTarget>
    let authInteractor: AuthInteractor
    let smartLookProvider: SmartLookProvider
    let featureFlagManager: FeatureFlagManager
    let updateUserParamsUsecase : UpdateUserParamsUsecaseProtocol
    private let featureFlagRepository: FeatureFlagsRepositoryProtocol
    private let impersonationFeatureFlag: FeatureFlagProtocol

    init(smartLookProvider: SmartLookProvider, authAdapter: RxMoyaAdapter<AuthMoyaTarget>, authInteractor: AuthInteractor, featureFlagManager: FeatureFlagManager, featureFlagRepository: FeatureFlagsRepositoryProtocol, impersonationFeatureFlag: FeatureFlagProtocol, updateUserParamsUsecase : UpdateUserParamsUsecaseProtocol) {
        self.smartLookProvider = smartLookProvider
        self.updateUserParamsUsecase = updateUserParamsUsecase
        self.authAdapter = authAdapter
        self.authInteractor = authInteractor
        self.featureFlagManager = featureFlagManager
        self.featureFlagRepository = featureFlagRepository
        self.impersonationFeatureFlag = impersonationFeatureFlag
        let enterPhoneState = EnterPhoneState(prefixPhone: "+1", isPhoneLoading: false, isPhoneEnabled: true)
        let impersonationState = ImpersonationState(prefixPhone: "+1")
        initialState = State(page: .phone, enterPhoneState: enterPhoneState, impersonationState: impersonationState)
    }

    enum Action {
        case navigateBackward
        case navigateToApp(doneNavigation: () -> Void)
        case sendSMS
        case resendSms
        case numberPressed(key: String, doneNavigation: () -> Void)
        case deletePressed
        case login(doneNavigation: () -> Void)
        case onAuthSuccess(userId: Int, doneNavigation: () -> Void)
        case phonePrefixPopup(effect: () -> Void)
        case changePhonePrefix(newPrefix: String)
        case changePhoneImpersonationPrefix(newPrefix: String)
        case getFirebaseToken(doneNavigation: () -> Void)
        case authWithFirebase(token: String, doneNavigation: () -> Void)
        case impersonate(doneNavigation: () -> Void)
        case loginAsYourself(doneNavigation: () -> Void)
    }

    enum Mutation {
        case unChange
        case setPage(page: LoginPage)
        case setPhoneNumber(key: String)
        case addCodeDigit(digit: String)
        case deleteLastNumber
        case deleteLastCode
        case setPhoneErrorMessage(errorMessage: String)
        case setPhoneLoadingStatus(status: Bool)

        case setPhoneImpersonationPrefix(newPrefix: String)
        case setPhoneImpersonationNumber(key: String)
        case deleteLastImpersonationNumber
        case setPhoneImpersonationErrorMessage(errorMessage: String)
        case setPhoneImpersonationLoadingStatus(status: Bool)
        case setSkipImpersonationLoadingStatus(status: Bool)
        case clearPhoneImpersonationErrors
        case clearImpersonationPhone

        case setAuthCodeLoadingIndication(isLoading: Bool)
        case setResendCodeLoadingIndication(isLoading: Bool)
        case authErrorState(errorMessage: String)
        case clearEnterCodeErrors
        case clearPhoneErrors
        case setPhonePrefix(newPrefix: String)
        case setUser(extUser: ExtUser)
        case setFirebaseToken(firebaseToken: String)
        case authSuccess
        case clearCode
        case clearPhone
        case setIsImpersonation
    }

    struct EnterPhoneState {
        var prefixPhone: String
        var suffixPhone: String = ""
        var phoneErrorMessage: String = ""
        var isPhoneLoading: Bool
        var isPhoneEnabled: Bool
    }

    struct EnterCodeState {
        var authCode: [String] = []
        var authCodeIsLoading: Bool = false
        var resendCodeIsLoading: Bool = false
        var authCodeIsLoginButtonEnabled: Bool = false
        var authCodeError: String = ""
    }
    
    struct ImpersonationState {
        var prefixPhone: String
        var suffixPhone: String = ""
        var errorMessage: String = ""
        var isImpersonateLoading: Bool = false
        var isImpersonateEnabled: Bool = true
        var isSkipLoading: Bool = false
        var isSkipEnabled: Bool = true
    }

    struct State: Then {
        var page: LoginPage
        var extUser: ExtUser?
        var firebaseToken: String?
        var enterCodeState: EnterCodeState = .init()
        var enterPhoneState: EnterPhoneState
        var impersonationState: ImpersonationState

        var isAuthenticated: Bool = false
        var fullPhoneNumber: String {
            return enterPhoneState.prefixPhone + enterPhoneState.suffixPhone
        }

        var fullPhoneImpersonationNumber: String {
            return impersonationState.prefixPhone + impersonationState.suffixPhone
        }

        var fullAuthCode: String {
            return enterCodeState.authCode.joined(separator: "")
        }

        var isLoading: Bool {
            return enterPhoneState.isPhoneLoading || enterCodeState.authCodeIsLoading || enterCodeState.resendCodeIsLoading || impersonationState.isImpersonateLoading || impersonationState.isSkipLoading
        }
        var isImpersonation: Bool = false
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .changePhonePrefix(newPrefix):
            return Observable.just(Mutation.setPhonePrefix(newPrefix: newPrefix))

        case let .phonePrefixPopup(effect):
            EventTracker.track(event: AnalyticsEventFactory.buildDialogEvent(EventCategory.countrySelection, PhonePrefixPickerViewController.analyticsName, true))
            effect()
            return Observable.just(Mutation.unChange)

        case .navigateBackward:
            let newPage: LoginPage = getBackwardPage()
            var clearDataMutation: Mutation = .unChange
            var clearErrorMutation: Mutation = .unChange

            switch newPage {
            case .phone:
                clearDataMutation = .clearCode
                clearErrorMutation = .clearEnterCodeErrors
            case .code:
                clearDataMutation = .clearImpersonationPhone
                clearErrorMutation = .clearPhoneImpersonationErrors
            default:
                clearDataMutation = .unChange
                clearErrorMutation = .unChange
            }

            return Observable.concat(
                Observable.just(.setPage(page: newPage)),
                Observable.just(clearDataMutation),
                Observable.just(clearErrorMutation)
            )

        case let .numberPressed(key, doneNavigation):
            return handleNumberPressed(key: key, doneNavigation: doneNavigation)

        case .deletePressed:
            return handleDeletePressed()

        case let .login(doneNavigation):
            EventTracker.track(event: AnalyticsEventFactory.buildClickEvent(EventCategory.loginCode, "login"))
            trackLoginTimestamp()
            let loginResponse = buildLoginMutation(authCode: currentState.fullAuthCode, doneNavigation: doneNavigation)

            let loadingIndication = Observable.just(Mutation.setAuthCodeLoadingIndication(isLoading: true))

            let clearErrorMutationObs = Observable.just(Mutation.clearEnterCodeErrors)

            return Observable.concat(clearErrorMutationObs, loadingIndication, loginResponse)

        case .resendSms:
            EventTracker.track(event: AnalyticsEventFactory.buildEvent(EventCategory.resendCode,
                                                                       .textLinkClick, [EventParamKey.itemId: "resend_code"]))
            let setCodeLoadingObs = Observable.just(Mutation.setResendCodeLoadingIndication(isLoading: true))
            let clearErrorMutationObs = Observable.just(Mutation.clearEnterCodeErrors)
            let clearCodeMutation = Observable.just(Mutation.clearCode)
            let authObs = authInteractor.sendCode(phoneNumber: currentState.fullPhoneNumber)
                .map { _ in Mutation.setResendCodeLoadingIndication(isLoading: false) }
                .catchError { _ in
                    EventTracker.track(event: AnalyticsEventFactory.buildErrorEvent(EventCategory.resendCode, "general_error"))
                    return Observable.just(Mutation.authErrorState(errorMessage: R.string.localizable.loginErrorsDefault_2_lines()))
                }
            return Observable.concat(setCodeLoadingObs, clearErrorMutationObs, clearCodeMutation, authObs)

        case .sendSMS:
            let setLoadingObs = Observable.just(Mutation.setPhoneLoadingStatus(status: true))
            let authObs = authInteractor.sendCode(phoneNumber: currentState.fullPhoneNumber)
                .map { _ in Mutation.setPage(page: .code) }
                .catchError { [weak self] error in
                    guard let self = self,
                          let error = error as? PhoneNumberError else { return Observable.empty() }
                    return self.handlePhoneNumerErrors(phoneNumberError: error)
                }
                .concat(Observable.just(Mutation.setPhoneLoadingStatus(status: false)))
            let clearPhoneError = Observable.just(Mutation.setPhoneErrorMessage(errorMessage: ""))
            return Observable.concat(clearPhoneError, setLoadingObs, authObs)

        case let .getFirebaseToken(doneNavigation):
            return authInteractor.getFirebaseToken()
            .do(onNext: { self.action.onNext(Action.authWithFirebase(token: $0, doneNavigation: doneNavigation)) })
                .map { LoginViewReactor.Mutation.setFirebaseToken(firebaseToken: $0) }
                .catchError { _ in
                    EventTracker.track(event: AnalyticsEventFactory.buildErrorEvent(EventCategory.loginCode, "general_error"))
                    return Observable.just(Mutation.authErrorState(errorMessage: R.string.localizable.loginErrorsDefault_2_lines()))
                }

        case let .authWithFirebase(token, doneNavigation):
            return authInteractor.authWithFirebase(token: token)
            .do(onNext: { _ in self.action.onNext(Action.onAuthSuccess(userId: self.currentState.extUser!.id, doneNavigation: doneNavigation)) })
                .map { _ in LoginViewReactor.Mutation.authSuccess }
                .catchError { _ in
                    EventTracker.track(event: AnalyticsEventFactory.buildErrorEvent(EventCategory.loginCode, "general_error"))
                    return Observable.just(Mutation.authErrorState(errorMessage: R.string.localizable.loginErrorsDefault_2_lines()))
                }

        case let .onAuthSuccess(userId, doneNavigation):
            let extUser: ExtUser? = currentState.extUser
            
            updateUserParamsUsecase.setUser(id: userId, extUser: extUser)
            return updateUserParamsUsecase.updateUserDevice(refreshToken: true, clearToken: false, isLogin: true)
                .flatMap { _ -> Observable<Mutation> in
                    .just(.authSuccess)
                }
                .do(onNext: { _ in
                    Resolver.cached.reset()
                  self.action.onNext(.navigateToApp(doneNavigation: doneNavigation))
                })
                .catchError { [weak self] _ in
                    if self?.currentState.isImpersonation == true {
                        self?.action.onNext(.navigateToApp(doneNavigation: doneNavigation))
                    }
                    return .empty()
                }
        case let .impersonate(doneNavigation):
            let phoneNumber = currentState.fullPhoneImpersonationNumber
            EventTracker.track(event: AnalyticsEventFactory.buildClickEvent(EventCategory.impersonation, "impersonation"))
            let impersonateResponse = authInteractor.impersonate(phoneNumber: phoneNumber)
            .do(onNext: { self.action.onNext(Action.authWithFirebase(token: $0.token, doneNavigation: doneNavigation)) })
                .flatMap { [weak self] userWithToken in
                    guard let self = self else {
                        return Observable.just(Mutation.authErrorState(errorMessage: R.string.localizable.loginErrorsDefault_2_lines()))
                    }
                    Resolver.cached.reset()
                    Defaults.impersonatorId = self.currentState.extUser?.id
                    return Observable.concat(
                        .just(Mutation.setIsImpersonation),
                        .just(Mutation.setFirebaseToken(firebaseToken: userWithToken.token)),
                        .just(Mutation.setUser(extUser: userWithToken.extUser))
                    )
                }
                .catchError { self.handleLoginErrors(loginError: $0 as! LoginError) }

            let loadingIndication = Observable.just(Mutation.setPhoneImpersonationLoadingStatus(status: true))
            let clearErrorMutationObs = Observable.just(Mutation.clearEnterCodeErrors)
            return Observable.concat(clearErrorMutationObs, loadingIndication, impersonateResponse)
        case let .loginAsYourself(doneNavigation):
            EventTracker.track(event: AnalyticsEventFactory.buildClickEvent(EventCategory.impersonation, "skip_impersonation"))
          self.action.onNext(Action.getFirebaseToken(doneNavigation: doneNavigation))
            return .just(Mutation.setSkipImpersonationLoadingStatus(status: true))
        case .changePhoneImpersonationPrefix(newPrefix: let newPrefix):
            return Observable.just(Mutation.setPhoneImpersonationPrefix(newPrefix: newPrefix))
        case .navigateToApp(doneNavigation: let doneNavigation):
          doneNavigation()
          return .empty()
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        switch mutation {
        case .unChange:
            let newState: State = state
            return newState
        case let .setPhonePrefix(newPrefix):
            var newState: State = state
            newState.enterPhoneState.prefixPhone = newPrefix
            return newState
        case let .setPage(page):
            var newState: State = state
            newState.page = page
            return newState
        case let .setPhoneNumber(key):
            var newState: State = state
            newState.enterPhoneState.suffixPhone = newState.enterPhoneState.suffixPhone + key
            return newState
        case .deleteLastNumber:
            var newState: State = state
            newState.enterPhoneState.suffixPhone = String(newState.enterPhoneState.suffixPhone.dropLast())
            return newState
        case let .addCodeDigit(digit):
            var newState: State = state
            newState.enterCodeState.authCode.append(digit)
            return newState
        case .deleteLastCode:
            return state.with {
                $0.enterCodeState.authCode.removeLast()
                $0.enterCodeState.authCodeIsLoginButtonEnabled = false
            }
        case .clearCode:
            var newState: State = state
            newState.enterCodeState.authCode.removeAll()
            return newState
        case .clearPhone:
            return state.with {
                $0.enterPhoneState.suffixPhone = ""
            }
        case let .setPhoneErrorMessage(errorMessage):
            return state.with {
                $0.enterPhoneState.phoneErrorMessage = errorMessage
            }
        case let .setPhoneLoadingStatus(status):
            return state.with {
                $0.enterPhoneState.isPhoneLoading = status
                $0.enterPhoneState.isPhoneEnabled = !status
            }
        case .deleteLastImpersonationNumber:
            var newState: State = state
            newState.impersonationState.suffixPhone = String(newState.impersonationState.suffixPhone.dropLast())
            return newState
        case let .setPhoneImpersonationNumber(key):
            var newState: State = state
            newState.impersonationState.suffixPhone = newState.impersonationState.suffixPhone + key
            return newState
        case let .setPhoneImpersonationPrefix(newPrefix):
            var newState: State = state
            newState.impersonationState.prefixPhone = newPrefix
            return newState
        case .clearImpersonationPhone:
            return state.with {
                $0.impersonationState.suffixPhone = ""
            }
        case let .setPhoneImpersonationErrorMessage(errorMessage):
            return state.with {
                $0.impersonationState.errorMessage = errorMessage
            }
        case let .setPhoneImpersonationLoadingStatus(status):
            return state.with {
                $0.impersonationState.isImpersonateLoading = status
                $0.impersonationState.isImpersonateEnabled = !status
                $0.impersonationState.isSkipEnabled = !status
            }
        case let .setSkipImpersonationLoadingStatus(status):
            return state.with {
                $0.impersonationState.isSkipLoading = status
                $0.impersonationState.isSkipEnabled = !status
                $0.impersonationState.isImpersonateEnabled = !status
            }
        case .clearPhoneImpersonationErrors:
            return state.with {
                $0.impersonationState.errorMessage = ""
            }
        case let .setAuthCodeLoadingIndication(isLoading):
            return state.with {
                $0.enterCodeState.authCodeIsLoading = isLoading
                if isLoading {
                    $0.enterCodeState.authCodeIsLoginButtonEnabled = true
                }
            }
        case let .authErrorState(errorMessage):
            if currentState.page == .impersonation {
                return state.with {
                    $0.impersonationState.isImpersonateLoading = false
                    $0.impersonationState.isImpersonateEnabled = true
                    $0.impersonationState.isSkipLoading = false
                    $0.impersonationState.isSkipEnabled = true
                    $0.impersonationState.errorMessage = errorMessage
                }
            } else {
                return state.with {
                    $0.enterCodeState.authCodeIsLoading = false
                    $0.enterCodeState.authCodeIsLoginButtonEnabled = true
                    $0.enterCodeState.authCodeError = errorMessage
                }
            }
        case .clearEnterCodeErrors:
            return state.with {
                $0.enterCodeState.authCodeError = ""
            }
        case .clearPhoneErrors:
            return state.with {
                $0.enterPhoneState.phoneErrorMessage = ""
            }
        case let .setUser(extUser):
            smartLookProvider.updateUser(user: extUser)
            FirebaseEventTrackingAnalyticsService.updateUser(userId: String(extUser.id))
            FirebaseEventTrackingAnalyticsService.setUserProperty(propertyName: .isImpersonating, value: Defaults.impersonatorId != nil ? "yes" : "no")
            FirebaseEventTrackingAnalyticsService.setUserProperty(propertyName: .impersonator, value: Defaults.impersonatorId.map { String($0) })

            CrashlyticsEventTrackingService.updateUser(userId: String(extUser.id))
            CrashlyticsEventTrackingService.setCustomValue(Defaults.impersonatorId != nil ? "yes" : "no", forKey: UserProperties.isImpersonating.rawValue)
            CrashlyticsEventTrackingService.setCustomValue(Defaults.impersonatorId.map { String($0) }, forKey: UserProperties.impersonator.rawValue)

            featureFlagManager.updateFeatureFlagWithUserDetails(extUser: extUser)
            return state.with {
                $0.extUser = extUser
            }
        case let .setFirebaseToken(firebaseToken):
            return state.with {
                $0.firebaseToken = firebaseToken
            }
        case .authSuccess:
            return state.with {
                $0.isAuthenticated = true
            }
        case let .setResendCodeLoadingIndication(isLoading):
            return state.with {
                $0.enterCodeState.resendCodeIsLoading = isLoading
            }
        case .setIsImpersonation:
            return state.with {
                $0.isImpersonation = true
            }
        }
    }

    private func getBackwardPage() -> LoginPage {
        let page = currentState.page
        var newPage: LoginPage = page

        switch page {
        case .phone:
            newPage = .welcome
            break
        case .code:
            newPage = .phone
            break
        case .impersonation:
            newPage = .code
            break
        default:
            break
        }
        return newPage
    }

  private func buildLoginMutation(authCode: String, doneNavigation: @escaping () -> Void) -> Observable<Mutation> {
        let impersonationEnabled = featureFlagRepository.isFeatureFlagEnabled(featureFlag: impersonationFeatureFlag)
        return authInteractor.login(phoneNumber: currentState.fullPhoneNumber, code: authCode)
            .do(onNext: { user in
                if user.isAdmin != true || !impersonationEnabled {
                  self.action.onNext(Action.getFirebaseToken(doneNavigation: doneNavigation))
                }
            })
            .flatMap { user in
                if user.isAdmin != true || !impersonationEnabled {
                    return Observable.just(Mutation.setUser(extUser: user))
                } else {
                    return .concat(.just(Mutation.setUser(extUser: user)),
                                   .just(Mutation.setAuthCodeLoadingIndication(isLoading: false)),
                                   .just(Mutation.setPage(page: .impersonation)))
                }
            }
            .catchError { self.handleLoginErrors(loginError: $0 as! LoginError) }
    }

    private func trackLoginTimestamp() {
        AnalyticsMeasure.sharedInstance.start(label: Events.loginToFeed.rawValue)
        // When we do the login process we don't want to measure the following:
        AnalyticsMeasure.sharedInstance.clear(label: Events.openToFeed.rawValue)
        AnalyticsMeasure.sharedInstance.clear(label: Events.openToInsight.rawValue)
    }

    private func handleNumberPressed(key: String, doneNavigation: @escaping () -> Void) -> Observable<LoginViewReactor.Mutation> {
        switch currentState.page {
        case .phone:
            return Observable.concat(
                Observable.just(Mutation.setPhoneErrorMessage(errorMessage: "")),
                Observable.just(Mutation.setPhoneNumber(key: key))
            )
        case .code:
            guard currentState.enterCodeState.authCode.count <= 5 else {
                return Observable.just(Mutation.unChange)
            }
            if currentState.enterCodeState.authCode.count == 5 {
                trackLoginTimestamp()
              let loginResponse = buildLoginMutation(authCode: currentState.fullAuthCode + key, doneNavigation: doneNavigation)

                let loadingIndication = Observable.just(Mutation.setAuthCodeLoadingIndication(isLoading: true))
                let addDigit = Observable.just(Mutation.addCodeDigit(digit: key))
                return Observable.concat(addDigit, loadingIndication, loginResponse)
            } else {
                return Observable.just(Mutation.addCodeDigit(digit: key))
            }
        case .impersonation:
            return Observable.concat(
                Observable.just(Mutation.setPhoneImpersonationErrorMessage(errorMessage: "")),
                Observable.just(Mutation.setPhoneImpersonationNumber(key: key))
            )
        default:
            return Observable.just(Mutation.unChange)
        }
    }

    private func handleDeletePressed() -> Observable<LoginViewReactor.Mutation> {
        switch currentState.page {
        case .phone:
            return Observable.concat(
                Observable.just(Mutation.setPhoneErrorMessage(errorMessage: "")),
                Observable.just(Mutation.deleteLastNumber)
            )
        case .code:
            let clearErrorMutationObs = Observable.just(Mutation.clearEnterCodeErrors)
            let deleteCodeMutationObs = currentState.enterCodeState.authCode.isEmpty ? Observable.just(Mutation.unChange) : Observable.just(Mutation.deleteLastCode)
            return Observable.concat(clearErrorMutationObs, deleteCodeMutationObs)
        case .impersonation:
            return Observable.concat(
                Observable.just(Mutation.setPhoneImpersonationErrorMessage(errorMessage: "")),
                Observable.just(Mutation.deleteLastImpersonationNumber)
            )
        default:
            return Observable.just(Mutation.unChange)
        }
    }

    private func handlePhoneNumerErrors(phoneNumberError: PhoneNumberError) -> Observable<LoginViewReactor.Mutation> {
        if phoneNumberError == AppErrors.phoeNumberErrors.invalidNumberError {
            log.error("Login Error - Invalid Phone Number")
            EventTracker.track(event: AnalyticsEventFactory.buildErrorEvent(EventCategory.loginPhone, "invalid_number"))
            return Observable.just(Mutation.setPhoneErrorMessage(errorMessage: R.string.localizable.loginErrorsInvalid_number()))
        }

        log.error("Unknown Login Error")
        EventTracker.track(event: AnalyticsEventFactory.buildErrorEvent(EventCategory.loginCode, "general_error"))
        return Observable.just(Mutation.setPhoneErrorMessage(errorMessage: R.string.localizable.loginErrorsDefault_2_lines()))
    }

    private func handleLoginErrors(loginError: LoginError) -> Observable<LoginViewReactor.Mutation> {
        if loginError == AppErrors.LoginErrors.invalidCodeError || loginError == AppErrors.LoginErrors.noRecentCodeError || loginError == AppErrors.LoginErrors.missingCodeCodeError {
            log.error("Login Error - Invalid Code")
            EventTracker.track(event: AnalyticsEventFactory.buildErrorEvent(EventCategory.loginCode, "invalid_code"))
            return .just(.authErrorState(errorMessage: R.string.localizable.loginErrorsMissing_code()))
        }
        if loginError == AppErrors.LoginErrors.missingOrInvalidPhoneError || loginError == AppErrors.LoginErrors.noUserFoundError || loginError == AppErrors.LoginErrors.multipleUsersError {
            log.error("Login Error - Invalid Account")
            EventTracker.track(event: AnalyticsEventFactory.buildErrorEvent(EventCategory.loginCode, "no_account"))
                return .just(.authErrorState(errorMessage: R.string.localizable.loginErrorsInvalid_account_error_IOS(R.string.localizable.loginErrorsInvalid_account_target_error())))
        }
        if loginError == AppErrors.LoginErrors.noFieldsFound {
            log.error("Login Error - No Fields Found")
            EventTracker.track(event: AnalyticsEventFactory.buildErrorEvent(EventCategory.loginCode, "no_fields"))
                    return .just(.authErrorState(errorMessage: R.string.localizable.loginErrorsNo_fields_found()))
        }
        log.error("Unknown Login Error")
        EventTracker.track(event: AnalyticsEventFactory.buildErrorEvent(EventCategory.loginCode, "general_error"))
                                                 return .just(.authErrorState(errorMessage: R.string.localizable.loginErrorsDefault_2_lines()))
    }
}
