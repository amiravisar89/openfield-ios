//
//  UpdateUserParamsUsecase.swift
//  Openfield
//
//  Created by amir avisar on 28/10/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//
import RxSwift

protocol UpdateUserParamsUsecaseProtocol {
  func updateUserRoleSeen(user: User, timeStamp: Date) -> Observable<Void>
  func updateUserFieldTooltipSeen(user: User, timeStamp: Date) -> Observable<Void>
  func changeInsightReadStatus(insight: Insight, isRead status: Bool)
  func updateFeedback(feedback: Feedback) -> Observable<Feedback>
  func updateUserLanguage(language: LanguageData) -> Observable<Void>
  func setUser(id: Int, extUser: ExtUser?)
  func clearUser() -> Observable<Void>
  func changeUserNotifications(user: User, settings: UserSettings) -> Observable<Void>
  func updateUserDevice(refreshToken: Bool, clearToken: Bool, isLogin: Bool) -> Observable<Void>
  func updateTracking(tracking: UserTracking) -> Observable<UserTracking>
  func changeUserRole(user: User, role: UserRole) -> Observable<Void>
}
