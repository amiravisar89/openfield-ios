//
//  AppErrors.swift
//  Openfield
//
//  Created by Itay Kaplan on 15/01/2020.
//  Copyright © 2020 Prospera. All rights reserved.
//

import Foundation

enum AppErrors {
    enum LoginErrors {
        static let invalidCodeError: LoginError = .init(statusCode: 401, detail: "invalid_code")
        static let noRecentCodeError: LoginError = .init(statusCode: 401, detail: "no_recent_code")
        static let missingCodeCodeError: LoginError = .init(statusCode: 400, detail: "missing_code")
        static let missingOrInvalidPhoneError: LoginError = .init(statusCode: 400, detail: "missing_or_invalid_phone_number")
        static let noUserFoundError: LoginError = .init(statusCode: 401, detail: "no_user_found")
        static let multipleUsersError: LoginError = .init(statusCode: 401, detail: "multiple_users_found")
        static let noFieldsFound: LoginError = .init(statusCode: 401, detail: "no_fields_found")
    }

    enum phoeNumberErrors {
        static let invalidNumberError: PhoneNumberError = .init(statusCode: 400, detail: "invalid_number")
    }
    
    enum FirebaseErrors {
        static let noPermissions: LoginError = .init(statusCode: 7, detail: "Missing or insufficient permissions.")
    }
    
    enum RemoteConfigErrors {
        static let valueError: RemoteConfigError = .init(statusCode: 402, detail: "remote_config_value_has_worng_value")
    }
}
