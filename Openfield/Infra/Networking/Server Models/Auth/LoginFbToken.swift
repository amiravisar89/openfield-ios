//
//  LoginFbToken.swift
//  Openfield
//
//  Created by Itay Kaplan on 15/01/2020.
//  Copyright © 2020 Prospera. All rights reserved.
//

struct LoginFbTokens: Decodable {
    var tokens: FbTokens

    struct FbTokens: Decodable {
        var clients: String
    }
}
