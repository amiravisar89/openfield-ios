//
//  Logging+Injection.swift
//  Openfield
//
//  Created by amir avisar on 15/05/2022.
//  Copyright © 2022 Prospera. All rights reserved.
//

import Foundation
import Resolver

extension Resolver {
    static func registerLogging() {
        register { DataDogLogger() }
        register { CocoaLumberjackLogger() }
        register { _ -> MainLogger in
            let dataDogLogger: DataDogLogger = resolve()
            let cocoaLumberjackLogger: CocoaLumberjackLogger = resolve()
            return MainLogger(loggers: [dataDogLogger,
                                        cocoaLumberjackLogger])
        }
    }
}
