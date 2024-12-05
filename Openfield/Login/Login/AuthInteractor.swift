//
//  AuthInteractor.swift
//  Openfield
//
//  Created by Itay Kaplan on 12/01/2020.
//  Copyright © 2020 Prospera. All rights reserved.
//

import Foundation
import Moya
import ReactorKit
import Resolver
import RxSwift

import Firebase
import FirebaseAuth

class AuthInteractor {
    private let authAdapter: RxMoyaAdapter<AuthMoyaTarget> = Resolver.resolve()
    private let auth = Auth.auth() // TODO-itay: this shoul be injected
    private let jsonDecoder = JSONDecoder()
    private let extUserMapper: ExtUserModelMapper

    init(extUserMapper: ExtUserModelMapper) {
        self.extUserMapper = extUserMapper
        jsonDecoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
    }

    public func login(phoneNumber: String, code: String) -> Observable<ExtUser> {
        return authAdapter.request(.login(phoneNumber: phoneNumber, code: code))
            .asObservable()
            .materialize()
            .map { [weak self] event -> Event<ExtUser> in
                guard let self = self else {
                    log.warning("AuthInteractor does not exist")
                    return Event<ExtUser>.error(LoginError())
                }
                switch event {
                case let .next(response):
                    do {
                        self.jsonDecoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
                        let loginResponse = try response.map(LoginResponse.self, using: self.jsonDecoder)
                        let extUser = self.extUserMapper.map(extUserServerModel: loginResponse.ext_user)
                        return Event<ExtUser>.next(extUser)
                    } catch {
                        do {
                            self.jsonDecoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Mid)
                            let loginResponse = try response.map(LoginResponse.self, using: self.jsonDecoder)
                            let extUser = self.extUserMapper.map(extUserServerModel: loginResponse.ext_user)
                            return Event<ExtUser>.next(extUser)
                        } catch {
                            log.error("Unable To Parse Login Response: \(error.localizedDescription)")
                            return Event<ExtUser>.error(LoginError())
                        }
                    }
                case let .error(error):
                    let errorResponseOptional = (error as? MoyaError)?.response
                    guard let errorResponse = errorResponseOptional else {
                        log.error("User is offline")
                        return Event<ExtUser>.error(LoginError())
                    }
                    do {
                        var loginError = try errorResponse.map(LoginError.self)
                        loginError.statusCode = errorResponse.statusCode
                        return Event<ExtUser>.error(loginError)
                    } catch {
                        log.error("Unable to parse Login Error")
                        return Event<ExtUser>.error(LoginError())
                    }
                case .completed:
                    return Event<ExtUser>.completed
                }
            }
            .dematerialize()
    }
    
    public func impersonate(phoneNumber: String) -> Observable<ExtUserWithToken> {
        return authAdapter.request(.getImpressionsToken(phoneNumber: phoneNumber))
            .asObservable()
            .materialize()
            .map { [weak self] event -> Event<ExtUserWithToken> in
                guard let self = self else {
                    log.warning("AuthInteractor does not exist")
                    return Event<ExtUserWithToken>.error(LoginError())
                }
                switch event {
                case let .next(response):
                    do {
                        self.jsonDecoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
                        let impersonateResponse = try response.map(ImpersonateResponse.self, using: self.jsonDecoder)
                        let extUser = self.extUserMapper.map(extUserServerModel: impersonateResponse.ext_user)
                        return Event<ExtUserWithToken>.next(ExtUserWithToken(extUser: extUser, token: impersonateResponse.token))
                        
                    } catch {
                        do {
                            self.jsonDecoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Mid)
                            let impersonateResponse = try response.map(ImpersonateResponse.self, using: self.jsonDecoder)
                            let extUser = self.extUserMapper.map(extUserServerModel: impersonateResponse.ext_user)
                            return Event<ExtUserWithToken>.next(ExtUserWithToken(extUser: extUser, token: impersonateResponse.token))
                        } catch {
                            log.error("Unable to parse Impersonate Response: \(error.localizedDescription)")
                            return Event<ExtUserWithToken>.error(LoginError())
                        }
                    }
                case let .error(error):
                    let errorResponseOptional = (error as? MoyaError)?.response
                    guard let errorResponse = errorResponseOptional else {
                        log.error("User is offline")
                        return Event<ExtUserWithToken>.error(LoginError())
                    }
                    do {
                        var loginError = try errorResponse.map(LoginError.self)
                        loginError.statusCode = errorResponse.statusCode
                        return Event<ExtUserWithToken>.error(loginError)
                    } catch {
                        log.error("Unable to parse Login Error")
                        return Event<ExtUserWithToken>.error(LoginError())
                    }
                case .completed:
                    return Event<ExtUserWithToken>.completed
                }
            }
            .dematerialize()
    }

    public func getFirebaseToken() -> Observable<String> {
        return authAdapter.request(.getFirebaseToken)
            .asObservable()
            .map { response in
                do {
                    let loginFirebaseTokens = try response.map(LoginFirebaseToken.self)
                    let token = loginFirebaseTokens.tokens.clients
                    return token
                } catch {
                    log.error("Unable to parse Login Response")
                    throw LoginError()
                }
            }
    }

    public func sendCode(phoneNumber: String) -> Observable<Bool> {
        authAdapter.request(.sendSms(phoneNumber: phoneNumber))
            .asObservable()
            .materialize()
            .map { event -> Event<Bool> in
                switch event {
                case .next:
                    return Event<Bool>.next(true)
                case let .error(error):
                    guard let errorResponse = (error as? MoyaError)?.response else {
                        log.error("User is offline")
                        return Event<Bool>.error(PhoneNumberError())
                    }
                    do {
                        var phoneError = try errorResponse.map(PhoneNumberError.self)
                        phoneError.statusCode = errorResponse.statusCode
                        return Event<Bool>.error(phoneError)
                    } catch {
                        log.error("Unable to parse Phone Error")
                        return Event<Bool>.error(PhoneNumberError())
                    }
                case .completed:
                    return Event<Bool>.completed
                }
            }
            .dematerialize()
    }

    public func authWithFirebase(token: String?) -> Observable<Bool> {
        return Observable.create { observer in
            self.auth.signIn(withCustomToken: token ?? "") { _,  error in
                if let error = error {
                    log.error("Error updating user tracking object: \(error)")
                    observer.onError(error)
                } else {
                    log.debug("Successfuly updated user tracking object")
                    observer.onNext(true)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }

    public func logoutFormFirebase() -> Observable<Bool> {
        do {
            try auth.signOut()
        } catch let signOutError as NSError {
            log.error("Error signing out: %@", signOutError)
            return Observable.just(false)
        }
        return Observable.just(true)
    }
}
