//
//  FieldLastReadMapper.swift
//  Openfield
//
//  Created by Yoni Luz on 25/12/2023.
//  Copyright © 2023 Prospera. All rights reserved.
//

import Foundation


struct FieldLastReadMapper {
    
    func map(serverModel: FieldLastReadServerModel?) -> FieldLastRead? {
        guard let lastReadField = serverModel else { return nil }
        return FieldLastRead(tsRead: lastReadField.ts_read?.dateValue(), tsFirstRead: lastReadField.ts_first_read?.dateValue())
    }
}
