//
//  LoginFirebaseToken.swift
//  Openfield
//
//  Created by Itay Kaplan on 15/01/2020.
//  Copyright © 2020 Prospera. All rights reserved.
//

struct LoginFirebaseToken: Decodable {
    var tokens: FirebaseTokens

    struct FirebaseTokens: Decodable {
        var clients: String
    }
}
