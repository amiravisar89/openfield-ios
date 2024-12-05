//
//  UpdateUserParamsUsecase.swift
//  Openfield
//
//  Created by amir avisar on 28/10/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//


import CodableFirebase
import Dollar
import Firebase
import RxSwift
import RxSwiftExt
import SwiftDate
import SwiftyUserDefaults

class UpdateUserParamsUsecase: UpdateUserParamsUsecaseProtocol {
  
  let db: Firestore
  var userId: Int
  
  let usersCollectionName = "users"
  let userInsightsKey = "insights"
  let userInsightsTsReadKey = "ts_read"
  let userRoleSeenKey = "ts_seen_role_popup"
  let seenFieldTtooltip = "ts_seen_field_tooltip"
  let userInsightsTsFirstReadKey = "ts_first_read"
  let userInsightsFeedbackKey = "feedback"
  let userInsightsFeedbackRatingKey = "rating"
  let userInsightsFeedbackReasonKey = "reason"
  let userInsightsFeedbackOtherReasonKey = "other_reason"
  let userSettingsKey = "settings"
  let userSettingsEnabledKey = "notifications_enabled"
  let userSettingsRoleKey = "user_role"
  let userSettingsRoleRolesKey = "roles"
  let userSettingsRoleOtherTextKey = "other_text"
  let userSettingsLanguageCode = "language_code"
  let userSettingsTypesKey = "notifications_types"
  let userDevicesKey = "devices"
  let devicePlatformKey = "platform"
  let deviceTokenKey = "token"
  let deviceTokenUpdatedKey = "ts_last_token"
  let deviceLoginUpdateKey = "ts_last_login"
  let deviceLogoutUpdateKey = "ts_logout"
  
  private var userBaseQuery: DocumentReference {
    db
      .collection(usersCollectionName)
      .document(String(userId))
  }
  
  init (userId: Int, firestore: Firestore) {
    self.userId = userId
    self.db = firestore
  }
  
  func setUser(id userId: Int, extUser: ExtUser?) {
    log.info("User ID: \(userId)")
    Defaults.userId = userId
    Defaults.extUser = extUser
    self.userId = userId
  }
  
  func clearUser() -> Observable<Void> {
    return updateUserDevice(refreshToken: false, clearToken: true, isLogin: false)
      .do(onNext: { [weak self] _ in
        self?.setUser(id: 0, extUser: nil)
        Defaults.impersonatorId = nil
      }).catchError {  [weak self] _ in
        self?.setUser(id: 0, extUser: nil)
        Defaults.impersonatorId = nil
        return .just(())
      }
  }
  
  func updateUserLanguage(language: LanguageData) -> Observable<Void> {
    let languageUpdate: [String: [String: String]] = [
      userSettingsKey: [userSettingsLanguageCode: language.locale.identifier],
    ]
    
    return Observable.create { observer in
      self.userBaseQuery.setData(languageUpdate, merge: true) { error in
        if let error = error {
          log.error("Error updating user language: \(error)")
          observer.onError(error)
        } else {
          log.info("Successfuly updated user language")
          observer.onNext(())
          observer.onCompleted()
        }
      }
      return Disposables.create()
    }
  }
  
  func updateUserDevice(refreshToken: Bool,
                        clearToken: Bool,
                        isLogin: Bool) -> Observable<Void>
  {
    guard let fcmToken = Messaging.messaging().fcmToken else {
      log.warning("Could not read FCM token")
      return Observable.just({}())
    }
    
    guard userId != 0 else {
      log.warning("Current user ID is 0 (No user), skipping device update")
      return Observable.just({}())
    }
    
    let tokenParts = fcmToken.components(separatedBy: ":")
    let instanceId: String = tokenParts.count > 0 ? tokenParts[0] : fcmToken
    
    var deviceUpdate: [String: Any] = [
      deviceTokenKey: clearToken ? "" : fcmToken,
      devicePlatformKey: "ios",
    ]
    
    if refreshToken {
      deviceUpdate[deviceTokenUpdatedKey] = FieldValue.serverTimestamp()
    }
    
    if isLogin {
      deviceUpdate[deviceLoginUpdateKey] = FieldValue.serverTimestamp()
    }
    
    if clearToken {
      deviceUpdate[deviceLogoutUpdateKey] = FieldValue.serverTimestamp()
    }
    
    let devicesUpdate: [String: Any] = [
      userDevicesKey: [instanceId: deviceUpdate],
    ]
    
    return Observable.create { observer in
      self.userBaseQuery.setData(devicesUpdate, merge: true) { error in
        if let error = error {
          log.error("Error updating user FCM token: \(error)")
          observer.onError(error)
        } else {
          log.info("Successfuly updated user FCM token")
          observer.onNext(())
          observer.onCompleted()
        }
      }
      return Disposables.create()
    }
    
  }
  
