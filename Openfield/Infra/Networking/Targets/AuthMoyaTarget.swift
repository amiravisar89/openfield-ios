//
//  AuthMoyaTarget.swift
//  Openfield
//
//  Created by Daniel Kochavi on 01/01/2020.
//  Copyright © 2020 Prospera. All rights reserved.
//

import Foundation
import Moya

enum AuthMoyaTarget {
    case sendSms(phoneNumber: String)
    case login(phoneNumber: String, code: String)
    case getFirebaseToken
    case getImpressionsToken(phoneNumber: String)
}

extension AuthMoyaTarget: TargetType {
    var headers: [String: String]? { return nil }

    var baseURL: URL {
        return URL(string: ConfigEnvironment.valueFor(key: .baseUrl) + "/auth")!
    }

    var path: String {
        switch self {
        case .sendSms:
            return "/login/otp/send/"
        case .login:
            return "/login/otp/"
        case .getFirebaseToken:
            return "/token/firebase/"
        case .getImpressionsToken:
            return "/token/impersonate/"
        }
    }

    var method: Moya.Method {
        switch self {
        case .sendSms, .login, .getImpressionsToken:
            return .post
        case .getFirebaseToken:
            return .get
        }
    }

    var sampleData: Data {
        switch self {
        case .sendSms, .login, .getFirebaseToken, .getImpressionsToken:
            return Data()
        }
    }

    var task: Task {
        switch self {
        case let .sendSms(phone):
            let params = [
                "phone": phone,
            ]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case let .login(phone, code):
            let params = [
                "phone": phone,
                "code": code,
            ]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)

        case .getFirebaseToken:
            return .requestPlain
        case let .getImpressionsToken(phone):
            let params = [
                "phone": phone,
            ]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        }
    }
}
