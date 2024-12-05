//
//  Network+Injection.swift
//  Openfield
//
//  Created by Daniel Kochavi on 01/01/2020.
//  Copyright © 2020 Prospera. All rights reserved.
//

import Moya
import Resolver

extension Resolver {
    static func registerNetwork() {
        register { () -> RxMoyaAdapter<AuthMoyaTarget> in
            let provider: MoyaProvider<AuthMoyaTarget> = MoyaProviderFactory<AuthMoyaTarget>.provider()
            return RxMoyaAdapter<AuthMoyaTarget>(provider: provider)
        }
    }
}