  func updateTracking(tracking: UserTracking) -> Observable<UserTracking> {
    let trackingUpdate: [String: Any] = [
      "ts_feedback_popup_last_shown": tracking.tsFeedbackPopupLastShown as Any,
      "insights_read_without_opening_card": tracking.insightsReadWithoutOpeningCard as Any,
      "ts_card_tooltip_last_shown": tracking.tsCardTooltipLastShown as Any,
      "ts_card_first_open": tracking.tsCardFirstOpen as Any,
      "ts_saw_compare_popup": tracking.tsSawComparePopup as Any,
      "ts_saw_subscribe_popup": tracking.tsSawSubscribePopUp as Any,
      "ts_clicked_subscribe_popup": tracking.tsClickedSubscribePopUp as Any,
      "signed_contract_version": tracking.signedContractVersion as Any,
      "seen_contract_version": tracking.seenContractVersion as Any,
      "ts_seen_contract": tracking.tsSeenContract as Any,
    ]
    
    let update: [String: Any] = [
      "tracking": trackingUpdate,
    ]
    
    return Observable.create { observer in
      self.userBaseQuery.setData(update, merge: true) { error in
        if let error = error {
          log.error("Error updating user tracking object: \(error)")
          observer.onError(error)
        } else {
          log.info("Successfuly updated user tracking object")
          observer.onNext(tracking)
          observer.onCompleted()
        }
      }
      return Disposables.create()
    }
  }
  
  func updateFeedback(feedback: Feedback) -> Observable<Feedback> {
    let ratingPath = FieldPath([userInsightsKey, "\(feedback.insightId)", userInsightsFeedbackKey, userInsightsFeedbackRatingKey])
    let reasonPath = FieldPath([userInsightsKey, "\(feedback.insightId)", userInsightsFeedbackKey, userInsightsFeedbackReasonKey])
    let otherReasonPath = FieldPath([userInsightsKey, "\(feedback.insightId)", userInsightsFeedbackKey, userInsightsFeedbackOtherReasonKey])
    return Observable.create { observer in
      self.userBaseQuery.updateData([
        ratingPath: feedback.rating,
        reasonPath: feedback.reason?.rawValue,
        otherReasonPath: feedback.otherReasonText,
      ]) { error in
        if let error = error {
          log.warning("OFFLINE: Insight: #\(feedback.insightId) will update with feedback: \(feedback) on next connectivity")
          observer.onError(error)
        } else {
          log.info("Insight: #\(feedback.insightId) updated successfuly with feedback status: \(feedback)")
          observer.onNext(feedback)
          observer.onCompleted()
        }
      }
      return Disposables.create()
    }
  }
  
  
  func changeUserRole(user: User, role: UserRole) -> Observable<Void> {
    let rolePath = FieldPath([userSettingsKey, userSettingsRoleKey])
    return Observable.create { [self] observer in
      self.userBaseQuery.updateData([
        rolePath: [userSettingsRoleOtherTextKey: role.otherText ?? "",
                       userSettingsRoleRolesKey: role.rolesIds ?? []],
      ]) { error in
        if let error = error {
          log.warning("OFFLINE: user: #\(user.id) will update with role")
          observer.onError(error)
        } else {
          log.info("User: #\(user.id) updated successfuly with role")
          observer.onNext(())
          observer.onCompleted()
        }
      }
      return Disposables.create()
    }
  }
  
