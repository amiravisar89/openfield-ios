//
//  FarmsFaker.swift
//  Openfield
//
//  Created by amir avisar on 02/05/2022.
//  Copyright © 2022 Prospera. All rights reserved.
//

import Dollar
import Fakery
import Foundation

struct FarmFaker: FakerProvider {
    let faker: Faker

    init(faker: Faker) {
        self.faker = faker
    }

    func createFarms(fields: [Field]) -> [Farm] {
        var farms = [Farm]()
        let fieldsByFarm = Dollar.groupBy(fields) { field -> (String) in
            field.farmName
        }
        for (farmName, fields) in fieldsByFarm {
            farms.append(Farm(id: faker.number.randomInt(min: 1, max: 1000), name: farmName, fieldIds: fields.compactMap { $0.id }, type: .defaultFarm))
        }
        return farms
    }
}
