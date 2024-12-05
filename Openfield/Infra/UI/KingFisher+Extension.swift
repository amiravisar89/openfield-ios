//
//  KingFisher+Extension.swift
//  Openfield
//
//  Created by amir avisar on 15/07/2021.
//  Copyright © 2021 Prospera. All rights reserved.
//

import Foundation
import Kingfisher
import KingfisherWebP

public extension KingfisherWrapper where Base: KFCrossPlatformImageView {
    @discardableResult
    func setImage(
        maxRetry: Int,
        retryInterval: TimeInterval,
        with resource: Resource?,
        placeholder: Placeholder? = nil,
        options: KingfisherOptionsInfo? = nil,
        progressBlock: DownloadProgressBlock? = nil,
        completionHandler: ((Result<RetrieveImageResult, KingfisherError>) -> Void)? = nil
    ) -> DownloadTask? {
        var retryOptions = options == nil ? KingfisherOptionsInfo() : options
        retryOptions?.append(.retryStrategy(DelayRetryStrategy(maxRetryCount: maxRetry, retryInterval: .seconds(retryInterval))))
        return setImage(
            with: resource?.convertToSource(),
            placeholder: placeholder,
            options: options,
            progressBlock: progressBlock,
            completionHandler: completionHandler
        )
    }
}
