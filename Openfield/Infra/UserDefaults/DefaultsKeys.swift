//
//  DefaultsKeys.swift
//  Openfield
//
//  Created by Daniel Kochavi on 04/02/2020.
//  Copyright © 2020 Prospera. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

enum UserDefaultKey: String {
  case userId
  case extUser
  case finishAppwalkThrew
  case seenAppWalkthrough
  case optionalPopUpLastSeen
  case impersonatorId
  case virtualScoutingButtonClicked
  case locationInsightPagerPrevArrowClicked
}

extension DefaultsKeys {
  var userId: DefaultsKey<Int> { return .init(UserDefaultKey.userId.rawValue, defaultValue: 0) }
  var optionalPopUpLastSeen: DefaultsKey<String?> { return .init(UserDefaultKey.optionalPopUpLastSeen.rawValue, defaultValue: nil) }
  var extUser: DefaultsKey<ExtUser?> { return .init(UserDefaultKey.extUser.rawValue, defaultValue: nil) }
  var seenAppwalkthrough: DefaultsKey<[Int]> { return .init(UserDefaultKey.seenAppWalkthrough.rawValue, defaultValue: []) }
  var finishAppwalkThrew: DefaultsKey<[Int]> { return .init(UserDefaultKey.finishAppwalkThrew.rawValue, defaultValue: []) }
  var impersonatorId: DefaultsKey<Int?> { return .init(UserDefaultKey.impersonatorId.rawValue, defaultValue: nil) }
  var virtualScoutingButtonClicked: DefaultsKey<Bool> { return .init(UserDefaultKey.virtualScoutingButtonClicked.rawValue, defaultValue: false) }
  var locationInsightPagerPrevArrowClicked: DefaultsKey<Bool> { return .init(UserDefaultKey.locationInsightPagerPrevArrowClicked.rawValue, defaultValue: false) }
}
