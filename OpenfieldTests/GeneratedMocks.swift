// MARK: - Mocks generated from file: Openfield/Base/FarmFilterManager/FarmFilterProtocol.swift at 2024-11-17 14:51:25 +0000

//
//  FarmFilterProtocol.swift
//  Openfield
//
//  Created by amir avisar on 19/02/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Cuckoo
@testable import Openfield

import Foundation
import RxSwift






 class MockFarmFilterProtocol: FarmFilterProtocol, Cuckoo.ProtocolMock {
    
     typealias MocksType = FarmFilterProtocol
    
     typealias Stubbing = __StubbingProxy_FarmFilterProtocol
     typealias Verification = __VerificationProxy_FarmFilterProtocol

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: FarmFilterProtocol?

     func enableDefaultImplementation(_ stub: FarmFilterProtocol) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    
    
    
    
     var farms: BehaviorSubject<[FilteredFarm]> {
        get {
            return cuckoo_manager.getter("farms",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall:  __defaultImplStub!.farms)
        }
        
    }
    
    

    

    
    
    
    
     func selectFarms(farms: [FilteredFarm])  {
        
    return cuckoo_manager.call(
    """
    selectFarms(farms: [FilteredFarm])
    """,
            parameters: (farms),
            escapingParameters: (farms),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.selectFarms(farms: farms))
        
    }
    
    
    
    
    
     func resetFarms()  {
        
    return cuckoo_manager.call(
    """
    resetFarms()
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.resetFarms())
        
    }
    
    

     struct __StubbingProxy_FarmFilterProtocol: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        var farms: Cuckoo.ProtocolToBeStubbedReadOnlyProperty<MockFarmFilterProtocol, BehaviorSubject<[FilteredFarm]>> {
            return .init(manager: cuckoo_manager, name: "farms")
        }
        
        
        
        
        
        func selectFarms<M1: Cuckoo.Matchable>(farms: M1) -> Cuckoo.ProtocolStubNoReturnFunction<([FilteredFarm])> where M1.MatchedType == [FilteredFarm] {
            let matchers: [Cuckoo.ParameterMatcher<([FilteredFarm])>] = [wrap(matchable: farms) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockFarmFilterProtocol.self, method:
    """
    selectFarms(farms: [FilteredFarm])
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func resetFarms() -> Cuckoo.ProtocolStubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockFarmFilterProtocol.self, method:
    """
    resetFarms()
    """, parameterMatchers: matchers))
        }
        
        
    }

     struct __VerificationProxy_FarmFilterProtocol: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
         init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
        
        
        var farms: Cuckoo.VerifyReadOnlyProperty<BehaviorSubject<[FilteredFarm]>> {
            return .init(manager: cuckoo_manager, name: "farms", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
    
        
        
        
        @discardableResult
        func selectFarms<M1: Cuckoo.Matchable>(farms: M1) -> Cuckoo.__DoNotUse<([FilteredFarm]), Void> where M1.MatchedType == [FilteredFarm] {
            let matchers: [Cuckoo.ParameterMatcher<([FilteredFarm])>] = [wrap(matchable: farms) { $0 }]
            return cuckoo_manager.verify(
    """
    selectFarms(farms: [FilteredFarm])
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func resetFarms() -> Cuckoo.__DoNotUse<(), Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    resetFarms()
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


 class FarmFilterProtocolStub: FarmFilterProtocol {
    
    
    
    
     var farms: BehaviorSubject<[FilteredFarm]> {
        get {
            return DefaultValueRegistry.defaultValue(for: (BehaviorSubject<[FilteredFarm]>).self)
        }
        
    }
    
    

    

    
    
    
    
     func selectFarms(farms: [FilteredFarm])   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
    
    
    
     func resetFarms()   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
    
}





// MARK: - Mocks generated from file: Openfield/Infra/Data/ModelMappers/InsightConfigurationModellMapper.swift at 2024-11-17 14:51:25 +0000

//
//  InsightConfigurationModellMapper.swift
//  Openfield
//
//  Created by amir avisar on 29/08/2021.
//  Copyright © 2021 Prospera. All rights reserved.
//

import Cuckoo
@testable import Openfield

import Foundation
import UIKit

// MARK: - Mocks generated from file: Openfield/Infra/Data/ModelMappers/InsightModelMapperProtocol.swift at 2024-11-17 14:51:25 +0000

//
//  InsightModelMapperProtocol.swift
//  Openfield
//
//  Created by Yoni Luz on 11/01/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Cuckoo
@testable import Openfield

import Foundation






 class MockInsightModelMapperProtocol: InsightModelMapperProtocol, Cuckoo.ProtocolMock {
    
     typealias MocksType = InsightModelMapperProtocol
    
     typealias Stubbing = __StubbingProxy_InsightModelMapperProtocol
     typealias Verification = __VerificationProxy_InsightModelMapperProtocol

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: InsightModelMapperProtocol?

     func enableDefaultImplementation(_ stub: InsightModelMapperProtocol) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    
     func map(insightConfiguration: InsightConfiguration, insightServerModel: InsightServerModel, userInsight: UserInsight?, unitByCountry: UnitsByCountry) throws -> Insight? {
        
    return try cuckoo_manager.callThrows(
    """
    map(insightConfiguration: InsightConfiguration, insightServerModel: InsightServerModel, userInsight: UserInsight?, unitByCountry: UnitsByCountry) throws -> Insight?
    """,
            parameters: (insightConfiguration, insightServerModel, userInsight, unitByCountry),
            escapingParameters: (insightConfiguration, insightServerModel, userInsight, unitByCountry),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.map(insightConfiguration: insightConfiguration, insightServerModel: insightServerModel, userInsight: userInsight, unitByCountry: unitByCountry))
        
    }
    
    

     struct __StubbingProxy_InsightModelMapperProtocol: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func map<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.OptionalMatchable, M4: Cuckoo.Matchable>(insightConfiguration: M1, insightServerModel: M2, userInsight: M3, unitByCountry: M4) -> Cuckoo.ProtocolStubThrowingFunction<(InsightConfiguration, InsightServerModel, UserInsight?, UnitsByCountry), Insight?> where M1.MatchedType == InsightConfiguration, M2.MatchedType == InsightServerModel, M3.OptionalMatchedType == UserInsight, M4.MatchedType == UnitsByCountry {
            let matchers: [Cuckoo.ParameterMatcher<(InsightConfiguration, InsightServerModel, UserInsight?, UnitsByCountry)>] = [wrap(matchable: insightConfiguration) { $0.0 }, wrap(matchable: insightServerModel) { $0.1 }, wrap(matchable: userInsight) { $0.2 }, wrap(matchable: unitByCountry) { $0.3 }]
            return .init(stub: cuckoo_manager.createStub(for: MockInsightModelMapperProtocol.self, method:
    """
    map(insightConfiguration: InsightConfiguration, insightServerModel: InsightServerModel, userInsight: UserInsight?, unitByCountry: UnitsByCountry) throws -> Insight?
    """, parameterMatchers: matchers))
        }
        
        
    }

     struct __VerificationProxy_InsightModelMapperProtocol: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
         init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
    
        
        
        
        @discardableResult
        func map<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.OptionalMatchable, M4: Cuckoo.Matchable>(insightConfiguration: M1, insightServerModel: M2, userInsight: M3, unitByCountry: M4) -> Cuckoo.__DoNotUse<(InsightConfiguration, InsightServerModel, UserInsight?, UnitsByCountry), Insight?> where M1.MatchedType == InsightConfiguration, M2.MatchedType == InsightServerModel, M3.OptionalMatchedType == UserInsight, M4.MatchedType == UnitsByCountry {
            let matchers: [Cuckoo.ParameterMatcher<(InsightConfiguration, InsightServerModel, UserInsight?, UnitsByCountry)>] = [wrap(matchable: insightConfiguration) { $0.0 }, wrap(matchable: insightServerModel) { $0.1 }, wrap(matchable: userInsight) { $0.2 }, wrap(matchable: unitByCountry) { $0.3 }]
            return cuckoo_manager.verify(
    """
    map(insightConfiguration: InsightConfiguration, insightServerModel: InsightServerModel, userInsight: UserInsight?, unitByCountry: UnitsByCountry) throws -> Insight?
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


 class InsightModelMapperProtocolStub: InsightModelMapperProtocol {
    

    

    
    
    
    
     func map(insightConfiguration: InsightConfiguration, insightServerModel: InsightServerModel, userInsight: UserInsight?, unitByCountry: UnitsByCountry) throws -> Insight?  {
        return DefaultValueRegistry.defaultValue(for: (Insight?).self)
    }
    
    
}





// MARK: - Mocks generated from file: Openfield/Infra/Data/Repositories/FieldRepositoryProtocol.swift at 2024-11-17 14:51:25 +0000

//
//  FieldRepositoryProtocol.swift
//  Openfield
//
//  Created by Yoni Luz on 23/01/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Cuckoo
@testable import Openfield

import Foundation
import RxSwift






 class MockFieldRepositoryProtocol: FieldRepositoryProtocol, Cuckoo.ProtocolMock {
    
     typealias MocksType = FieldRepositoryProtocol
    
     typealias Stubbing = __StubbingProxy_FieldRepositoryProtocol
     typealias Verification = __VerificationProxy_FieldRepositoryProtocol

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: FieldRepositoryProtocol?

     func enableDefaultImplementation(_ stub: FieldRepositoryProtocol) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    
     func fieldStream(fieldId: Int) -> Observable<FieldServerModel> {
        
    return cuckoo_manager.call(
    """
    fieldStream(fieldId: Int) -> Observable<FieldServerModel>
    """,
            parameters: (fieldId),
            escapingParameters: (fieldId),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.fieldStream(fieldId: fieldId))
        
    }
    
    
    
    
    
     func imagesStream(fieldId: Int) -> Observable<[FieldImageServerModel]> {
        
    return cuckoo_manager.call(
    """
    imagesStream(fieldId: Int) -> Observable<[FieldImageServerModel]>
    """,
            parameters: (fieldId),
            escapingParameters: (fieldId),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.imagesStream(fieldId: fieldId))
        
    }
    
    
    
    
    
     func imagesStreamByFieldFilter(fieldId: Int, criteria: [FilterCriterion]) -> Observable<[FieldImageServerModel]> {
        
    return cuckoo_manager.call(
    """
    imagesStreamByFieldFilter(fieldId: Int, criteria: [FilterCriterion]) -> Observable<[FieldImageServerModel]>
    """,
            parameters: (fieldId, criteria),
            escapingParameters: (fieldId, criteria),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.imagesStreamByFieldFilter(fieldId: fieldId, criteria: criteria))
        
    }
    
    
    
    
    
     func lastImageStream(fieldId: Int) -> Observable<[FieldImageServerModel]> {
        
    return cuckoo_manager.call(
    """
    lastImageStream(fieldId: Int) -> Observable<[FieldImageServerModel]>
    """,
            parameters: (fieldId),
            escapingParameters: (fieldId),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.lastImageStream(fieldId: fieldId))
        
    }
    
    

     struct __StubbingProxy_FieldRepositoryProtocol: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func fieldStream<M1: Cuckoo.Matchable>(fieldId: M1) -> Cuckoo.ProtocolStubFunction<(Int), Observable<FieldServerModel>> where M1.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Int)>] = [wrap(matchable: fieldId) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockFieldRepositoryProtocol.self, method:
    """
    fieldStream(fieldId: Int) -> Observable<FieldServerModel>
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func imagesStream<M1: Cuckoo.Matchable>(fieldId: M1) -> Cuckoo.ProtocolStubFunction<(Int), Observable<[FieldImageServerModel]>> where M1.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Int)>] = [wrap(matchable: fieldId) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockFieldRepositoryProtocol.self, method:
    """
    imagesStream(fieldId: Int) -> Observable<[FieldImageServerModel]>
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func imagesStreamByFieldFilter<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(fieldId: M1, criteria: M2) -> Cuckoo.ProtocolStubFunction<(Int, [FilterCriterion]), Observable<[FieldImageServerModel]>> where M1.MatchedType == Int, M2.MatchedType == [FilterCriterion] {
            let matchers: [Cuckoo.ParameterMatcher<(Int, [FilterCriterion])>] = [wrap(matchable: fieldId) { $0.0 }, wrap(matchable: criteria) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockFieldRepositoryProtocol.self, method:
    """
    imagesStreamByFieldFilter(fieldId: Int, criteria: [FilterCriterion]) -> Observable<[FieldImageServerModel]>
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func lastImageStream<M1: Cuckoo.Matchable>(fieldId: M1) -> Cuckoo.ProtocolStubFunction<(Int), Observable<[FieldImageServerModel]>> where M1.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Int)>] = [wrap(matchable: fieldId) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockFieldRepositoryProtocol.self, method:
    """
    lastImageStream(fieldId: Int) -> Observable<[FieldImageServerModel]>
    """, parameterMatchers: matchers))
        }
        
        
    }

     struct __VerificationProxy_FieldRepositoryProtocol: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
         init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
    
        
        
        
        @discardableResult
        func fieldStream<M1: Cuckoo.Matchable>(fieldId: M1) -> Cuckoo.__DoNotUse<(Int), Observable<FieldServerModel>> where M1.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Int)>] = [wrap(matchable: fieldId) { $0 }]
            return cuckoo_manager.verify(
    """
    fieldStream(fieldId: Int) -> Observable<FieldServerModel>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func imagesStream<M1: Cuckoo.Matchable>(fieldId: M1) -> Cuckoo.__DoNotUse<(Int), Observable<[FieldImageServerModel]>> where M1.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Int)>] = [wrap(matchable: fieldId) { $0 }]
            return cuckoo_manager.verify(
    """
    imagesStream(fieldId: Int) -> Observable<[FieldImageServerModel]>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func imagesStreamByFieldFilter<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(fieldId: M1, criteria: M2) -> Cuckoo.__DoNotUse<(Int, [FilterCriterion]), Observable<[FieldImageServerModel]>> where M1.MatchedType == Int, M2.MatchedType == [FilterCriterion] {
            let matchers: [Cuckoo.ParameterMatcher<(Int, [FilterCriterion])>] = [wrap(matchable: fieldId) { $0.0 }, wrap(matchable: criteria) { $0.1 }]
            return cuckoo_manager.verify(
    """
    imagesStreamByFieldFilter(fieldId: Int, criteria: [FilterCriterion]) -> Observable<[FieldImageServerModel]>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func lastImageStream<M1: Cuckoo.Matchable>(fieldId: M1) -> Cuckoo.__DoNotUse<(Int), Observable<[FieldImageServerModel]>> where M1.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Int)>] = [wrap(matchable: fieldId) { $0 }]
            return cuckoo_manager.verify(
    """
    lastImageStream(fieldId: Int) -> Observable<[FieldImageServerModel]>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


 class FieldRepositoryProtocolStub: FieldRepositoryProtocol {
    

    

    
    
    
    
     func fieldStream(fieldId: Int) -> Observable<FieldServerModel>  {
        return DefaultValueRegistry.defaultValue(for: (Observable<FieldServerModel>).self)
    }
    
    
    
    
    
     func imagesStream(fieldId: Int) -> Observable<[FieldImageServerModel]>  {
        return DefaultValueRegistry.defaultValue(for: (Observable<[FieldImageServerModel]>).self)
    }
    
    
    
    
    
     func imagesStreamByFieldFilter(fieldId: Int, criteria: [FilterCriterion]) -> Observable<[FieldImageServerModel]>  {
        return DefaultValueRegistry.defaultValue(for: (Observable<[FieldImageServerModel]>).self)
    }
    
    
    
    
    
     func lastImageStream(fieldId: Int) -> Observable<[FieldImageServerModel]>  {
        return DefaultValueRegistry.defaultValue(for: (Observable<[FieldImageServerModel]>).self)
    }
    
    
}





// MARK: - Mocks generated from file: Openfield/Infra/Data/Repositories/FieldsRepositoryProtocol.swift at 2024-11-17 14:51:25 +0000

//
//  FieldsRepositoryProtocol.swift
//  Openfield
//
//  Created by Yoni Luz on 09/01/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Cuckoo
@testable import Openfield

import CodableFirebase
import Firebase
import Foundation
import RxSwift






 class MockFieldsRepositoryProtocol: FieldsRepositoryProtocol, Cuckoo.ProtocolMock {
    
     typealias MocksType = FieldsRepositoryProtocol
    
     typealias Stubbing = __StubbingProxy_FieldsRepositoryProtocol
     typealias Verification = __VerificationProxy_FieldsRepositoryProtocol

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: FieldsRepositoryProtocol?

     func enableDefaultImplementation(_ stub: FieldsRepositoryProtocol) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    
     func fieldsStream() -> Observable<[FieldServerModel]> {
        
    return cuckoo_manager.call(
    """
    fieldsStream() -> Observable<[FieldServerModel]>
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.fieldsStream())
        
    }
    
    
    
    
    
     func imagesStream(whereDateGreaterThanOrEqualTo fromDate: Date) -> Observable<[FieldImageServerModel]> {
        
    return cuckoo_manager.call(
    """
    imagesStream(whereDateGreaterThanOrEqualTo: Date) -> Observable<[FieldImageServerModel]>
    """,
            parameters: (fromDate),
            escapingParameters: (fromDate),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.imagesStream(whereDateGreaterThanOrEqualTo: fromDate))
        
    }
    
    
    
    
    
     func fieldsLastReadStream() -> Observable<[FieldLastReadServerModel]> {
        
    return cuckoo_manager.call(
    """
    fieldsLastReadStream() -> Observable<[FieldLastReadServerModel]>
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.fieldsLastReadStream())
        
    }
    
    
    
    
    
     func updateFieldLastRead(id: Int, lastRead: FieldLastRead?) -> Observable<Void> {
        
    return cuckoo_manager.call(
    """
    updateFieldLastRead(id: Int, lastRead: FieldLastRead?) -> Observable<Void>
    """,
            parameters: (id, lastRead),
            escapingParameters: (id, lastRead),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.updateFieldLastRead(id: id, lastRead: lastRead))
        
    }
    
    

     struct __StubbingProxy_FieldsRepositoryProtocol: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func fieldsStream() -> Cuckoo.ProtocolStubFunction<(), Observable<[FieldServerModel]>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockFieldsRepositoryProtocol.self, method:
    """
    fieldsStream() -> Observable<[FieldServerModel]>
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func imagesStream<M1: Cuckoo.Matchable>(whereDateGreaterThanOrEqualTo fromDate: M1) -> Cuckoo.ProtocolStubFunction<(Date), Observable<[FieldImageServerModel]>> where M1.MatchedType == Date {
            let matchers: [Cuckoo.ParameterMatcher<(Date)>] = [wrap(matchable: fromDate) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockFieldsRepositoryProtocol.self, method:
    """
    imagesStream(whereDateGreaterThanOrEqualTo: Date) -> Observable<[FieldImageServerModel]>
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func fieldsLastReadStream() -> Cuckoo.ProtocolStubFunction<(), Observable<[FieldLastReadServerModel]>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockFieldsRepositoryProtocol.self, method:
    """
    fieldsLastReadStream() -> Observable<[FieldLastReadServerModel]>
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func updateFieldLastRead<M1: Cuckoo.Matchable, M2: Cuckoo.OptionalMatchable>(id: M1, lastRead: M2) -> Cuckoo.ProtocolStubFunction<(Int, FieldLastRead?), Observable<Void>> where M1.MatchedType == Int, M2.OptionalMatchedType == FieldLastRead {
            let matchers: [Cuckoo.ParameterMatcher<(Int, FieldLastRead?)>] = [wrap(matchable: id) { $0.0 }, wrap(matchable: lastRead) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockFieldsRepositoryProtocol.self, method:
    """
    updateFieldLastRead(id: Int, lastRead: FieldLastRead?) -> Observable<Void>
    """, parameterMatchers: matchers))
        }
        
        
    }

     struct __VerificationProxy_FieldsRepositoryProtocol: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
         init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
    
        
        
        
        @discardableResult
        func fieldsStream() -> Cuckoo.__DoNotUse<(), Observable<[FieldServerModel]>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    fieldsStream() -> Observable<[FieldServerModel]>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func imagesStream<M1: Cuckoo.Matchable>(whereDateGreaterThanOrEqualTo fromDate: M1) -> Cuckoo.__DoNotUse<(Date), Observable<[FieldImageServerModel]>> where M1.MatchedType == Date {
            let matchers: [Cuckoo.ParameterMatcher<(Date)>] = [wrap(matchable: fromDate) { $0 }]
            return cuckoo_manager.verify(
    """
    imagesStream(whereDateGreaterThanOrEqualTo: Date) -> Observable<[FieldImageServerModel]>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func fieldsLastReadStream() -> Cuckoo.__DoNotUse<(), Observable<[FieldLastReadServerModel]>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    fieldsLastReadStream() -> Observable<[FieldLastReadServerModel]>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func updateFieldLastRead<M1: Cuckoo.Matchable, M2: Cuckoo.OptionalMatchable>(id: M1, lastRead: M2) -> Cuckoo.__DoNotUse<(Int, FieldLastRead?), Observable<Void>> where M1.MatchedType == Int, M2.OptionalMatchedType == FieldLastRead {
            let matchers: [Cuckoo.ParameterMatcher<(Int, FieldLastRead?)>] = [wrap(matchable: id) { $0.0 }, wrap(matchable: lastRead) { $0.1 }]
            return cuckoo_manager.verify(
    """
    updateFieldLastRead(id: Int, lastRead: FieldLastRead?) -> Observable<Void>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


 class FieldsRepositoryProtocolStub: FieldsRepositoryProtocol {
    

    

    
    
    
    
     func fieldsStream() -> Observable<[FieldServerModel]>  {
        return DefaultValueRegistry.defaultValue(for: (Observable<[FieldServerModel]>).self)
    }
    
    
    
    
    
     func imagesStream(whereDateGreaterThanOrEqualTo fromDate: Date) -> Observable<[FieldImageServerModel]>  {
        return DefaultValueRegistry.defaultValue(for: (Observable<[FieldImageServerModel]>).self)
    }
    
    
    
    
    
     func fieldsLastReadStream() -> Observable<[FieldLastReadServerModel]>  {
        return DefaultValueRegistry.defaultValue(for: (Observable<[FieldLastReadServerModel]>).self)
    }
    
    
    
    
    
     func updateFieldLastRead(id: Int, lastRead: FieldLastRead?) -> Observable<Void>  {
        return DefaultValueRegistry.defaultValue(for: (Observable<Void>).self)
    }
    
    
}





// MARK: - Mocks generated from file: Openfield/Infra/Data/Repositories/InsightsRepositoryProtocol.swift at 2024-11-17 14:51:25 +0000

//
//  InsightsRepositoryProtocol.swift
//  Openfield
//
//  Created by Yoni Luz on 15/01/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Cuckoo
@testable import Openfield

import Foundation
import RxSwift






 class MockInsightsRepositoryProtocol: InsightsRepositoryProtocol, Cuckoo.ProtocolMock {
    
     typealias MocksType = InsightsRepositoryProtocol
    
     typealias Stubbing = __StubbingProxy_InsightsRepositoryProtocol
     typealias Verification = __VerificationProxy_InsightsRepositoryProtocol

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: InsightsRepositoryProtocol?

     func enableDefaultImplementation(_ stub: InsightsRepositoryProtocol) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    
     func insightsStream(whereDateGreaterThanOrEqualTo fromDate: Date, limit: Int?, onlyHighlights: Bool) -> Observable<[InsightServerModel]> {
        
    return cuckoo_manager.call(
    """
    insightsStream(whereDateGreaterThanOrEqualTo: Date, limit: Int?, onlyHighlights: Bool) -> Observable<[InsightServerModel]>
    """,
            parameters: (fromDate, limit, onlyHighlights),
            escapingParameters: (fromDate, limit, onlyHighlights),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.insightsStream(whereDateGreaterThanOrEqualTo: fromDate, limit: limit, onlyHighlights: onlyHighlights))
        
    }
    
    
    
    
    
     func insightsStream(byFieldId: Int?, byCategory: String?, onlyHighlights: Bool, cycleId: Int?, publicationYear: Int?) -> Observable<[InsightServerModel]> {
        
    return cuckoo_manager.call(
    """
    insightsStream(byFieldId: Int?, byCategory: String?, onlyHighlights: Bool, cycleId: Int?, publicationYear: Int?) -> Observable<[InsightServerModel]>
    """,
            parameters: (byFieldId, byCategory, onlyHighlights, cycleId, publicationYear),
            escapingParameters: (byFieldId, byCategory, onlyHighlights, cycleId, publicationYear),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.insightsStream(byFieldId: byFieldId, byCategory: byCategory, onlyHighlights: onlyHighlights, cycleId: cycleId, publicationYear: publicationYear))
        
    }
    
    
    
    
    
     func insightsStreamByFarms(whereDateGreaterThanOrEqualTo fromDate: Date, limit: Int?, onlyHighlights: Bool, fieldsIds: [Int]) -> Observable<[InsightServerModel]> {
        
    return cuckoo_manager.call(
    """
    insightsStreamByFarms(whereDateGreaterThanOrEqualTo: Date, limit: Int?, onlyHighlights: Bool, fieldsIds: [Int]) -> Observable<[InsightServerModel]>
    """,
            parameters: (fromDate, limit, onlyHighlights, fieldsIds),
            escapingParameters: (fromDate, limit, onlyHighlights, fieldsIds),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.insightsStreamByFarms(whereDateGreaterThanOrEqualTo: fromDate, limit: limit, onlyHighlights: onlyHighlights, fieldsIds: fieldsIds))
        
    }
    
    
    
    
    
     func insightsStreamFilteredByCriteria(fieldId: Int, criteria: [FilterCriterion]) -> Observable<[InsightServerModel]> {
        
    return cuckoo_manager.call(
    """
    insightsStreamFilteredByCriteria(fieldId: Int, criteria: [FilterCriterion]) -> Observable<[InsightServerModel]>
    """,
            parameters: (fieldId, criteria),
            escapingParameters: (fieldId, criteria),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.insightsStreamFilteredByCriteria(fieldId: fieldId, criteria: criteria))
        
    }
    
    
    
    
    
     func welcomeInsightStream() -> Observable<[InsightServerModel]> {
        
    return cuckoo_manager.call(
    """
    welcomeInsightStream() -> Observable<[InsightServerModel]>
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.welcomeInsightStream())
        
    }
    
    
    
    
    
     func locations(forInsightUID insightUID: String) -> Observable<[InsightAttachmentServerModel]> {
        
    return cuckoo_manager.call(
    """
    locations(forInsightUID: String) -> Observable<[InsightAttachmentServerModel]>
    """,
            parameters: (insightUID),
            escapingParameters: (insightUID),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.locations(forInsightUID: insightUID))
        
    }
    
    
    
    
    
     func insight(byUID uid: String) -> Observable<InsightServerModel?> {
        
    return cuckoo_manager.call(
    """
    insight(byUID: String) -> Observable<InsightServerModel?>
    """,
            parameters: (uid),
            escapingParameters: (uid),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.insight(byUID: uid))
        
    }
    
    

     struct __StubbingProxy_InsightsRepositoryProtocol: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func insightsStream<M1: Cuckoo.Matchable, M2: Cuckoo.OptionalMatchable, M3: Cuckoo.Matchable>(whereDateGreaterThanOrEqualTo fromDate: M1, limit: M2, onlyHighlights: M3) -> Cuckoo.ProtocolStubFunction<(Date, Int?, Bool), Observable<[InsightServerModel]>> where M1.MatchedType == Date, M2.OptionalMatchedType == Int, M3.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(Date, Int?, Bool)>] = [wrap(matchable: fromDate) { $0.0 }, wrap(matchable: limit) { $0.1 }, wrap(matchable: onlyHighlights) { $0.2 }]
            return .init(stub: cuckoo_manager.createStub(for: MockInsightsRepositoryProtocol.self, method:
    """
    insightsStream(whereDateGreaterThanOrEqualTo: Date, limit: Int?, onlyHighlights: Bool) -> Observable<[InsightServerModel]>
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func insightsStream<M1: Cuckoo.OptionalMatchable, M2: Cuckoo.OptionalMatchable, M3: Cuckoo.Matchable, M4: Cuckoo.OptionalMatchable, M5: Cuckoo.OptionalMatchable>(byFieldId: M1, byCategory: M2, onlyHighlights: M3, cycleId: M4, publicationYear: M5) -> Cuckoo.ProtocolStubFunction<(Int?, String?, Bool, Int?, Int?), Observable<[InsightServerModel]>> where M1.OptionalMatchedType == Int, M2.OptionalMatchedType == String, M3.MatchedType == Bool, M4.OptionalMatchedType == Int, M5.OptionalMatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Int?, String?, Bool, Int?, Int?)>] = [wrap(matchable: byFieldId) { $0.0 }, wrap(matchable: byCategory) { $0.1 }, wrap(matchable: onlyHighlights) { $0.2 }, wrap(matchable: cycleId) { $0.3 }, wrap(matchable: publicationYear) { $0.4 }]
            return .init(stub: cuckoo_manager.createStub(for: MockInsightsRepositoryProtocol.self, method:
    """
    insightsStream(byFieldId: Int?, byCategory: String?, onlyHighlights: Bool, cycleId: Int?, publicationYear: Int?) -> Observable<[InsightServerModel]>
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func insightsStreamByFarms<M1: Cuckoo.Matchable, M2: Cuckoo.OptionalMatchable, M3: Cuckoo.Matchable, M4: Cuckoo.Matchable>(whereDateGreaterThanOrEqualTo fromDate: M1, limit: M2, onlyHighlights: M3, fieldsIds: M4) -> Cuckoo.ProtocolStubFunction<(Date, Int?, Bool, [Int]), Observable<[InsightServerModel]>> where M1.MatchedType == Date, M2.OptionalMatchedType == Int, M3.MatchedType == Bool, M4.MatchedType == [Int] {
            let matchers: [Cuckoo.ParameterMatcher<(Date, Int?, Bool, [Int])>] = [wrap(matchable: fromDate) { $0.0 }, wrap(matchable: limit) { $0.1 }, wrap(matchable: onlyHighlights) { $0.2 }, wrap(matchable: fieldsIds) { $0.3 }]
            return .init(stub: cuckoo_manager.createStub(for: MockInsightsRepositoryProtocol.self, method:
    """
    insightsStreamByFarms(whereDateGreaterThanOrEqualTo: Date, limit: Int?, onlyHighlights: Bool, fieldsIds: [Int]) -> Observable<[InsightServerModel]>
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func insightsStreamFilteredByCriteria<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(fieldId: M1, criteria: M2) -> Cuckoo.ProtocolStubFunction<(Int, [FilterCriterion]), Observable<[InsightServerModel]>> where M1.MatchedType == Int, M2.MatchedType == [FilterCriterion] {
            let matchers: [Cuckoo.ParameterMatcher<(Int, [FilterCriterion])>] = [wrap(matchable: fieldId) { $0.0 }, wrap(matchable: criteria) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockInsightsRepositoryProtocol.self, method:
    """
    insightsStreamFilteredByCriteria(fieldId: Int, criteria: [FilterCriterion]) -> Observable<[InsightServerModel]>
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func welcomeInsightStream() -> Cuckoo.ProtocolStubFunction<(), Observable<[InsightServerModel]>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockInsightsRepositoryProtocol.self, method:
    """
    welcomeInsightStream() -> Observable<[InsightServerModel]>
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func locations<M1: Cuckoo.Matchable>(forInsightUID insightUID: M1) -> Cuckoo.ProtocolStubFunction<(String), Observable<[InsightAttachmentServerModel]>> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: insightUID) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockInsightsRepositoryProtocol.self, method:
    """
    locations(forInsightUID: String) -> Observable<[InsightAttachmentServerModel]>
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func insight<M1: Cuckoo.Matchable>(byUID uid: M1) -> Cuckoo.ProtocolStubFunction<(String), Observable<InsightServerModel?>> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: uid) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockInsightsRepositoryProtocol.self, method:
    """
    insight(byUID: String) -> Observable<InsightServerModel?>
    """, parameterMatchers: matchers))
        }
        
        
    }

     struct __VerificationProxy_InsightsRepositoryProtocol: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
         init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
    
        
        
        
        @discardableResult
        func insightsStream<M1: Cuckoo.Matchable, M2: Cuckoo.OptionalMatchable, M3: Cuckoo.Matchable>(whereDateGreaterThanOrEqualTo fromDate: M1, limit: M2, onlyHighlights: M3) -> Cuckoo.__DoNotUse<(Date, Int?, Bool), Observable<[InsightServerModel]>> where M1.MatchedType == Date, M2.OptionalMatchedType == Int, M3.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(Date, Int?, Bool)>] = [wrap(matchable: fromDate) { $0.0 }, wrap(matchable: limit) { $0.1 }, wrap(matchable: onlyHighlights) { $0.2 }]
            return cuckoo_manager.verify(
    """
    insightsStream(whereDateGreaterThanOrEqualTo: Date, limit: Int?, onlyHighlights: Bool) -> Observable<[InsightServerModel]>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func insightsStream<M1: Cuckoo.OptionalMatchable, M2: Cuckoo.OptionalMatchable, M3: Cuckoo.Matchable, M4: Cuckoo.OptionalMatchable, M5: Cuckoo.OptionalMatchable>(byFieldId: M1, byCategory: M2, onlyHighlights: M3, cycleId: M4, publicationYear: M5) -> Cuckoo.__DoNotUse<(Int?, String?, Bool, Int?, Int?), Observable<[InsightServerModel]>> where M1.OptionalMatchedType == Int, M2.OptionalMatchedType == String, M3.MatchedType == Bool, M4.OptionalMatchedType == Int, M5.OptionalMatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Int?, String?, Bool, Int?, Int?)>] = [wrap(matchable: byFieldId) { $0.0 }, wrap(matchable: byCategory) { $0.1 }, wrap(matchable: onlyHighlights) { $0.2 }, wrap(matchable: cycleId) { $0.3 }, wrap(matchable: publicationYear) { $0.4 }]
            return cuckoo_manager.verify(
    """
    insightsStream(byFieldId: Int?, byCategory: String?, onlyHighlights: Bool, cycleId: Int?, publicationYear: Int?) -> Observable<[InsightServerModel]>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func insightsStreamByFarms<M1: Cuckoo.Matchable, M2: Cuckoo.OptionalMatchable, M3: Cuckoo.Matchable, M4: Cuckoo.Matchable>(whereDateGreaterThanOrEqualTo fromDate: M1, limit: M2, onlyHighlights: M3, fieldsIds: M4) -> Cuckoo.__DoNotUse<(Date, Int?, Bool, [Int]), Observable<[InsightServerModel]>> where M1.MatchedType == Date, M2.OptionalMatchedType == Int, M3.MatchedType == Bool, M4.MatchedType == [Int] {
            let matchers: [Cuckoo.ParameterMatcher<(Date, Int?, Bool, [Int])>] = [wrap(matchable: fromDate) { $0.0 }, wrap(matchable: limit) { $0.1 }, wrap(matchable: onlyHighlights) { $0.2 }, wrap(matchable: fieldsIds) { $0.3 }]
            return cuckoo_manager.verify(
    """
    insightsStreamByFarms(whereDateGreaterThanOrEqualTo: Date, limit: Int?, onlyHighlights: Bool, fieldsIds: [Int]) -> Observable<[InsightServerModel]>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func insightsStreamFilteredByCriteria<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(fieldId: M1, criteria: M2) -> Cuckoo.__DoNotUse<(Int, [FilterCriterion]), Observable<[InsightServerModel]>> where M1.MatchedType == Int, M2.MatchedType == [FilterCriterion] {
            let matchers: [Cuckoo.ParameterMatcher<(Int, [FilterCriterion])>] = [wrap(matchable: fieldId) { $0.0 }, wrap(matchable: criteria) { $0.1 }]
            return cuckoo_manager.verify(
    """
    insightsStreamFilteredByCriteria(fieldId: Int, criteria: [FilterCriterion]) -> Observable<[InsightServerModel]>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func welcomeInsightStream() -> Cuckoo.__DoNotUse<(), Observable<[InsightServerModel]>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    welcomeInsightStream() -> Observable<[InsightServerModel]>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func locations<M1: Cuckoo.Matchable>(forInsightUID insightUID: M1) -> Cuckoo.__DoNotUse<(String), Observable<[InsightAttachmentServerModel]>> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: insightUID) { $0 }]
            return cuckoo_manager.verify(
    """
    locations(forInsightUID: String) -> Observable<[InsightAttachmentServerModel]>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func insight<M1: Cuckoo.Matchable>(byUID uid: M1) -> Cuckoo.__DoNotUse<(String), Observable<InsightServerModel?>> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: uid) { $0 }]
            return cuckoo_manager.verify(
    """
    insight(byUID: String) -> Observable<InsightServerModel?>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


 class InsightsRepositoryProtocolStub: InsightsRepositoryProtocol {
    

    

    
    
    
    
     func insightsStream(whereDateGreaterThanOrEqualTo fromDate: Date, limit: Int?, onlyHighlights: Bool) -> Observable<[InsightServerModel]>  {
        return DefaultValueRegistry.defaultValue(for: (Observable<[InsightServerModel]>).self)
    }
    
    
    
    
    
     func insightsStream(byFieldId: Int?, byCategory: String?, onlyHighlights: Bool, cycleId: Int?, publicationYear: Int?) -> Observable<[InsightServerModel]>  {
        return DefaultValueRegistry.defaultValue(for: (Observable<[InsightServerModel]>).self)
    }
    
    
    
    
    
     func insightsStreamByFarms(whereDateGreaterThanOrEqualTo fromDate: Date, limit: Int?, onlyHighlights: Bool, fieldsIds: [Int]) -> Observable<[InsightServerModel]>  {
        return DefaultValueRegistry.defaultValue(for: (Observable<[InsightServerModel]>).self)
    }
    
    
    
    
    
     func insightsStreamFilteredByCriteria(fieldId: Int, criteria: [FilterCriterion]) -> Observable<[InsightServerModel]>  {
        return DefaultValueRegistry.defaultValue(for: (Observable<[InsightServerModel]>).self)
    }
    
    
    
    
    
     func welcomeInsightStream() -> Observable<[InsightServerModel]>  {
        return DefaultValueRegistry.defaultValue(for: (Observable<[InsightServerModel]>).self)
    }
    
    
    
    
    
     func locations(forInsightUID insightUID: String) -> Observable<[InsightAttachmentServerModel]>  {
        return DefaultValueRegistry.defaultValue(for: (Observable<[InsightAttachmentServerModel]>).self)
    }
    
    
    
    
    
     func insight(byUID uid: String) -> Observable<InsightServerModel?>  {
        return DefaultValueRegistry.defaultValue(for: (Observable<InsightServerModel?>).self)
    }
    
    
}





// MARK: - Mocks generated from file: Openfield/Infra/Data/Repositories/RemoteConfigRepositoryProtocol.swift at 2024-11-17 14:51:25 +0000

//
//  RemoteConfigRepositoryProtocol.swift
//  Openfield
//
//  Created by Yoni Luz on 11/01/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Cuckoo
@testable import Openfield

import Foundation
import RxSwift






 class MockRemoteConfigRepositoryProtocol: RemoteConfigRepositoryProtocol, Cuckoo.ProtocolMock {
    
     typealias MocksType = RemoteConfigRepositoryProtocol
    
     typealias Stubbing = __StubbingProxy_RemoteConfigRepositoryProtocol
     typealias Verification = __VerificationProxy_RemoteConfigRepositoryProtocol

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: RemoteConfigRepositoryProtocol?

     func enableDefaultImplementation(_ stub: RemoteConfigRepositoryProtocol) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    
     func fetchConfigs(forceRefresh: Bool) -> Completable {
        
    return cuckoo_manager.call(
    """
    fetchConfigs(forceRefresh: Bool) -> Completable
    """,
            parameters: (forceRefresh),
            escapingParameters: (forceRefresh),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.fetchConfigs(forceRefresh: forceRefresh))
        
    }
    
    
    
    
    
     func dictionary(forKey key: String) -> [String: Any] {
        
    return cuckoo_manager.call(
    """
    dictionary(forKey: String) -> [String: Any]
    """,
            parameters: (key),
            escapingParameters: (key),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.dictionary(forKey: key))
        
    }
    
    
    
    
    
     func bool(forKey key: RemoteConfigParameterKey) -> Bool {
        
    return cuckoo_manager.call(
    """
    bool(forKey: RemoteConfigParameterKey) -> Bool
    """,
            parameters: (key),
            escapingParameters: (key),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.bool(forKey: key))
        
    }
    
    
    
    
    
     func string(forKey key: RemoteConfigParameterKey) -> String {
        
    return cuckoo_manager.call(
    """
    string(forKey: RemoteConfigParameterKey) -> String
    """,
            parameters: (key),
            escapingParameters: (key),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.string(forKey: key))
        
    }
    
    
    
    
    
     func data(forKey key: RemoteConfigParameterKey) -> Data {
        
    return cuckoo_manager.call(
    """
    data(forKey: RemoteConfigParameterKey) -> Data
    """,
            parameters: (key),
            escapingParameters: (key),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.data(forKey: key))
        
    }
    
    
    
    
    
     func int(forKey key: RemoteConfigParameterKey) -> Int {
        
    return cuckoo_manager.call(
    """
    int(forKey: RemoteConfigParameterKey) -> Int
    """,
            parameters: (key),
            escapingParameters: (key),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.int(forKey: key))
        
    }
    
    
    
    
    
     func dictionary(forKey key: RemoteConfigParameterKey) -> [String: Any] {
        
    return cuckoo_manager.call(
    """
    dictionary(forKey: RemoteConfigParameterKey) -> [String: Any]
    """,
            parameters: (key),
            escapingParameters: (key),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.dictionary(forKey: key))
        
    }
    
    
    
    
    
     func double(forKey key: RemoteConfigParameterKey) -> Double {
        
    return cuckoo_manager.call(
    """
    double(forKey: RemoteConfigParameterKey) -> Double
    """,
            parameters: (key),
            escapingParameters: (key),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.double(forKey: key))
        
    }
    
    
    
    
    
     func getDefaultValue<T>(forKey key: String) -> T? {
        
    return cuckoo_manager.call(
    """
    getDefaultValue(forKey: String) -> T?
    """,
            parameters: (key),
            escapingParameters: (key),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.getDefaultValue(forKey: key))
        
    }
    
    

     struct __StubbingProxy_RemoteConfigRepositoryProtocol: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func fetchConfigs<M1: Cuckoo.Matchable>(forceRefresh: M1) -> Cuckoo.ProtocolStubFunction<(Bool), Completable> where M1.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(Bool)>] = [wrap(matchable: forceRefresh) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockRemoteConfigRepositoryProtocol.self, method:
    """
    fetchConfigs(forceRefresh: Bool) -> Completable
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func dictionary<M1: Cuckoo.Matchable>(forKey key: M1) -> Cuckoo.ProtocolStubFunction<(String), [String: Any]> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: key) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockRemoteConfigRepositoryProtocol.self, method:
    """
    dictionary(forKey: String) -> [String: Any]
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func bool<M1: Cuckoo.Matchable>(forKey key: M1) -> Cuckoo.ProtocolStubFunction<(RemoteConfigParameterKey), Bool> where M1.MatchedType == RemoteConfigParameterKey {
            let matchers: [Cuckoo.ParameterMatcher<(RemoteConfigParameterKey)>] = [wrap(matchable: key) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockRemoteConfigRepositoryProtocol.self, method:
    """
    bool(forKey: RemoteConfigParameterKey) -> Bool
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func string<M1: Cuckoo.Matchable>(forKey key: M1) -> Cuckoo.ProtocolStubFunction<(RemoteConfigParameterKey), String> where M1.MatchedType == RemoteConfigParameterKey {
            let matchers: [Cuckoo.ParameterMatcher<(RemoteConfigParameterKey)>] = [wrap(matchable: key) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockRemoteConfigRepositoryProtocol.self, method:
    """
    string(forKey: RemoteConfigParameterKey) -> String
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func data<M1: Cuckoo.Matchable>(forKey key: M1) -> Cuckoo.ProtocolStubFunction<(RemoteConfigParameterKey), Data> where M1.MatchedType == RemoteConfigParameterKey {
            let matchers: [Cuckoo.ParameterMatcher<(RemoteConfigParameterKey)>] = [wrap(matchable: key) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockRemoteConfigRepositoryProtocol.self, method:
    """
    data(forKey: RemoteConfigParameterKey) -> Data
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func int<M1: Cuckoo.Matchable>(forKey key: M1) -> Cuckoo.ProtocolStubFunction<(RemoteConfigParameterKey), Int> where M1.MatchedType == RemoteConfigParameterKey {
            let matchers: [Cuckoo.ParameterMatcher<(RemoteConfigParameterKey)>] = [wrap(matchable: key) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockRemoteConfigRepositoryProtocol.self, method:
    """
    int(forKey: RemoteConfigParameterKey) -> Int
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func dictionary<M1: Cuckoo.Matchable>(forKey key: M1) -> Cuckoo.ProtocolStubFunction<(RemoteConfigParameterKey), [String: Any]> where M1.MatchedType == RemoteConfigParameterKey {
            let matchers: [Cuckoo.ParameterMatcher<(RemoteConfigParameterKey)>] = [wrap(matchable: key) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockRemoteConfigRepositoryProtocol.self, method:
    """
    dictionary(forKey: RemoteConfigParameterKey) -> [String: Any]
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func double<M1: Cuckoo.Matchable>(forKey key: M1) -> Cuckoo.ProtocolStubFunction<(RemoteConfigParameterKey), Double> where M1.MatchedType == RemoteConfigParameterKey {
            let matchers: [Cuckoo.ParameterMatcher<(RemoteConfigParameterKey)>] = [wrap(matchable: key) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockRemoteConfigRepositoryProtocol.self, method:
    """
    double(forKey: RemoteConfigParameterKey) -> Double
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func getDefaultValue<M1: Cuckoo.Matchable, T>(forKey key: M1) -> Cuckoo.ProtocolStubFunction<(String), T?> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: key) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockRemoteConfigRepositoryProtocol.self, method:
    """
    getDefaultValue(forKey: String) -> T?
    """, parameterMatchers: matchers))
        }
        
        
    }

     struct __VerificationProxy_RemoteConfigRepositoryProtocol: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
         init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
    
        
        
        
        @discardableResult
        func fetchConfigs<M1: Cuckoo.Matchable>(forceRefresh: M1) -> Cuckoo.__DoNotUse<(Bool), Completable> where M1.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(Bool)>] = [wrap(matchable: forceRefresh) { $0 }]
            return cuckoo_manager.verify(
    """
    fetchConfigs(forceRefresh: Bool) -> Completable
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func dictionary<M1: Cuckoo.Matchable>(forKey key: M1) -> Cuckoo.__DoNotUse<(String), [String: Any]> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: key) { $0 }]
            return cuckoo_manager.verify(
    """
    dictionary(forKey: String) -> [String: Any]
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func bool<M1: Cuckoo.Matchable>(forKey key: M1) -> Cuckoo.__DoNotUse<(RemoteConfigParameterKey), Bool> where M1.MatchedType == RemoteConfigParameterKey {
            let matchers: [Cuckoo.ParameterMatcher<(RemoteConfigParameterKey)>] = [wrap(matchable: key) { $0 }]
            return cuckoo_manager.verify(
    """
    bool(forKey: RemoteConfigParameterKey) -> Bool
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func string<M1: Cuckoo.Matchable>(forKey key: M1) -> Cuckoo.__DoNotUse<(RemoteConfigParameterKey), String> where M1.MatchedType == RemoteConfigParameterKey {
            let matchers: [Cuckoo.ParameterMatcher<(RemoteConfigParameterKey)>] = [wrap(matchable: key) { $0 }]
            return cuckoo_manager.verify(
    """
    string(forKey: RemoteConfigParameterKey) -> String
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func data<M1: Cuckoo.Matchable>(forKey key: M1) -> Cuckoo.__DoNotUse<(RemoteConfigParameterKey), Data> where M1.MatchedType == RemoteConfigParameterKey {
            let matchers: [Cuckoo.ParameterMatcher<(RemoteConfigParameterKey)>] = [wrap(matchable: key) { $0 }]
            return cuckoo_manager.verify(
    """
    data(forKey: RemoteConfigParameterKey) -> Data
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func int<M1: Cuckoo.Matchable>(forKey key: M1) -> Cuckoo.__DoNotUse<(RemoteConfigParameterKey), Int> where M1.MatchedType == RemoteConfigParameterKey {
            let matchers: [Cuckoo.ParameterMatcher<(RemoteConfigParameterKey)>] = [wrap(matchable: key) { $0 }]
            return cuckoo_manager.verify(
    """
    int(forKey: RemoteConfigParameterKey) -> Int
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func dictionary<M1: Cuckoo.Matchable>(forKey key: M1) -> Cuckoo.__DoNotUse<(RemoteConfigParameterKey), [String: Any]> where M1.MatchedType == RemoteConfigParameterKey {
            let matchers: [Cuckoo.ParameterMatcher<(RemoteConfigParameterKey)>] = [wrap(matchable: key) { $0 }]
            return cuckoo_manager.verify(
    """
    dictionary(forKey: RemoteConfigParameterKey) -> [String: Any]
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func double<M1: Cuckoo.Matchable>(forKey key: M1) -> Cuckoo.__DoNotUse<(RemoteConfigParameterKey), Double> where M1.MatchedType == RemoteConfigParameterKey {
            let matchers: [Cuckoo.ParameterMatcher<(RemoteConfigParameterKey)>] = [wrap(matchable: key) { $0 }]
            return cuckoo_manager.verify(
    """
    double(forKey: RemoteConfigParameterKey) -> Double
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func getDefaultValue<M1: Cuckoo.Matchable, T>(forKey key: M1) -> Cuckoo.__DoNotUse<(String), T?> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: key) { $0 }]
            return cuckoo_manager.verify(
    """
    getDefaultValue(forKey: String) -> T?
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


 class RemoteConfigRepositoryProtocolStub: RemoteConfigRepositoryProtocol {
    

    

    
    
    
    
     func fetchConfigs(forceRefresh: Bool) -> Completable  {
        return DefaultValueRegistry.defaultValue(for: (Completable).self)
    }
    
    
    
    
    
     func dictionary(forKey key: String) -> [String: Any]  {
        return DefaultValueRegistry.defaultValue(for: ([String: Any]).self)
    }
    
    
    
    
    
     func bool(forKey key: RemoteConfigParameterKey) -> Bool  {
        return DefaultValueRegistry.defaultValue(for: (Bool).self)
    }
    
    
    
    
    
     func string(forKey key: RemoteConfigParameterKey) -> String  {
        return DefaultValueRegistry.defaultValue(for: (String).self)
    }
    
    
    
    
    
     func data(forKey key: RemoteConfigParameterKey) -> Data  {
        return DefaultValueRegistry.defaultValue(for: (Data).self)
    }
    
    
    
    
    
     func int(forKey key: RemoteConfigParameterKey) -> Int  {
        return DefaultValueRegistry.defaultValue(for: (Int).self)
    }
    
    
    
    
    
     func dictionary(forKey key: RemoteConfigParameterKey) -> [String: Any]  {
        return DefaultValueRegistry.defaultValue(for: ([String: Any]).self)
    }
    
    
    
    
    
     func double(forKey key: RemoteConfigParameterKey) -> Double  {
        return DefaultValueRegistry.defaultValue(for: (Double).self)
    }
    
    
    
    
    
     func getDefaultValue<T>(forKey key: String) -> T?  {
        return DefaultValueRegistry.defaultValue(for: (T?).self)
    }
    
    
}





// MARK: - Mocks generated from file: Openfield/Infra/Data/Repositories/UserRepositoryProtocol.swift at 2024-11-17 14:51:25 +0000

//
//  UserRepositoryProtocol.swift
//  Openfield
//
//  Created by Yoni Luz on 09/01/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Cuckoo
@testable import Openfield

import Foundation
import RxSwift






 class MockUserRepositoryProtocol: UserRepositoryProtocol, Cuckoo.ProtocolMock {
    
     typealias MocksType = UserRepositoryProtocol
    
     typealias Stubbing = __StubbingProxy_UserRepositoryProtocol
     typealias Verification = __VerificationProxy_UserRepositoryProtocol

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: UserRepositoryProtocol?

     func enableDefaultImplementation(_ stub: UserRepositoryProtocol) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    
     func createUserStream() -> Observable<UserServerModel> {
        
    return cuckoo_manager.call(
    """
    createUserStream() -> Observable<UserServerModel>
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.createUserStream())
        
    }
    
    

     struct __StubbingProxy_UserRepositoryProtocol: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func createUserStream() -> Cuckoo.ProtocolStubFunction<(), Observable<UserServerModel>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockUserRepositoryProtocol.self, method:
    """
    createUserStream() -> Observable<UserServerModel>
    """, parameterMatchers: matchers))
        }
        
        
    }

     struct __VerificationProxy_UserRepositoryProtocol: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
         init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
    
        
        
        
        @discardableResult
        func createUserStream() -> Cuckoo.__DoNotUse<(), Observable<UserServerModel>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    createUserStream() -> Observable<UserServerModel>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


 class UserRepositoryProtocolStub: UserRepositoryProtocol {
    

    

    
    
    
    
     func createUserStream() -> Observable<UserServerModel>  {
        return DefaultValueRegistry.defaultValue(for: (Observable<UserServerModel>).self)
    }
    
    
}





// MARK: - Mocks generated from file: Openfield/Infra/Data/Repositories/VirtualScoutingRepositoryProtocol.swift at 2024-11-17 14:51:25 +0000

//
//  VirtualScoutingRepositoryProtocol.swift
//  Openfield
//
//  Created by Yoni Luz on 18/06/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Cuckoo
@testable import Openfield

import Foundation
import RxSwift






 class MockVirtualScoutingRepositoryProtocol: VirtualScoutingRepositoryProtocol, Cuckoo.ProtocolMock {
    
     typealias MocksType = VirtualScoutingRepositoryProtocol
    
     typealias Stubbing = __StubbingProxy_VirtualScoutingRepositoryProtocol
     typealias Verification = __VerificationProxy_VirtualScoutingRepositoryProtocol

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: VirtualScoutingRepositoryProtocol?

     func enableDefaultImplementation(_ stub: VirtualScoutingRepositoryProtocol) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    
     func getDates(fieldId: Int, cycleId: Int, limit: Int?) -> Observable<[VirtualScoutingDateServerModel]> {
        
    return cuckoo_manager.call(
    """
    getDates(fieldId: Int, cycleId: Int, limit: Int?) -> Observable<[VirtualScoutingDateServerModel]>
    """,
            parameters: (fieldId, cycleId, limit),
            escapingParameters: (fieldId, cycleId, limit),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.getDates(fieldId: fieldId, cycleId: cycleId, limit: limit))
        
    }
    
    
    
    
    
     func getGrid(gridId: String) -> Observable<VirtualScoutingGridServerModel> {
        
    return cuckoo_manager.call(
    """
    getGrid(gridId: String) -> Observable<VirtualScoutingGridServerModel>
    """,
            parameters: (gridId),
            escapingParameters: (gridId),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.getGrid(gridId: gridId))
        
    }
    
    
    
    
    
     func getImages(cellId: Int) -> Observable<[VirtualScoutingImage]> {
        
    return cuckoo_manager.call(
    """
    getImages(cellId: Int) -> Observable<[VirtualScoutingImage]>
    """,
            parameters: (cellId),
            escapingParameters: (cellId),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.getImages(cellId: cellId))
        
    }
    
    

     struct __StubbingProxy_VirtualScoutingRepositoryProtocol: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func getDates<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.OptionalMatchable>(fieldId: M1, cycleId: M2, limit: M3) -> Cuckoo.ProtocolStubFunction<(Int, Int, Int?), Observable<[VirtualScoutingDateServerModel]>> where M1.MatchedType == Int, M2.MatchedType == Int, M3.OptionalMatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Int, Int, Int?)>] = [wrap(matchable: fieldId) { $0.0 }, wrap(matchable: cycleId) { $0.1 }, wrap(matchable: limit) { $0.2 }]
            return .init(stub: cuckoo_manager.createStub(for: MockVirtualScoutingRepositoryProtocol.self, method:
    """
    getDates(fieldId: Int, cycleId: Int, limit: Int?) -> Observable<[VirtualScoutingDateServerModel]>
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func getGrid<M1: Cuckoo.Matchable>(gridId: M1) -> Cuckoo.ProtocolStubFunction<(String), Observable<VirtualScoutingGridServerModel>> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: gridId) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockVirtualScoutingRepositoryProtocol.self, method:
    """
    getGrid(gridId: String) -> Observable<VirtualScoutingGridServerModel>
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func getImages<M1: Cuckoo.Matchable>(cellId: M1) -> Cuckoo.ProtocolStubFunction<(Int), Observable<[VirtualScoutingImage]>> where M1.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Int)>] = [wrap(matchable: cellId) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockVirtualScoutingRepositoryProtocol.self, method:
    """
    getImages(cellId: Int) -> Observable<[VirtualScoutingImage]>
    """, parameterMatchers: matchers))
        }
        
        
    }

     struct __VerificationProxy_VirtualScoutingRepositoryProtocol: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
         init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
    
        
        
        
        @discardableResult
        func getDates<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.OptionalMatchable>(fieldId: M1, cycleId: M2, limit: M3) -> Cuckoo.__DoNotUse<(Int, Int, Int?), Observable<[VirtualScoutingDateServerModel]>> where M1.MatchedType == Int, M2.MatchedType == Int, M3.OptionalMatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Int, Int, Int?)>] = [wrap(matchable: fieldId) { $0.0 }, wrap(matchable: cycleId) { $0.1 }, wrap(matchable: limit) { $0.2 }]
            return cuckoo_manager.verify(
    """
    getDates(fieldId: Int, cycleId: Int, limit: Int?) -> Observable<[VirtualScoutingDateServerModel]>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func getGrid<M1: Cuckoo.Matchable>(gridId: M1) -> Cuckoo.__DoNotUse<(String), Observable<VirtualScoutingGridServerModel>> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: gridId) { $0 }]
            return cuckoo_manager.verify(
    """
    getGrid(gridId: String) -> Observable<VirtualScoutingGridServerModel>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func getImages<M1: Cuckoo.Matchable>(cellId: M1) -> Cuckoo.__DoNotUse<(Int), Observable<[VirtualScoutingImage]>> where M1.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Int)>] = [wrap(matchable: cellId) { $0 }]
            return cuckoo_manager.verify(
    """
    getImages(cellId: Int) -> Observable<[VirtualScoutingImage]>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


 class VirtualScoutingRepositoryProtocolStub: VirtualScoutingRepositoryProtocol {
    

    

    
    
    
    
     func getDates(fieldId: Int, cycleId: Int, limit: Int?) -> Observable<[VirtualScoutingDateServerModel]>  {
        return DefaultValueRegistry.defaultValue(for: (Observable<[VirtualScoutingDateServerModel]>).self)
    }
    
    
    
    
    
     func getGrid(gridId: String) -> Observable<VirtualScoutingGridServerModel>  {
        return DefaultValueRegistry.defaultValue(for: (Observable<VirtualScoutingGridServerModel>).self)
    }
    
    
    
    
    
     func getImages(cellId: Int) -> Observable<[VirtualScoutingImage]>  {
        return DefaultValueRegistry.defaultValue(for: (Observable<[VirtualScoutingImage]>).self)
    }
    
    
}





// MARK: - Mocks generated from file: Openfield/Infra/Data/Usecases/FieldUseCaseProtocol.swift at 2024-11-17 14:51:25 +0000

//
//  FieldUseCaseProtocol.swift
//  Openfield
//
//  Created by Yoni Luz on 23/01/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Cuckoo
@testable import Openfield

import Foundation
import RxSwift






 class MockFieldUseCaseProtocol: FieldUseCaseProtocol, Cuckoo.ProtocolMock {
    
     typealias MocksType = FieldUseCaseProtocol
    
     typealias Stubbing = __StubbingProxy_FieldUseCaseProtocol
     typealias Verification = __VerificationProxy_FieldUseCaseProtocol

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: FieldUseCaseProtocol?

     func enableDefaultImplementation(_ stub: FieldUseCaseProtocol) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    
     func getFieldWithImages(fieldId: Int) -> Observable<Field> {
        
    return cuckoo_manager.call(
    """
    getFieldWithImages(fieldId: Int) -> Observable<Field>
    """,
            parameters: (fieldId),
            escapingParameters: (fieldId),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.getFieldWithImages(fieldId: fieldId))
        
    }
    
    
    
    
    
     func getFieldWithoutImages(fieldId: Int) -> Observable<Field> {
        
    return cuckoo_manager.call(
    """
    getFieldWithoutImages(fieldId: Int) -> Observable<Field>
    """,
            parameters: (fieldId),
            escapingParameters: (fieldId),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.getFieldWithoutImages(fieldId: fieldId))
        
    }
    
    
    
    
    
     func getFieldWithLastImage(fieldId: Int) -> Observable<Field> {
        
    return cuckoo_manager.call(
    """
    getFieldWithLastImage(fieldId: Int) -> Observable<Field>
    """,
            parameters: (fieldId),
            escapingParameters: (fieldId),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.getFieldWithLastImage(fieldId: fieldId))
        
    }
    
    
    
    
    
     func getFilteredFieldWithImages(fieldId: Int, criteria: [FilterCriterion]) -> Observable<Field> {
        
    return cuckoo_manager.call(
    """
    getFilteredFieldWithImages(fieldId: Int, criteria: [FilterCriterion]) -> Observable<Field>
    """,
            parameters: (fieldId, criteria),
            escapingParameters: (fieldId, criteria),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.getFilteredFieldWithImages(fieldId: fieldId, criteria: criteria))
        
    }
    
    

     struct __StubbingProxy_FieldUseCaseProtocol: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func getFieldWithImages<M1: Cuckoo.Matchable>(fieldId: M1) -> Cuckoo.ProtocolStubFunction<(Int), Observable<Field>> where M1.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Int)>] = [wrap(matchable: fieldId) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockFieldUseCaseProtocol.self, method:
    """
    getFieldWithImages(fieldId: Int) -> Observable<Field>
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func getFieldWithoutImages<M1: Cuckoo.Matchable>(fieldId: M1) -> Cuckoo.ProtocolStubFunction<(Int), Observable<Field>> where M1.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Int)>] = [wrap(matchable: fieldId) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockFieldUseCaseProtocol.self, method:
    """
    getFieldWithoutImages(fieldId: Int) -> Observable<Field>
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func getFieldWithLastImage<M1: Cuckoo.Matchable>(fieldId: M1) -> Cuckoo.ProtocolStubFunction<(Int), Observable<Field>> where M1.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Int)>] = [wrap(matchable: fieldId) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockFieldUseCaseProtocol.self, method:
    """
    getFieldWithLastImage(fieldId: Int) -> Observable<Field>
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func getFilteredFieldWithImages<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(fieldId: M1, criteria: M2) -> Cuckoo.ProtocolStubFunction<(Int, [FilterCriterion]), Observable<Field>> where M1.MatchedType == Int, M2.MatchedType == [FilterCriterion] {
            let matchers: [Cuckoo.ParameterMatcher<(Int, [FilterCriterion])>] = [wrap(matchable: fieldId) { $0.0 }, wrap(matchable: criteria) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockFieldUseCaseProtocol.self, method:
    """
    getFilteredFieldWithImages(fieldId: Int, criteria: [FilterCriterion]) -> Observable<Field>
    """, parameterMatchers: matchers))
        }
        
        
    }

     struct __VerificationProxy_FieldUseCaseProtocol: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
         init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
    
        
        
        
        @discardableResult
        func getFieldWithImages<M1: Cuckoo.Matchable>(fieldId: M1) -> Cuckoo.__DoNotUse<(Int), Observable<Field>> where M1.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Int)>] = [wrap(matchable: fieldId) { $0 }]
            return cuckoo_manager.verify(
    """
    getFieldWithImages(fieldId: Int) -> Observable<Field>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func getFieldWithoutImages<M1: Cuckoo.Matchable>(fieldId: M1) -> Cuckoo.__DoNotUse<(Int), Observable<Field>> where M1.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Int)>] = [wrap(matchable: fieldId) { $0 }]
            return cuckoo_manager.verify(
    """
    getFieldWithoutImages(fieldId: Int) -> Observable<Field>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func getFieldWithLastImage<M1: Cuckoo.Matchable>(fieldId: M1) -> Cuckoo.__DoNotUse<(Int), Observable<Field>> where M1.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Int)>] = [wrap(matchable: fieldId) { $0 }]
            return cuckoo_manager.verify(
    """
    getFieldWithLastImage(fieldId: Int) -> Observable<Field>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func getFilteredFieldWithImages<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(fieldId: M1, criteria: M2) -> Cuckoo.__DoNotUse<(Int, [FilterCriterion]), Observable<Field>> where M1.MatchedType == Int, M2.MatchedType == [FilterCriterion] {
            let matchers: [Cuckoo.ParameterMatcher<(Int, [FilterCriterion])>] = [wrap(matchable: fieldId) { $0.0 }, wrap(matchable: criteria) { $0.1 }]
            return cuckoo_manager.verify(
    """
    getFilteredFieldWithImages(fieldId: Int, criteria: [FilterCriterion]) -> Observable<Field>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


 class FieldUseCaseProtocolStub: FieldUseCaseProtocol {
    

    

    
    
    
    
     func getFieldWithImages(fieldId: Int) -> Observable<Field>  {
        return DefaultValueRegistry.defaultValue(for: (Observable<Field>).self)
    }
    
    
    
    
    
     func getFieldWithoutImages(fieldId: Int) -> Observable<Field>  {
        return DefaultValueRegistry.defaultValue(for: (Observable<Field>).self)
    }
    
    
    
    
    
     func getFieldWithLastImage(fieldId: Int) -> Observable<Field>  {
        return DefaultValueRegistry.defaultValue(for: (Observable<Field>).self)
    }
    
    
    
    
    
     func getFilteredFieldWithImages(fieldId: Int, criteria: [FilterCriterion]) -> Observable<Field>  {
        return DefaultValueRegistry.defaultValue(for: (Observable<Field>).self)
    }
    
    
}





// MARK: - Mocks generated from file: Openfield/Infra/Data/Usecases/FieldsUsecaseProtocol.swift at 2024-11-17 14:51:25 +0000

//
//  FieldsUsecaseProtocol.swift
//  Openfield
//
//  Created by Yoni Luz on 11/01/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Cuckoo
@testable import Openfield

import Foundation
import RxSwift






 class MockFieldsUsecaseProtocol: FieldsUsecaseProtocol, Cuckoo.ProtocolMock {
    
     typealias MocksType = FieldsUsecaseProtocol
    
     typealias Stubbing = __StubbingProxy_FieldsUsecaseProtocol
     typealias Verification = __VerificationProxy_FieldsUsecaseProtocol

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: FieldsUsecaseProtocol?

     func enableDefaultImplementation(_ stub: FieldsUsecaseProtocol) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    
     func getFieldsWithoutImages() -> Observable<[Field]> {
        
    return cuckoo_manager.call(
    """
    getFieldsWithoutImages() -> Observable<[Field]>
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.getFieldsWithoutImages())
        
    }
    
    
    
    
    
     func getFieldsWithImages(imagesFromDate: Date) -> Observable<[Field]> {
        
    return cuckoo_manager.call(
    """
    getFieldsWithImages(imagesFromDate: Date) -> Observable<[Field]>
    """,
            parameters: (imagesFromDate),
            escapingParameters: (imagesFromDate),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.getFieldsWithImages(imagesFromDate: imagesFromDate))
        
    }
    
    

     struct __StubbingProxy_FieldsUsecaseProtocol: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func getFieldsWithoutImages() -> Cuckoo.ProtocolStubFunction<(), Observable<[Field]>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockFieldsUsecaseProtocol.self, method:
    """
    getFieldsWithoutImages() -> Observable<[Field]>
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func getFieldsWithImages<M1: Cuckoo.Matchable>(imagesFromDate: M1) -> Cuckoo.ProtocolStubFunction<(Date), Observable<[Field]>> where M1.MatchedType == Date {
            let matchers: [Cuckoo.ParameterMatcher<(Date)>] = [wrap(matchable: imagesFromDate) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockFieldsUsecaseProtocol.self, method:
    """
    getFieldsWithImages(imagesFromDate: Date) -> Observable<[Field]>
    """, parameterMatchers: matchers))
        }
        
        
    }

     struct __VerificationProxy_FieldsUsecaseProtocol: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
         init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
    
        
        
        
        @discardableResult
        func getFieldsWithoutImages() -> Cuckoo.__DoNotUse<(), Observable<[Field]>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    getFieldsWithoutImages() -> Observable<[Field]>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func getFieldsWithImages<M1: Cuckoo.Matchable>(imagesFromDate: M1) -> Cuckoo.__DoNotUse<(Date), Observable<[Field]>> where M1.MatchedType == Date {
            let matchers: [Cuckoo.ParameterMatcher<(Date)>] = [wrap(matchable: imagesFromDate) { $0 }]
            return cuckoo_manager.verify(
    """
    getFieldsWithImages(imagesFromDate: Date) -> Observable<[Field]>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


 class FieldsUsecaseProtocolStub: FieldsUsecaseProtocol {
    

    

    
    
    
    
     func getFieldsWithoutImages() -> Observable<[Field]>  {
        return DefaultValueRegistry.defaultValue(for: (Observable<[Field]>).self)
    }
    
    
    
    
    
     func getFieldsWithImages(imagesFromDate: Date) -> Observable<[Field]>  {
        return DefaultValueRegistry.defaultValue(for: (Observable<[Field]>).self)
    }
    
    
}





// MARK: - Mocks generated from file: Openfield/Infra/Data/Usecases/InsightsForFieldUsecaseProtocol.swift at 2024-11-17 14:51:25 +0000

//
//  InsightsForFieldUsecaseProtocol.swift
//  Openfield
//
//  Created by Yoni Luz on 31/01/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Cuckoo
@testable import Openfield

import Foundation
import RxSwift






 class MockInsightsForFieldUsecaseProtocol: InsightsForFieldUsecaseProtocol, Cuckoo.ProtocolMock {
    
     typealias MocksType = InsightsForFieldUsecaseProtocol
    
     typealias Stubbing = __StubbingProxy_InsightsForFieldUsecaseProtocol
     typealias Verification = __VerificationProxy_InsightsForFieldUsecaseProtocol

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: InsightsForFieldUsecaseProtocol?

     func enableDefaultImplementation(_ stub: InsightsForFieldUsecaseProtocol) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    
     func insights(forFieldId fieldId: Int) -> Observable<[Insight]> {
        
    return cuckoo_manager.call(
    """
    insights(forFieldId: Int) -> Observable<[Insight]>
    """,
            parameters: (fieldId),
            escapingParameters: (fieldId),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.insights(forFieldId: fieldId))
        
    }
    
    
    
    
    
     func insightsWithFieldFilter(forFieldId fieldId: Int, criteria: [FilterCriterion], order: Int) -> Observable<[Insight]> {
        
    return cuckoo_manager.call(
    """
    insightsWithFieldFilter(forFieldId: Int, criteria: [FilterCriterion], order: Int) -> Observable<[Insight]>
    """,
            parameters: (fieldId, criteria, order),
            escapingParameters: (fieldId, criteria, order),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.insightsWithFieldFilter(forFieldId: fieldId, criteria: criteria, order: order))
        
    }
    
    

     struct __StubbingProxy_InsightsForFieldUsecaseProtocol: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func insights<M1: Cuckoo.Matchable>(forFieldId fieldId: M1) -> Cuckoo.ProtocolStubFunction<(Int), Observable<[Insight]>> where M1.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Int)>] = [wrap(matchable: fieldId) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockInsightsForFieldUsecaseProtocol.self, method:
    """
    insights(forFieldId: Int) -> Observable<[Insight]>
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func insightsWithFieldFilter<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(forFieldId fieldId: M1, criteria: M2, order: M3) -> Cuckoo.ProtocolStubFunction<(Int, [FilterCriterion], Int), Observable<[Insight]>> where M1.MatchedType == Int, M2.MatchedType == [FilterCriterion], M3.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Int, [FilterCriterion], Int)>] = [wrap(matchable: fieldId) { $0.0 }, wrap(matchable: criteria) { $0.1 }, wrap(matchable: order) { $0.2 }]
            return .init(stub: cuckoo_manager.createStub(for: MockInsightsForFieldUsecaseProtocol.self, method:
    """
    insightsWithFieldFilter(forFieldId: Int, criteria: [FilterCriterion], order: Int) -> Observable<[Insight]>
    """, parameterMatchers: matchers))
        }
        
        
    }

     struct __VerificationProxy_InsightsForFieldUsecaseProtocol: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
         init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
    
        
        
        
        @discardableResult
        func insights<M1: Cuckoo.Matchable>(forFieldId fieldId: M1) -> Cuckoo.__DoNotUse<(Int), Observable<[Insight]>> where M1.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Int)>] = [wrap(matchable: fieldId) { $0 }]
            return cuckoo_manager.verify(
    """
    insights(forFieldId: Int) -> Observable<[Insight]>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func insightsWithFieldFilter<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(forFieldId fieldId: M1, criteria: M2, order: M3) -> Cuckoo.__DoNotUse<(Int, [FilterCriterion], Int), Observable<[Insight]>> where M1.MatchedType == Int, M2.MatchedType == [FilterCriterion], M3.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Int, [FilterCriterion], Int)>] = [wrap(matchable: fieldId) { $0.0 }, wrap(matchable: criteria) { $0.1 }, wrap(matchable: order) { $0.2 }]
            return cuckoo_manager.verify(
    """
    insightsWithFieldFilter(forFieldId: Int, criteria: [FilterCriterion], order: Int) -> Observable<[Insight]>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


 class InsightsForFieldUsecaseProtocolStub: InsightsForFieldUsecaseProtocol {
    

    

    
    
    
    
     func insights(forFieldId fieldId: Int) -> Observable<[Insight]>  {
        return DefaultValueRegistry.defaultValue(for: (Observable<[Insight]>).self)
    }
    
    
    
    
    
     func insightsWithFieldFilter(forFieldId fieldId: Int, criteria: [FilterCriterion], order: Int) -> Observable<[Insight]>  {
        return DefaultValueRegistry.defaultValue(for: (Observable<[Insight]>).self)
    }
    
    
}





// MARK: - Mocks generated from file: Openfield/Infra/Data/Usecases/InsightsFromDateUsecaseProtocol.swift at 2024-11-17 14:51:25 +0000

//
//  InsightsFromDateUsecaseProtocol.swift
//  Openfield
//
//  Created by amir avisar on 19/02/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Cuckoo
@testable import Openfield

import Foundation
import RxSwift






 class MockInsightsFromDateUsecaseProtocol: InsightsFromDateUsecaseProtocol, Cuckoo.ProtocolMock {
    
     typealias MocksType = InsightsFromDateUsecaseProtocol
    
     typealias Stubbing = __StubbingProxy_InsightsFromDateUsecaseProtocol
     typealias Verification = __VerificationProxy_InsightsFromDateUsecaseProtocol

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: InsightsFromDateUsecaseProtocol?

     func enableDefaultImplementation(_ stub: InsightsFromDateUsecaseProtocol) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    
     func getInsights(insightsFromDate: Date, limit: Int?, onlyHighlights: Bool) -> Observable<[Insight]> {
        
    return cuckoo_manager.call(
    """
    getInsights(insightsFromDate: Date, limit: Int?, onlyHighlights: Bool) -> Observable<[Insight]>
    """,
            parameters: (insightsFromDate, limit, onlyHighlights),
            escapingParameters: (insightsFromDate, limit, onlyHighlights),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.getInsights(insightsFromDate: insightsFromDate, limit: limit, onlyHighlights: onlyHighlights))
        
    }
    
    
    
    
    
     func getInsightsByFarms(insightsFromDate: Date, limit: Int?, onlyHighlights: Bool, fieldsIds: [Int]) -> Observable<[Insight]> {
        
    return cuckoo_manager.call(
    """
    getInsightsByFarms(insightsFromDate: Date, limit: Int?, onlyHighlights: Bool, fieldsIds: [Int]) -> Observable<[Insight]>
    """,
            parameters: (insightsFromDate, limit, onlyHighlights, fieldsIds),
            escapingParameters: (insightsFromDate, limit, onlyHighlights, fieldsIds),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.getInsightsByFarms(insightsFromDate: insightsFromDate, limit: limit, onlyHighlights: onlyHighlights, fieldsIds: fieldsIds))
        
    }
    
    

     struct __StubbingProxy_InsightsFromDateUsecaseProtocol: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func getInsights<M1: Cuckoo.Matchable, M2: Cuckoo.OptionalMatchable, M3: Cuckoo.Matchable>(insightsFromDate: M1, limit: M2, onlyHighlights: M3) -> Cuckoo.ProtocolStubFunction<(Date, Int?, Bool), Observable<[Insight]>> where M1.MatchedType == Date, M2.OptionalMatchedType == Int, M3.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(Date, Int?, Bool)>] = [wrap(matchable: insightsFromDate) { $0.0 }, wrap(matchable: limit) { $0.1 }, wrap(matchable: onlyHighlights) { $0.2 }]
            return .init(stub: cuckoo_manager.createStub(for: MockInsightsFromDateUsecaseProtocol.self, method:
    """
    getInsights(insightsFromDate: Date, limit: Int?, onlyHighlights: Bool) -> Observable<[Insight]>
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func getInsightsByFarms<M1: Cuckoo.Matchable, M2: Cuckoo.OptionalMatchable, M3: Cuckoo.Matchable, M4: Cuckoo.Matchable>(insightsFromDate: M1, limit: M2, onlyHighlights: M3, fieldsIds: M4) -> Cuckoo.ProtocolStubFunction<(Date, Int?, Bool, [Int]), Observable<[Insight]>> where M1.MatchedType == Date, M2.OptionalMatchedType == Int, M3.MatchedType == Bool, M4.MatchedType == [Int] {
            let matchers: [Cuckoo.ParameterMatcher<(Date, Int?, Bool, [Int])>] = [wrap(matchable: insightsFromDate) { $0.0 }, wrap(matchable: limit) { $0.1 }, wrap(matchable: onlyHighlights) { $0.2 }, wrap(matchable: fieldsIds) { $0.3 }]
            return .init(stub: cuckoo_manager.createStub(for: MockInsightsFromDateUsecaseProtocol.self, method:
    """
    getInsightsByFarms(insightsFromDate: Date, limit: Int?, onlyHighlights: Bool, fieldsIds: [Int]) -> Observable<[Insight]>
    """, parameterMatchers: matchers))
        }
        
        
    }

     struct __VerificationProxy_InsightsFromDateUsecaseProtocol: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
         init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
    
        
        
        
        @discardableResult
        func getInsights<M1: Cuckoo.Matchable, M2: Cuckoo.OptionalMatchable, M3: Cuckoo.Matchable>(insightsFromDate: M1, limit: M2, onlyHighlights: M3) -> Cuckoo.__DoNotUse<(Date, Int?, Bool), Observable<[Insight]>> where M1.MatchedType == Date, M2.OptionalMatchedType == Int, M3.MatchedType == Bool {
            let matchers: [Cuckoo.ParameterMatcher<(Date, Int?, Bool)>] = [wrap(matchable: insightsFromDate) { $0.0 }, wrap(matchable: limit) { $0.1 }, wrap(matchable: onlyHighlights) { $0.2 }]
            return cuckoo_manager.verify(
    """
    getInsights(insightsFromDate: Date, limit: Int?, onlyHighlights: Bool) -> Observable<[Insight]>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func getInsightsByFarms<M1: Cuckoo.Matchable, M2: Cuckoo.OptionalMatchable, M3: Cuckoo.Matchable, M4: Cuckoo.Matchable>(insightsFromDate: M1, limit: M2, onlyHighlights: M3, fieldsIds: M4) -> Cuckoo.__DoNotUse<(Date, Int?, Bool, [Int]), Observable<[Insight]>> where M1.MatchedType == Date, M2.OptionalMatchedType == Int, M3.MatchedType == Bool, M4.MatchedType == [Int] {
            let matchers: [Cuckoo.ParameterMatcher<(Date, Int?, Bool, [Int])>] = [wrap(matchable: insightsFromDate) { $0.0 }, wrap(matchable: limit) { $0.1 }, wrap(matchable: onlyHighlights) { $0.2 }, wrap(matchable: fieldsIds) { $0.3 }]
            return cuckoo_manager.verify(
    """
    getInsightsByFarms(insightsFromDate: Date, limit: Int?, onlyHighlights: Bool, fieldsIds: [Int]) -> Observable<[Insight]>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


 class InsightsFromDateUsecaseProtocolStub: InsightsFromDateUsecaseProtocol {
    

    

    
    
    
    
     func getInsights(insightsFromDate: Date, limit: Int?, onlyHighlights: Bool) -> Observable<[Insight]>  {
        return DefaultValueRegistry.defaultValue(for: (Observable<[Insight]>).self)
    }
    
    
    
    
    
     func getInsightsByFarms(insightsFromDate: Date, limit: Int?, onlyHighlights: Bool, fieldsIds: [Int]) -> Observable<[Insight]>  {
        return DefaultValueRegistry.defaultValue(for: (Observable<[Insight]>).self)
    }
    
    
}





// MARK: - Mocks generated from file: Openfield/Infra/Data/Usecases/InsightsFromFieldAndCategoryUsecaseProtocol.swift at 2024-11-17 14:51:25 +0000

//
//  InsightsFromFieldAndCategoryUsecaseProtocol.swift
//  Openfield
//
//  Created by amir avisar on 18/02/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Cuckoo
@testable import Openfield

import Foundation
import RxSwift






 class MockInsightsFromFieldAndCategoryUsecaseProtocol: InsightsFromFieldAndCategoryUsecaseProtocol, Cuckoo.ProtocolMock {
    
     typealias MocksType = InsightsFromFieldAndCategoryUsecaseProtocol
    
     typealias Stubbing = __StubbingProxy_InsightsFromFieldAndCategoryUsecaseProtocol
     typealias Verification = __VerificationProxy_InsightsFromFieldAndCategoryUsecaseProtocol

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: InsightsFromFieldAndCategoryUsecaseProtocol?

     func enableDefaultImplementation(_ stub: InsightsFromFieldAndCategoryUsecaseProtocol) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    
     func insights(byFieldId: Int, byCategory: String, onlyHighlights: Bool, cycleId: Int?, publicationYear: Int?) -> Observable<[Insight]> {
        
    return cuckoo_manager.call(
    """
    insights(byFieldId: Int, byCategory: String, onlyHighlights: Bool, cycleId: Int?, publicationYear: Int?) -> Observable<[Insight]>
    """,
            parameters: (byFieldId, byCategory, onlyHighlights, cycleId, publicationYear),
            escapingParameters: (byFieldId, byCategory, onlyHighlights, cycleId, publicationYear),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.insights(byFieldId: byFieldId, byCategory: byCategory, onlyHighlights: onlyHighlights, cycleId: cycleId, publicationYear: publicationYear))
        
    }
    
    

     struct __StubbingProxy_InsightsFromFieldAndCategoryUsecaseProtocol: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func insights<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable, M4: Cuckoo.OptionalMatchable, M5: Cuckoo.OptionalMatchable>(byFieldId: M1, byCategory: M2, onlyHighlights: M3, cycleId: M4, publicationYear: M5) -> Cuckoo.ProtocolStubFunction<(Int, String, Bool, Int?, Int?), Observable<[Insight]>> where M1.MatchedType == Int, M2.MatchedType == String, M3.MatchedType == Bool, M4.OptionalMatchedType == Int, M5.OptionalMatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Int, String, Bool, Int?, Int?)>] = [wrap(matchable: byFieldId) { $0.0 }, wrap(matchable: byCategory) { $0.1 }, wrap(matchable: onlyHighlights) { $0.2 }, wrap(matchable: cycleId) { $0.3 }, wrap(matchable: publicationYear) { $0.4 }]
            return .init(stub: cuckoo_manager.createStub(for: MockInsightsFromFieldAndCategoryUsecaseProtocol.self, method:
    """
    insights(byFieldId: Int, byCategory: String, onlyHighlights: Bool, cycleId: Int?, publicationYear: Int?) -> Observable<[Insight]>
    """, parameterMatchers: matchers))
        }
        
        
    }

     struct __VerificationProxy_InsightsFromFieldAndCategoryUsecaseProtocol: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
         init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
    
        
        
        
        @discardableResult
        func insights<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable, M4: Cuckoo.OptionalMatchable, M5: Cuckoo.OptionalMatchable>(byFieldId: M1, byCategory: M2, onlyHighlights: M3, cycleId: M4, publicationYear: M5) -> Cuckoo.__DoNotUse<(Int, String, Bool, Int?, Int?), Observable<[Insight]>> where M1.MatchedType == Int, M2.MatchedType == String, M3.MatchedType == Bool, M4.OptionalMatchedType == Int, M5.OptionalMatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Int, String, Bool, Int?, Int?)>] = [wrap(matchable: byFieldId) { $0.0 }, wrap(matchable: byCategory) { $0.1 }, wrap(matchable: onlyHighlights) { $0.2 }, wrap(matchable: cycleId) { $0.3 }, wrap(matchable: publicationYear) { $0.4 }]
            return cuckoo_manager.verify(
    """
    insights(byFieldId: Int, byCategory: String, onlyHighlights: Bool, cycleId: Int?, publicationYear: Int?) -> Observable<[Insight]>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


 class InsightsFromFieldAndCategoryUsecaseProtocolStub: InsightsFromFieldAndCategoryUsecaseProtocol {
    

    

    
    
    
    
     func insights(byFieldId: Int, byCategory: String, onlyHighlights: Bool, cycleId: Int?, publicationYear: Int?) -> Observable<[Insight]>  {
        return DefaultValueRegistry.defaultValue(for: (Observable<[Insight]>).self)
    }
    
    
}





// MARK: - Mocks generated from file: Openfield/Infra/Data/Usecases/InsightsPerCategoryUsecaseProtocol.swift at 2024-11-17 14:51:25 +0000

//
//  InsightsPerCategoryUsecaseProtocol.swift
//  Openfield
//
//  Created by amir avisar on 13/02/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Cuckoo
@testable import Openfield

import Foundation
import RxSwift






 class MockInsightsPerCategoryUsecaseProtocol: InsightsPerCategoryUsecaseProtocol, Cuckoo.ProtocolMock {
    
     typealias MocksType = InsightsPerCategoryUsecaseProtocol
    
     typealias Stubbing = __StubbingProxy_InsightsPerCategoryUsecaseProtocol
     typealias Verification = __VerificationProxy_InsightsPerCategoryUsecaseProtocol

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: InsightsPerCategoryUsecaseProtocol?

     func enableDefaultImplementation(_ stub: InsightsPerCategoryUsecaseProtocol) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    
     func insights(byFieldId fieldId: Int) -> Observable<[Insight]> {
        
    return cuckoo_manager.call(
    """
    insights(byFieldId: Int) -> Observable<[Insight]>
    """,
            parameters: (fieldId),
            escapingParameters: (fieldId),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.insights(byFieldId: fieldId))
        
    }
    
    
    
    
    
     func insightsWithFieldFilter(fieldId: Int, criteria: [FilterCriterion], order: Int) -> Observable<[Insight]> {
        
    return cuckoo_manager.call(
    """
    insightsWithFieldFilter(fieldId: Int, criteria: [FilterCriterion], order: Int) -> Observable<[Insight]>
    """,
            parameters: (fieldId, criteria, order),
            escapingParameters: (fieldId, criteria, order),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.insightsWithFieldFilter(fieldId: fieldId, criteria: criteria, order: order))
        
    }
    
    

     struct __StubbingProxy_InsightsPerCategoryUsecaseProtocol: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func insights<M1: Cuckoo.Matchable>(byFieldId fieldId: M1) -> Cuckoo.ProtocolStubFunction<(Int), Observable<[Insight]>> where M1.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Int)>] = [wrap(matchable: fieldId) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockInsightsPerCategoryUsecaseProtocol.self, method:
    """
    insights(byFieldId: Int) -> Observable<[Insight]>
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func insightsWithFieldFilter<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(fieldId: M1, criteria: M2, order: M3) -> Cuckoo.ProtocolStubFunction<(Int, [FilterCriterion], Int), Observable<[Insight]>> where M1.MatchedType == Int, M2.MatchedType == [FilterCriterion], M3.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Int, [FilterCriterion], Int)>] = [wrap(matchable: fieldId) { $0.0 }, wrap(matchable: criteria) { $0.1 }, wrap(matchable: order) { $0.2 }]
            return .init(stub: cuckoo_manager.createStub(for: MockInsightsPerCategoryUsecaseProtocol.self, method:
    """
    insightsWithFieldFilter(fieldId: Int, criteria: [FilterCriterion], order: Int) -> Observable<[Insight]>
    """, parameterMatchers: matchers))
        }
        
        
    }

     struct __VerificationProxy_InsightsPerCategoryUsecaseProtocol: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
         init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
    
        
        
        
        @discardableResult
        func insights<M1: Cuckoo.Matchable>(byFieldId fieldId: M1) -> Cuckoo.__DoNotUse<(Int), Observable<[Insight]>> where M1.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Int)>] = [wrap(matchable: fieldId) { $0 }]
            return cuckoo_manager.verify(
    """
    insights(byFieldId: Int) -> Observable<[Insight]>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func insightsWithFieldFilter<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(fieldId: M1, criteria: M2, order: M3) -> Cuckoo.__DoNotUse<(Int, [FilterCriterion], Int), Observable<[Insight]>> where M1.MatchedType == Int, M2.MatchedType == [FilterCriterion], M3.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Int, [FilterCriterion], Int)>] = [wrap(matchable: fieldId) { $0.0 }, wrap(matchable: criteria) { $0.1 }, wrap(matchable: order) { $0.2 }]
            return cuckoo_manager.verify(
    """
    insightsWithFieldFilter(fieldId: Int, criteria: [FilterCriterion], order: Int) -> Observable<[Insight]>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


 class InsightsPerCategoryUsecaseProtocolStub: InsightsPerCategoryUsecaseProtocol {
    

    

    
    
    
    
     func insights(byFieldId fieldId: Int) -> Observable<[Insight]>  {
        return DefaultValueRegistry.defaultValue(for: (Observable<[Insight]>).self)
    }
    
    
    
    
    
     func insightsWithFieldFilter(fieldId: Int, criteria: [FilterCriterion], order: Int) -> Observable<[Insight]>  {
        return DefaultValueRegistry.defaultValue(for: (Observable<[Insight]>).self)
    }
    
    
}





// MARK: - Mocks generated from file: Openfield/Infra/Data/Usecases/InsightsUsecaseProtocol.swift at 2024-11-17 14:51:25 +0000

//
//  InsightsUsecaseProtocol.swift
//  Openfield
//
//  Created by Yoni Luz on 11/01/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Cuckoo
@testable import Openfield

import Foundation
import RxSwift






 class MockInsightsUsecaseProtocol: InsightsUsecaseProtocol, Cuckoo.ProtocolMock {
    
     typealias MocksType = InsightsUsecaseProtocol
    
     typealias Stubbing = __StubbingProxy_InsightsUsecaseProtocol
     typealias Verification = __VerificationProxy_InsightsUsecaseProtocol

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: InsightsUsecaseProtocol?

     func enableDefaultImplementation(_ stub: InsightsUsecaseProtocol) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    
     func generateInsights(insightsStream: Observable<[InsightServerModel]>) -> Observable<[Insight]> {
        
    return cuckoo_manager.call(
    """
    generateInsights(insightsStream: Observable<[InsightServerModel]>) -> Observable<[Insight]>
    """,
            parameters: (insightsStream),
            escapingParameters: (insightsStream),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.generateInsights(insightsStream: insightsStream))
        
    }
    
    
    
    
    
     func generateInsight(insightStream: Observable<InsightServerModel?>) -> Observable<Insight?> {
        
    return cuckoo_manager.call(
    """
    generateInsight(insightStream: Observable<InsightServerModel?>) -> Observable<Insight?>
    """,
            parameters: (insightStream),
            escapingParameters: (insightStream),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.generateInsight(insightStream: insightStream))
        
    }
    
    

     struct __StubbingProxy_InsightsUsecaseProtocol: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func generateInsights<M1: Cuckoo.Matchable>(insightsStream: M1) -> Cuckoo.ProtocolStubFunction<(Observable<[InsightServerModel]>), Observable<[Insight]>> where M1.MatchedType == Observable<[InsightServerModel]> {
            let matchers: [Cuckoo.ParameterMatcher<(Observable<[InsightServerModel]>)>] = [wrap(matchable: insightsStream) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockInsightsUsecaseProtocol.self, method:
    """
    generateInsights(insightsStream: Observable<[InsightServerModel]>) -> Observable<[Insight]>
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func generateInsight<M1: Cuckoo.Matchable>(insightStream: M1) -> Cuckoo.ProtocolStubFunction<(Observable<InsightServerModel?>), Observable<Insight?>> where M1.MatchedType == Observable<InsightServerModel?> {
            let matchers: [Cuckoo.ParameterMatcher<(Observable<InsightServerModel?>)>] = [wrap(matchable: insightStream) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockInsightsUsecaseProtocol.self, method:
    """
    generateInsight(insightStream: Observable<InsightServerModel?>) -> Observable<Insight?>
    """, parameterMatchers: matchers))
        }
        
        
    }

     struct __VerificationProxy_InsightsUsecaseProtocol: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
         init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
    
        
        
        
        @discardableResult
        func generateInsights<M1: Cuckoo.Matchable>(insightsStream: M1) -> Cuckoo.__DoNotUse<(Observable<[InsightServerModel]>), Observable<[Insight]>> where M1.MatchedType == Observable<[InsightServerModel]> {
            let matchers: [Cuckoo.ParameterMatcher<(Observable<[InsightServerModel]>)>] = [wrap(matchable: insightsStream) { $0 }]
            return cuckoo_manager.verify(
    """
    generateInsights(insightsStream: Observable<[InsightServerModel]>) -> Observable<[Insight]>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func generateInsight<M1: Cuckoo.Matchable>(insightStream: M1) -> Cuckoo.__DoNotUse<(Observable<InsightServerModel?>), Observable<Insight?>> where M1.MatchedType == Observable<InsightServerModel?> {
            let matchers: [Cuckoo.ParameterMatcher<(Observable<InsightServerModel?>)>] = [wrap(matchable: insightStream) { $0 }]
            return cuckoo_manager.verify(
    """
    generateInsight(insightStream: Observable<InsightServerModel?>) -> Observable<Insight?>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


 class InsightsUsecaseProtocolStub: InsightsUsecaseProtocol {
    

    

    
    
    
    
     func generateInsights(insightsStream: Observable<[InsightServerModel]>) -> Observable<[Insight]>  {
        return DefaultValueRegistry.defaultValue(for: (Observable<[Insight]>).self)
    }
    
    
    
    
    
     func generateInsight(insightStream: Observable<InsightServerModel?>) -> Observable<Insight?>  {
        return DefaultValueRegistry.defaultValue(for: (Observable<Insight?>).self)
    }
    
    
}





// MARK: - Mocks generated from file: Openfield/Infra/Data/Usecases/IsUserFieldOwnerUseCaseProtocol.swift at 2024-11-17 14:51:25 +0000

//
//  IsUserFieldUseCaseProtocol.swift
//  Openfield
//
//  Created by amir avisar on 11/04/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Cuckoo
@testable import Openfield

import Foundation
import RxSwift






 class MockIsUserFieldOwnerUseCaseProtocol: IsUserFieldOwnerUseCaseProtocol, Cuckoo.ProtocolMock {
    
     typealias MocksType = IsUserFieldOwnerUseCaseProtocol
    
     typealias Stubbing = __StubbingProxy_IsUserFieldOwnerUseCaseProtocol
     typealias Verification = __VerificationProxy_IsUserFieldOwnerUseCaseProtocol

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: IsUserFieldOwnerUseCaseProtocol?

     func enableDefaultImplementation(_ stub: IsUserFieldOwnerUseCaseProtocol) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    
     func isUserField(fieldId: Int) -> Observable<Bool> {
        
    return cuckoo_manager.call(
    """
    isUserField(fieldId: Int) -> Observable<Bool>
    """,
            parameters: (fieldId),
            escapingParameters: (fieldId),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.isUserField(fieldId: fieldId))
        
    }
    
    

     struct __StubbingProxy_IsUserFieldOwnerUseCaseProtocol: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func isUserField<M1: Cuckoo.Matchable>(fieldId: M1) -> Cuckoo.ProtocolStubFunction<(Int), Observable<Bool>> where M1.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Int)>] = [wrap(matchable: fieldId) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockIsUserFieldOwnerUseCaseProtocol.self, method:
    """
    isUserField(fieldId: Int) -> Observable<Bool>
    """, parameterMatchers: matchers))
        }
        
        
    }

     struct __VerificationProxy_IsUserFieldOwnerUseCaseProtocol: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
         init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
    
        
        
        
        @discardableResult
        func isUserField<M1: Cuckoo.Matchable>(fieldId: M1) -> Cuckoo.__DoNotUse<(Int), Observable<Bool>> where M1.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Int)>] = [wrap(matchable: fieldId) { $0 }]
            return cuckoo_manager.verify(
    """
    isUserField(fieldId: Int) -> Observable<Bool>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


 class IsUserFieldOwnerUseCaseProtocolStub: IsUserFieldOwnerUseCaseProtocol {
    

    

    
    
    
    
     func isUserField(fieldId: Int) -> Observable<Bool>  {
        return DefaultValueRegistry.defaultValue(for: (Observable<Bool>).self)
    }
    
    
}





// MARK: - Mocks generated from file: Openfield/Infra/Data/Usecases/LocationsFromInsightUsecaseProtocol.swift at 2024-11-17 14:51:25 +0000

//
//  LocationsFromInsightUsecaseProtocol.swift
//  Openfield
//
//  Created by amir avisar on 11/02/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Cuckoo
@testable import Openfield

import Foundation
import RxSwift






 class MockLocationsFromInsightUsecaseProtocol: LocationsFromInsightUsecaseProtocol, Cuckoo.ProtocolMock {
    
     typealias MocksType = LocationsFromInsightUsecaseProtocol
    
     typealias Stubbing = __StubbingProxy_LocationsFromInsightUsecaseProtocol
     typealias Verification = __VerificationProxy_LocationsFromInsightUsecaseProtocol

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: LocationsFromInsightUsecaseProtocol?

     func enableDefaultImplementation(_ stub: LocationsFromInsightUsecaseProtocol) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    
     func locations(forInsightUID insightUID: String) -> Observable<[Location]> {
        
    return cuckoo_manager.call(
    """
    locations(forInsightUID: String) -> Observable<[Location]>
    """,
            parameters: (insightUID),
            escapingParameters: (insightUID),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.locations(forInsightUID: insightUID))
        
    }
    
    

     struct __StubbingProxy_LocationsFromInsightUsecaseProtocol: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func locations<M1: Cuckoo.Matchable>(forInsightUID insightUID: M1) -> Cuckoo.ProtocolStubFunction<(String), Observable<[Location]>> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: insightUID) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockLocationsFromInsightUsecaseProtocol.self, method:
    """
    locations(forInsightUID: String) -> Observable<[Location]>
    """, parameterMatchers: matchers))
        }
        
        
    }

     struct __VerificationProxy_LocationsFromInsightUsecaseProtocol: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
         init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
    
        
        
        
        @discardableResult
        func locations<M1: Cuckoo.Matchable>(forInsightUID insightUID: M1) -> Cuckoo.__DoNotUse<(String), Observable<[Location]>> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: insightUID) { $0 }]
            return cuckoo_manager.verify(
    """
    locations(forInsightUID: String) -> Observable<[Location]>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


 class LocationsFromInsightUsecaseProtocolStub: LocationsFromInsightUsecaseProtocol {
    

    

    
    
    
    
     func locations(forInsightUID insightUID: String) -> Observable<[Location]>  {
        return DefaultValueRegistry.defaultValue(for: (Observable<[Location]>).self)
    }
    
    
}





// MARK: - Mocks generated from file: Openfield/Infra/Data/Usecases/RequestReportLinkUsecaseProtocol.swift at 2024-11-17 14:51:25 +0000

//
//  RequestReportLinkUsecaseProtocol.swift
//  Openfield
//
//  Created by Yoni Luz on 29/05/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Cuckoo
@testable import Openfield

import Foundation
import RxSwift






 class MockRequestReportLinkUsecaseProtocol: RequestReportLinkUsecaseProtocol, Cuckoo.ProtocolMock {
    
     typealias MocksType = RequestReportLinkUsecaseProtocol
    
     typealias Stubbing = __StubbingProxy_RequestReportLinkUsecaseProtocol
     typealias Verification = __VerificationProxy_RequestReportLinkUsecaseProtocol

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: RequestReportLinkUsecaseProtocol?

     func enableDefaultImplementation(_ stub: RequestReportLinkUsecaseProtocol) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    
     func getRequestReportLink(field: Field, selectedSeasonOrder: Int) -> Observable<URL?> {
        
    return cuckoo_manager.call(
    """
    getRequestReportLink(field: Field, selectedSeasonOrder: Int) -> Observable<URL?>
    """,
            parameters: (field, selectedSeasonOrder),
            escapingParameters: (field, selectedSeasonOrder),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.getRequestReportLink(field: field, selectedSeasonOrder: selectedSeasonOrder))
        
    }
    
    

     struct __StubbingProxy_RequestReportLinkUsecaseProtocol: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func getRequestReportLink<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(field: M1, selectedSeasonOrder: M2) -> Cuckoo.ProtocolStubFunction<(Field, Int), Observable<URL?>> where M1.MatchedType == Field, M2.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Field, Int)>] = [wrap(matchable: field) { $0.0 }, wrap(matchable: selectedSeasonOrder) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockRequestReportLinkUsecaseProtocol.self, method:
    """
    getRequestReportLink(field: Field, selectedSeasonOrder: Int) -> Observable<URL?>
    """, parameterMatchers: matchers))
        }
        
        
    }

     struct __VerificationProxy_RequestReportLinkUsecaseProtocol: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
         init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
    
        
        
        
        @discardableResult
        func getRequestReportLink<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(field: M1, selectedSeasonOrder: M2) -> Cuckoo.__DoNotUse<(Field, Int), Observable<URL?>> where M1.MatchedType == Field, M2.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Field, Int)>] = [wrap(matchable: field) { $0.0 }, wrap(matchable: selectedSeasonOrder) { $0.1 }]
            return cuckoo_manager.verify(
    """
    getRequestReportLink(field: Field, selectedSeasonOrder: Int) -> Observable<URL?>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


 class RequestReportLinkUsecaseProtocolStub: RequestReportLinkUsecaseProtocol {
    

    

    
    
    
    
     func getRequestReportLink(field: Field, selectedSeasonOrder: Int) -> Observable<URL?>  {
        return DefaultValueRegistry.defaultValue(for: (Observable<URL?>).self)
    }
    
    
}





// MARK: - Mocks generated from file: Openfield/Infra/Data/Usecases/UserStreamUsecaseProtocol.swift at 2024-11-17 14:51:25 +0000

//
//  UserStreamUsecaseProtocol.swift
//  Openfield
//
//  Created by Yoni Luz on 11/01/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Cuckoo
@testable import Openfield

import Foundation
import RxSwift






 class MockUserStreamUsecaseProtocol: UserStreamUsecaseProtocol, Cuckoo.ProtocolMock {
    
     typealias MocksType = UserStreamUsecaseProtocol
    
     typealias Stubbing = __StubbingProxy_UserStreamUsecaseProtocol
     typealias Verification = __VerificationProxy_UserStreamUsecaseProtocol

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: UserStreamUsecaseProtocol?

     func enableDefaultImplementation(_ stub: UserStreamUsecaseProtocol) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    
     func userStream() -> Observable<Openfield.User> {
        
    return cuckoo_manager.call(
    """
    userStream() -> Observable<Openfield.User>
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.userStream())
        
    }
    
    

     struct __StubbingProxy_UserStreamUsecaseProtocol: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func userStream() -> Cuckoo.ProtocolStubFunction<(), Observable<Openfield.User>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockUserStreamUsecaseProtocol.self, method:
    """
    userStream() -> Observable<Openfield.User>
    """, parameterMatchers: matchers))
        }
        
        
    }

     struct __VerificationProxy_UserStreamUsecaseProtocol: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
         init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
    
        
        
        
        @discardableResult
        func userStream() -> Cuckoo.__DoNotUse<(), Observable<Openfield.User>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    userStream() -> Observable<Openfield.User>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


 class UserStreamUsecaseProtocolStub: UserStreamUsecaseProtocol {
    

    

    
    
    
    
     func userStream() -> Observable<Openfield.User>  {
        return DefaultValueRegistry.defaultValue(for: (Observable<Openfield.User>).self)
    }
    
    
}





// MARK: - Mocks generated from file: Openfield/Infra/RemoteConfig/UseCases/GetFieldIrrigationLimitUseCaseProtocol.swift at 2024-11-17 14:51:25 +0000

//
//  GetFieldIrrigationLimitUseCaseProtocol.swift
//  Openfield
//
//  Created by amir avisar on 19/08/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Cuckoo
@testable import Openfield

import Foundation






 class MockGetFieldIrrigationLimitUseCaseProtocol: GetFieldIrrigationLimitUseCaseProtocol, Cuckoo.ProtocolMock {
    
     typealias MocksType = GetFieldIrrigationLimitUseCaseProtocol
    
     typealias Stubbing = __StubbingProxy_GetFieldIrrigationLimitUseCaseProtocol
     typealias Verification = __VerificationProxy_GetFieldIrrigationLimitUseCaseProtocol

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: GetFieldIrrigationLimitUseCaseProtocol?

     func enableDefaultImplementation(_ stub: GetFieldIrrigationLimitUseCaseProtocol) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    
     func fieldIrrigationLimit() -> Int {
        
    return cuckoo_manager.call(
    """
    fieldIrrigationLimit() -> Int
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.fieldIrrigationLimit())
        
    }
    
    

     struct __StubbingProxy_GetFieldIrrigationLimitUseCaseProtocol: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func fieldIrrigationLimit() -> Cuckoo.ProtocolStubFunction<(), Int> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockGetFieldIrrigationLimitUseCaseProtocol.self, method:
    """
    fieldIrrigationLimit() -> Int
    """, parameterMatchers: matchers))
        }
        
        
    }

     struct __VerificationProxy_GetFieldIrrigationLimitUseCaseProtocol: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
         init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
    
        
        
        
        @discardableResult
        func fieldIrrigationLimit() -> Cuckoo.__DoNotUse<(), Int> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    fieldIrrigationLimit() -> Int
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


 class GetFieldIrrigationLimitUseCaseProtocolStub: GetFieldIrrigationLimitUseCaseProtocol {
    

    

    
    
    
    
     func fieldIrrigationLimit() -> Int  {
        return DefaultValueRegistry.defaultValue(for: (Int).self)
    }
    
    
}





// MARK: - Mocks generated from file: Openfield/Infra/RemoteConfig/UseCases/GetSupportedInsightUseCaseProtocol.swift at 2024-11-17 14:51:25 +0000

//
//  GetSupportedInsightUseCaseProtocol.swift
//  Openfield
//
//  Created by amir avisar on 19/08/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Cuckoo
@testable import Openfield

import Foundation






 class MockGetSupportedInsightUseCaseProtocol: GetSupportedInsightUseCaseProtocol, Cuckoo.ProtocolMock {
    
     typealias MocksType = GetSupportedInsightUseCaseProtocol
    
     typealias Stubbing = __StubbingProxy_GetSupportedInsightUseCaseProtocol
     typealias Verification = __VerificationProxy_GetSupportedInsightUseCaseProtocol

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: GetSupportedInsightUseCaseProtocol?

     func enableDefaultImplementation(_ stub: GetSupportedInsightUseCaseProtocol) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    
     func supportedInsights() -> [String: InsightConfiguration] {
        
    return cuckoo_manager.call(
    """
    supportedInsights() -> [String: InsightConfiguration]
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.supportedInsights())
        
    }
    
    

     struct __StubbingProxy_GetSupportedInsightUseCaseProtocol: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func supportedInsights() -> Cuckoo.ProtocolStubFunction<(), [String: InsightConfiguration]> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockGetSupportedInsightUseCaseProtocol.self, method:
    """
    supportedInsights() -> [String: InsightConfiguration]
    """, parameterMatchers: matchers))
        }
        
        
    }

     struct __VerificationProxy_GetSupportedInsightUseCaseProtocol: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
         init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
    
        
        
        
        @discardableResult
        func supportedInsights() -> Cuckoo.__DoNotUse<(), [String: InsightConfiguration]> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    supportedInsights() -> [String: InsightConfiguration]
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


 class GetSupportedInsightUseCaseProtocolStub: GetSupportedInsightUseCaseProtocol {
    

    

    
    
    
    
     func supportedInsights() -> [String: InsightConfiguration]  {
        return DefaultValueRegistry.defaultValue(for: ([String: InsightConfiguration]).self)
    }
    
    
}





// MARK: - Mocks generated from file: Openfield/Infra/RemoteConfig/UseCases/GetUnitByCountryUseCaseProtocol.swift at 2024-11-17 14:51:25 +0000

//
//  GetUnitByCountryUseCaseProtocol.swift
//  Openfield
//
//  Created by amir avisar on 19/08/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Cuckoo
@testable import Openfield

import Foundation






 class MockGetUnitByCountryUseCaseProtocol: GetUnitByCountryUseCaseProtocol, Cuckoo.ProtocolMock {
    
     typealias MocksType = GetUnitByCountryUseCaseProtocol
    
     typealias Stubbing = __StubbingProxy_GetUnitByCountryUseCaseProtocol
     typealias Verification = __VerificationProxy_GetUnitByCountryUseCaseProtocol

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: GetUnitByCountryUseCaseProtocol?

     func enableDefaultImplementation(_ stub: GetUnitByCountryUseCaseProtocol) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    
     func unitByCountry() -> UnitsByCountry {
        
    return cuckoo_manager.call(
    """
    unitByCountry() -> UnitsByCountry
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.unitByCountry())
        
    }
    
    

     struct __StubbingProxy_GetUnitByCountryUseCaseProtocol: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func unitByCountry() -> Cuckoo.ProtocolStubFunction<(), UnitsByCountry> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockGetUnitByCountryUseCaseProtocol.self, method:
    """
    unitByCountry() -> UnitsByCountry
    """, parameterMatchers: matchers))
        }
        
        
    }

     struct __VerificationProxy_GetUnitByCountryUseCaseProtocol: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
         init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
    
        
        
        
        @discardableResult
        func unitByCountry() -> Cuckoo.__DoNotUse<(), UnitsByCountry> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    unitByCountry() -> UnitsByCountry
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


 class GetUnitByCountryUseCaseProtocolStub: GetUnitByCountryUseCaseProtocol {
    

    

    
    
    
    
     func unitByCountry() -> UnitsByCountry  {
        return DefaultValueRegistry.defaultValue(for: (UnitsByCountry).self)
    }
    
    
}





// MARK: - Mocks generated from file: Openfield/Main/Highlights/UseCases/GetHighlightsUseCaseProtocol.swift at 2024-11-17 14:51:25 +0000

//
//  GetHighlightsUseCaseProtocol.swift
//  Openfield
//
//  Created by amir avisar on 10/01/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Cuckoo
@testable import Openfield

import Foundation
import RxSwift






 class MockGetHighlightsUseCaseProtocol: GetHighlightsUseCaseProtocol, Cuckoo.ProtocolMock {
    
     typealias MocksType = GetHighlightsUseCaseProtocol
    
     typealias Stubbing = __StubbingProxy_GetHighlightsUseCaseProtocol
     typealias Verification = __VerificationProxy_GetHighlightsUseCaseProtocol

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: GetHighlightsUseCaseProtocol?

     func enableDefaultImplementation(_ stub: GetHighlightsUseCaseProtocol) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    
     func highlights(limit: Int?, fromDate: Date?) -> Observable<[Highlight]> {
        
    return cuckoo_manager.call(
    """
    highlights(limit: Int?, fromDate: Date?) -> Observable<[Highlight]>
    """,
            parameters: (limit, fromDate),
            escapingParameters: (limit, fromDate),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.highlights(limit: limit, fromDate: fromDate))
        
    }
    
    
    
    
    
     func highlights() -> Observable<[SectionHighlightItem]> {
        
    return cuckoo_manager.call(
    """
    highlights() -> Observable<[SectionHighlightItem]>
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.highlights())
        
    }
    
    
    
    
    
     func highlights(byFieldId: Int, byCategory: String) -> Observable<[SectionHighlightItem]> {
        
    return cuckoo_manager.call(
    """
    highlights(byFieldId: Int, byCategory: String) -> Observable<[SectionHighlightItem]>
    """,
            parameters: (byFieldId, byCategory),
            escapingParameters: (byFieldId, byCategory),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.highlights(byFieldId: byFieldId, byCategory: byCategory))
        
    }
    
    
    
    
    
     func insightsToHighlights(insights: Observable<[Insight]>) -> Observable<[Highlight]> {
        
    return cuckoo_manager.call(
    """
    insightsToHighlights(insights: Observable<[Insight]>) -> Observable<[Highlight]>
    """,
            parameters: (insights),
            escapingParameters: (insights),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.insightsToHighlights(insights: insights))
        
    }
    
    

     struct __StubbingProxy_GetHighlightsUseCaseProtocol: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func highlights<M1: Cuckoo.OptionalMatchable, M2: Cuckoo.OptionalMatchable>(limit: M1, fromDate: M2) -> Cuckoo.ProtocolStubFunction<(Int?, Date?), Observable<[Highlight]>> where M1.OptionalMatchedType == Int, M2.OptionalMatchedType == Date {
            let matchers: [Cuckoo.ParameterMatcher<(Int?, Date?)>] = [wrap(matchable: limit) { $0.0 }, wrap(matchable: fromDate) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockGetHighlightsUseCaseProtocol.self, method:
    """
    highlights(limit: Int?, fromDate: Date?) -> Observable<[Highlight]>
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func highlights() -> Cuckoo.ProtocolStubFunction<(), Observable<[SectionHighlightItem]>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockGetHighlightsUseCaseProtocol.self, method:
    """
    highlights() -> Observable<[SectionHighlightItem]>
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func highlights<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(byFieldId: M1, byCategory: M2) -> Cuckoo.ProtocolStubFunction<(Int, String), Observable<[SectionHighlightItem]>> where M1.MatchedType == Int, M2.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(Int, String)>] = [wrap(matchable: byFieldId) { $0.0 }, wrap(matchable: byCategory) { $0.1 }]
            return .init(stub: cuckoo_manager.createStub(for: MockGetHighlightsUseCaseProtocol.self, method:
    """
    highlights(byFieldId: Int, byCategory: String) -> Observable<[SectionHighlightItem]>
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func insightsToHighlights<M1: Cuckoo.Matchable>(insights: M1) -> Cuckoo.ProtocolStubFunction<(Observable<[Insight]>), Observable<[Highlight]>> where M1.MatchedType == Observable<[Insight]> {
            let matchers: [Cuckoo.ParameterMatcher<(Observable<[Insight]>)>] = [wrap(matchable: insights) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockGetHighlightsUseCaseProtocol.self, method:
    """
    insightsToHighlights(insights: Observable<[Insight]>) -> Observable<[Highlight]>
    """, parameterMatchers: matchers))
        }
        
        
    }

     struct __VerificationProxy_GetHighlightsUseCaseProtocol: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
         init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
    
        
        
        
        @discardableResult
        func highlights<M1: Cuckoo.OptionalMatchable, M2: Cuckoo.OptionalMatchable>(limit: M1, fromDate: M2) -> Cuckoo.__DoNotUse<(Int?, Date?), Observable<[Highlight]>> where M1.OptionalMatchedType == Int, M2.OptionalMatchedType == Date {
            let matchers: [Cuckoo.ParameterMatcher<(Int?, Date?)>] = [wrap(matchable: limit) { $0.0 }, wrap(matchable: fromDate) { $0.1 }]
            return cuckoo_manager.verify(
    """
    highlights(limit: Int?, fromDate: Date?) -> Observable<[Highlight]>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func highlights() -> Cuckoo.__DoNotUse<(), Observable<[SectionHighlightItem]>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    highlights() -> Observable<[SectionHighlightItem]>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func highlights<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(byFieldId: M1, byCategory: M2) -> Cuckoo.__DoNotUse<(Int, String), Observable<[SectionHighlightItem]>> where M1.MatchedType == Int, M2.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(Int, String)>] = [wrap(matchable: byFieldId) { $0.0 }, wrap(matchable: byCategory) { $0.1 }]
            return cuckoo_manager.verify(
    """
    highlights(byFieldId: Int, byCategory: String) -> Observable<[SectionHighlightItem]>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func insightsToHighlights<M1: Cuckoo.Matchable>(insights: M1) -> Cuckoo.__DoNotUse<(Observable<[Insight]>), Observable<[Highlight]>> where M1.MatchedType == Observable<[Insight]> {
            let matchers: [Cuckoo.ParameterMatcher<(Observable<[Insight]>)>] = [wrap(matchable: insights) { $0 }]
            return cuckoo_manager.verify(
    """
    insightsToHighlights(insights: Observable<[Insight]>) -> Observable<[Highlight]>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


 class GetHighlightsUseCaseProtocolStub: GetHighlightsUseCaseProtocol {
    

    

    
    
    
    
     func highlights(limit: Int?, fromDate: Date?) -> Observable<[Highlight]>  {
        return DefaultValueRegistry.defaultValue(for: (Observable<[Highlight]>).self)
    }
    
    
    
    
    
     func highlights() -> Observable<[SectionHighlightItem]>  {
        return DefaultValueRegistry.defaultValue(for: (Observable<[SectionHighlightItem]>).self)
    }
    
    
    
    
    
     func highlights(byFieldId: Int, byCategory: String) -> Observable<[SectionHighlightItem]>  {
        return DefaultValueRegistry.defaultValue(for: (Observable<[SectionHighlightItem]>).self)
    }
    
    
    
    
    
     func insightsToHighlights(insights: Observable<[Insight]>) -> Observable<[Highlight]>  {
        return DefaultValueRegistry.defaultValue(for: (Observable<[Highlight]>).self)
    }
    
    
}




