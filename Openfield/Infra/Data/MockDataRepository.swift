//
//  MockDataRepository.swift
//  Openfield
//
//  Created by Daniel Kochavi on 27/11/2019.
//  Copyright © 2019 Prospera. All rights reserved.
//

import Dollar
import Fakery
import Foundation
import GEOSwift
import Resolver
import RxSwift
import SwiftDate

struct DataError: Error {
    var localizedDescription: String
}

class MockDataRepository: DataRepository {
    var insights: BehaviorSubject<[Insight]> = BehaviorSubject(value: [])
    var imageries: BehaviorSubject<[Imagery]> = BehaviorSubject(value: [])
    var fields: BehaviorSubject<[Field]> = BehaviorSubject(value: [])
    var fieldsLastRead: BehaviorSubject<[CLong : FieldLastRead]> = BehaviorSubject(value: [:])
    var farms: BehaviorSubject<[Farm]> = BehaviorSubject(value: [])

    let faker: Faker
    var feedbacksList: [Feedback] = []
    var currentUser: User
    var contracts: Contracts?
    let forceInsightsReload = PublishSubject<Any>()
    let forceFieldsReload = PublishSubject<Any>()
    let forceMonthlyReportReload = PublishSubject<Any>()

    func randomDelay(functionName: StaticString = #function) -> RxTimeInterval {
        let delay: RxTimeInterval = .milliseconds(faker.number.randomInt(min: 500, max: 2000))
        log.verbose("Mock - Delaying: \(functionName) by: \(delay)")
        return delay
    }

    init(mockData: MockData, faker: Faker) {
        self.faker = faker
        contracts = mockData.contracts
        currentUser = mockData.getCurrentUser()
        insights.onNext(mockData.insights)
        imageries.onNext(mockData.imagery)
        fields.onNext(mockData.fields)
        farms.onNext(mockData.farmList)
    }

    func setUser(id: Int, extUser _: ExtUser?) {
        print("This is my userId: \(id)")
    }

    func clearUser() -> Observable<Void> {
        return .empty()
    }

    func bootstrap() -> Observable<Bool> {
        return Observable.just(true)
    }

    func field(byId: Int) -> Observable<Field?> {
        return fields.map { fields in fields.filter { $0.id == byId }.first }
    }

    lazy var user: Observable<User> = Observable.just(self.currentUser)

    func insight(byUID uid: String) -> Observable<Insight?> {
        return insights.map { insights in
            insights.filter { insight -> Bool in insight.uid == uid }.first
        }
    }

    func insight(byID id: Int) -> Observable<Insight?> {
        return insights.map { insights in
            insights.filter { insight -> Bool in insight.id == id }.first
        }
    }

    func locations(forInsightUID _: String) -> Observable<[Location]> {
        return Observable.just([]).delay(randomDelay(), scheduler: MainScheduler.instance)
    }

    func insights(byFieldId fieldId: Int) -> Observable<[Insight]> {
        return insights.map { insights in
            insights.filter { insight -> Bool in insight.fieldId == fieldId }
        }
    }

    func changeInsightReadStatus(insight: Insight, isRead status: Bool) {
        do {
            let insights = try self.insights.value()
            if let index = insights.firstIndex(where: { $0.id == insight.id }) {
                insights[index].isRead = status
            }
            self.insights.onNext(insights)
        } catch {
            log.debug("Mock - failed change insights status : \(error)")
        }
    }

    func forceReloadUserReports() {
        forceInsightsReload.onNext([])
    }

    func forceReloadInsights() {
        forceInsightsReload.onNext([])
    }

    func forceReloadFields() {
        forceInsightsReload.onNext([])
    }

    func feedbacks() -> Observable<[Feedback]> {
        return Observable.just(feedbacksList)
    }

    func feedback(byInsightId id: Int) -> Observable<Feedback?> {
        let feedback = feedbacksList.first(where: { $0.insightId == id })
        return Observable.just(feedback)
    }

    func updateFeedback(feedback: Feedback) -> Observable<Feedback> {
        do {
            let insights = try self.insights.value()
            guard let index = insights.firstIndex(where: { $0.id == feedback.insightId }) else { return Observable.empty() }
            guard let _ = insights[index] as? IrrigationInsight else { return Observable.empty() } // Feedback exits only for irrigation insights
            (insights[index] as! IrrigationInsight).feedback = feedback
            self.insights.onNext(insights)
            return Observable.just(feedback)
        } catch {
            log.debug("Mock - failed change insights status : \(error)")
            return Observable.empty()
        }
    }

    func changeUserNotifications(user _: User, settings: UserSettings) -> Observable<Void> {
        currentUser.settings = settings
        return Observable.just(())
    }

    func updateUserRoleSeen(user _: User, timeStamp _: Date) -> Observable<Void> {
        return Observable.empty()
    }

    func updateUserLanguage(language _: LanguageData) -> Observable<Void> {
        return Observable.empty()
    }

    func updateUserFieldTooltipSeen(user _: User, timeStamp _: Date) -> Observable<Void> {
        return Observable.empty()
    }

    func changeUserRole(user _: User, role _: UserRole) -> Observable<Void> {
        return Observable.empty()
    }

    func updateUserDevice(refreshToken _: Bool, clearToken _: Bool, isLogin _: Bool) -> Observable<Void> {
        return Observable.empty()
    }

    func updateTracking(tracking: UserTracking) -> Observable<UserTracking> {
        return user.concatMap { user -> Observable<UserTracking> in
            var user = user
            user.tracking = tracking
            return Observable.just(tracking)
        }
    }

    func getSupportedInsights() -> [String: InsightConfiguration] { return [:] }

    func getUnitByCountry() -> UnitsByCountry { return UnitsByCountry(areaUnits: [:]) }
    
    func updateFieldLastRead(id: CLong, lastRead: FieldLastRead?) -> Observable<Void> {
        return Observable.empty()
    }
}

struct MockData {
    // MARK: Fakers

    let fieldFaker: FieldsFaker
    var imageryFaker: ImageryFaker
    let userFaker: UserFaker
    let insightFaker: InsightFaker
    var farmFaker: FarmFaker

    let currentUser: User

    private let insightTimeAgo: Date = Calendar.current.date(byAdding: .month, value: -5, to: Date())!
    private let insightNow: Date = .init()
    private let faker: Faker = .init()
    public var insights: [Insight] = []
    public var farmList: [Farm] = []
    public var fields: [Field] = []
    public var imagery: [Imagery] = []
    public var contracts: Contracts = .init(version: 0.0, date: Date(), contracts: [])

    init(insightCount: Int,
         imageryCount: Int,
         fieldFaker: FieldsFaker,
         imageryFaker: ImageryFaker,
         userFaker: UserFaker,
         insightFaker: InsightFaker,
         farmFaker: FarmFaker,
         contractsFaker: ContractsFaker)
    {
        self.fieldFaker = fieldFaker
        self.imageryFaker = imageryFaker
        self.userFaker = userFaker
        self.insightFaker = insightFaker
        self.farmFaker = farmFaker

        fields = fieldFaker.createFields()
        contracts = contractsFaker.creactContracts()
        currentUser = userFaker.createUser()
        self.imageryFaker.fields = fields
        farmList = farmFaker.createFarms(fields: fields)
        insights = createList(count: insightCount, creator: insightFaker.createInsight).sorted(by: { a, b in a.publishDate > b.publishDate })
        imagery = createList(count: imageryCount, creator: self.imageryFaker.createImagery).sorted(by: { a, b in a.date > b.date })
    }

    func getCurrentUser() -> User {
        return currentUser
    }
}
