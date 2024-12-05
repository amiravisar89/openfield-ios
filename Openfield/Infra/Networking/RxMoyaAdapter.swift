//
//  RxMoyaAdapter.swift
//  Openfield
//
//  Created by Daniel Kochavi on 14/11/2019.
//  Copyright © 2019 Prospera. All rights reserved.
//

import Foundation
import Moya
import RxSwift

final class RxMoyaAdapter<Target: TargetType> {
    let provider: MoyaProvider<Target>

    init(provider: MoyaProvider<Target>) {
        self.provider = provider
    }

    func request(
        _ target: Target,
        file: StaticString = #file,
        function: StaticString = #function,
        line: UInt = #line
    ) -> Single<Response> {
        let requestString = "\(target.method.rawValue) \(target.path)"
        return provider.rx.request(target)
            .filterSuccessfulStatusCodes()
            .do(
                onSuccess: { value in
                    let message = "SUCCESS: \(requestString) (\(value.statusCode))"
                    log.debug(message, file: file, function: function, line: line)
                },
                onError: { error in
                    if let response = (error as? MoyaError)?.response {
                        if let jsonObject = try? response.mapJSON(failsOnEmptyData: false) {
                            let message = "FAILURE: \(requestString) (\(response.statusCode))\n\(jsonObject)"
                            log.warning(message, file: file, function: function, line: line)
                        } else if let rawString = String(data: response.data, encoding: .utf8) {
                            let message = "FAILURE: \(requestString) (\(response.statusCode))\n\(rawString)"
                            log.warning(message, file: file, function: function, line: line)
                        } else {
                            let message = "FAILURE: \(requestString) (\(response.statusCode))"
                            log.warning(message, file: file, function: function, line: line)
                        }
                    } else {
                        let message = "FAILURE: \(requestString)\n\(error)"
                        log.warning(message, file: file, function: function, line: line)
                    }
                },
                onSubscribed: {
                    let message = "REQUEST: \(requestString)"
                    log.verbose(message, file: file, function: function, line: line)
                }
            )
    }
}
