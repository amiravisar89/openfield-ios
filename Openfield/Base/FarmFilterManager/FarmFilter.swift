//
//  FarmFilter.swift
//  Openfield
//
//  Created by amir avisar on 01/10/2021.
//  Copyright © 2021 Prospera. All rights reserved.
//

import Foundation
import ReactorKit
import Resolver
import RxSwift
import Dollar

class FarmFilter : FarmFilterProtocol {
    // MARK: Members

    let disposeBag = DisposeBag()
    let insightsFromDateUseCase: InsightsFromDateUsecaseProtocol!
    let allFarmUseCase: GetAllFarmsUseCaseProtoocol!
    
    // MARK: Observers
    let farms: BehaviorSubject<[FilteredFarm]> = BehaviorSubject(value: [])

    init(insightsFromDateUseCase: InsightsFromDateUsecaseProtocol, allFarmUseCase: GetAllFarmsUseCaseProtoocol) {
        self.insightsFromDateUseCase = insightsFromDateUseCase
        self.allFarmUseCase = allFarmUseCase
        
        allFarmUseCase.farms().map { farms in
            farms.map { FilteredFarm(isSelected: true, name: $0.name, fieldIds: $0.fieldIds, type: $0.type, id: $0.id) }
        }.subscribe(onNext: { [weak self] farms in self?.farms.onNext(farms) })
            .disposed(by: disposeBag)

        insightsFromDateUseCase.getInsights(insightsFromDate: Date(), limit: nil).distinctUntilChanged { $0.count == $1.count }
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                self.resetFarms()
            }.disposed(by: disposeBag)
    }

    func selectFarms(farms: [FilteredFarm]) {
        self.farms.onNext(farms)
    }

    func resetFarms() {
        do {
            let farms = try self.farms.value()
            self.farms.onNext(farms.map { FilteredFarm(isSelected: true, name: $0.name, fieldIds: $0.fieldIds, type: .defaultFarm, id: $0.id) })
        } catch {
            log.warning("Failed reseting farms with error: \(error)")
        }
    }
}
