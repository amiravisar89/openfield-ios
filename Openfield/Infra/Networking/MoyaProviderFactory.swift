//
//  MoyaProviderFactory.swift
//  Openfield
//
//  Created by Daniel Kochavi on 01/01/2020.
//  Copyright © 2020 Prospera. All rights reserved.
//

import Moya

struct MoyaProviderFactory<T: TargetType> {
    static func provider() -> MoyaProvider<T> {
        let endpointClosure: (T) -> Endpoint = EndpointClosureFactory.endpointClosure()

        let configuration = URLSessionConfiguration.ephemeral
        configuration.timeoutIntervalForRequest = 60
        let session = Session(configuration: configuration)

        return MoyaProvider<T>(endpointClosure: endpointClosure,
                               stubClosure: MoyaProvider.neverStub,
                               session: session,
                               plugins: MoyaProviderFactory.networkLoggerPlugin(),
                               trackInflights: false)
    }

    private static func networkLoggerPlugin() -> [PluginType] {
        let loggerConfiguration: NetworkLoggerPlugin.Configuration = .init(formatter: .init(), output: { _, array in
            if let logLine = array.first {
                log.verbose(logLine)
            }
        }, logOptions: .formatRequestAscURL)
        let loggerPlugin = NetworkLoggerPlugin(configuration: loggerConfiguration)
        return [loggerPlugin]
    }
}
