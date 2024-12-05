//
//  ImageViewerErrors.swift
//  Openfield
//
//  Created by Itay Kaplan on 25/01/2021.
//  Copyright © 2021 Prospera. All rights reserved.
//

import Foundation

enum ImageViewerError: String, Error {
    case NoImagesToDiplay = "No Images To Display"
    case InvalidImageUrl = "Image URL is Invalid"
}