  func changeUserNotifications(user: User, settings: UserSettings) -> Observable<Void> {
    let notificationPath = FieldPath([userSettingsKey, userSettingsEnabledKey])
    let notificationsTypesPath = FieldPath([userSettingsKey, userSettingsTypesKey])
    let notificationEnabled = settings.notificationsEnabled
    let isPushSelected = settings.notificationsPush
    let notificationsTypes = [isPushSelected ? "Push" : "SMS"]
    
    return Observable.create { observer in
      self.userBaseQuery.updateData([
        notificationPath: notificationEnabled,
        notificationsTypesPath: notificationsTypes,
      ]) { error in
        if let error = error {
          log.warning("OFFLINE: user: #\(user.id) will update with notificationEnabled: \(notificationEnabled) and isPushSelected: \(isPushSelected)")
          observer.onError(error)
        } else {
          log.info("User: #\(user.id) updated successfuly with notificationEnabled: \(notificationEnabled) and isPushSelected: \(isPushSelected)")
          observer.onNext(())
          observer.onCompleted()
        }
      }
      return Disposables.create()
    }
  }
  
  func updateUserRoleSeen(user: User, timeStamp: Date) -> Observable<Void> {
    let tsFirstRead = Timestamp(date: timeStamp)
    let tsRolePath = FieldPath([userSettingsKey, userRoleSeenKey])
    return Observable.create { observer in
      self.userBaseQuery.updateData([
        tsRolePath: tsFirstRead,
      ]) { error in
        if let error = error {
          log.warning("OFFLINE: user: #\(user.id) will update with read status: \(String(describing: user.settings.seenRolePopUp)) on next connectivity")
          observer.onError(error)
        } else {
          log.info("User: #\(user.id) updated successfuly with role popup read status: \(String(describing: user.settings.seenRolePopUp))")
          observer.onNext(())
          observer.onCompleted()
        }
      }
      return Disposables.create()
    }
  }
  
  func updateUserFieldTooltipSeen(user: User, timeStamp: Date) -> Observable<Void> {
    let tsFirstRead = Timestamp(date: timeStamp)
    let tsRolePath = FieldPath([userSettingsKey, seenFieldTtooltip])
    return Observable.create { observer in
      self.userBaseQuery.updateData([
        tsRolePath: tsFirstRead,
      ]) { error in
        if let error = error {
          log.warning("OFFLINE: user: #\(user.id) will update with read status: \(String(describing: user.settings.seenFieldTooltip)) on next connectivity")
          observer.onError(error)
        } else {
          log.info("User: #\(user.id) updated successfuly with field tooltip read status: \(String(describing: user.settings.seenFieldTooltip))")
          observer.onNext(())
          observer.onCompleted()
        }
      }
      return Disposables.create()
    }
  }
  
  func changeInsightReadStatus(insight: Insight, isRead: Bool) {
    let currentDate = Date()
    let id = insight.id
    let tsFirstRead = Timestamp(date: insight.tsFirstRead ?? currentDate)
    let tsReadPath = FieldPath([userInsightsKey, "\(id)", userInsightsTsReadKey])
    let tsFirstReadPath = FieldPath([userInsightsKey, "\(id)", userInsightsTsFirstReadKey])
    
    _ = Observable<Void>.create { observer in
      self.userBaseQuery.updateData([
        tsReadPath: isRead ? Timestamp(date: currentDate) : FieldValue.delete(),
        tsFirstReadPath: tsFirstRead,
      ]) { error in
        if let error = error {
          log.warning("OFFLINE: Insight: #\(id) will update with read status: \(isRead) on next connectivity")
          observer.onError(error)
        } else {
          log.info("Insight: #\(id) updated successfuly with read status: \(isRead)")
          observer.onNext(())
          observer.onCompleted()
        }
      }
      return Disposables.create()
    }.subscribe()
  }
  
  
}
