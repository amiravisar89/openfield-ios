//
//  ExtUser.swift
//  Openfield
//
//  Created by Itay Kaplan on 15/01/2020.
//  Copyright © 2020 Prospera. All rights reserved.
//
import Foundation
import SwiftyUserDefaults

//  *************** NOTICE ***************
//  Any new added member to ExtUser must be nullble because of it is Codable

struct ExtUser: Codable, DefaultsSerializable {
  let id: Int
  let username: String
  let organization: String
  let phone: String
  let tsFirstLogin: Date?
  let isDemo: Bool?
  let isAdmin: Bool?
}

struct ExtUserWithToken {
  let extUser: ExtUser
  let token: String
}
