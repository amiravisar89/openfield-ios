//
//  Feedback.swift
//  Openfield
//
//  Created by Daniel Kochavi on 10/12/2019.
//  Copyright © 2019 Prospera. All rights reserved.
//

import Foundation
import Then

struct Feedback: Then, Hashable {
    let insightId: Int
    var rating: Int? = nil
    var reason: FeedbackAnswer?
    var otherReasonText: String?
}
