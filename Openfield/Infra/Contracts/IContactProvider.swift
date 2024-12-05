//
//  IContactProvider.swift
//  Openfield
//
//  Created by amir avisar on 17/08/2022.
//  Copyright © 2022 Prospera. All rights reserved.
//

import Foundation
import RxSwift

protocol TermsOfUseProviderProtocol {
    var remoteContracts: Contracts? { get }
    func shouldSign() -> Observable<Bool>
    func getContract(by type: ContractType) -> Contract?
    func updateContractSeen(tsSeenContract: Date) -> Observable<UserTracking>
    func sign() -> Observable<UserTracking>
}
