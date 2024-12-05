//
//  GetSubscriptionPopupDataUseCaseProtocol.swift
//  Openfield
//
//  Created by amir avisar on 19/08/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation

protocol GetSubscriptionPopupDataUseCaseProtocol {
    func secondaryButtonTitle() -> String
    func mainButtonTitleUnclick() -> String
    func subtitle() -> String
    func title() -> String
    func imageUrl() -> URL
    func mainButtonTitleClick() -> String
    func minDate() -> String
    func maxDate() -> String
}
