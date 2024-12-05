//
//  OSappDelegateService.swift
//  Openfield
//
//  Created by amir avisar on 23/02/2022.
//  Copyright © 2022 Prospera. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher
import KingfisherWebP

class OSappDelegateService: NSObject, AppDelegateService {
  func application(_: UIApplication,
                   didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool
  {
    knigfisherWebpSupport()
    // fix iOS known issue with UITableview sections insets
    if #available(iOS 15.0, *) { UITableView.appearance().sectionHeaderTopPadding = 0.0 }
    return true
  }
  
  private func knigfisherWebpSupport() {
    KingfisherManager.shared.defaultOptions += [
      .processor(WebPProcessor.default),
      .cacheSerializer(WebPSerializer.default),
    ]
  }
}
