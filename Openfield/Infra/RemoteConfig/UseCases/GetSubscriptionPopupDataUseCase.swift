//
//  GetSubscriptionPopupDataUseCase.swift
//  Openfield
//
//  Created by amir avisar on 19/08/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation

class GetSubscriptionPopupDataUseCase: GetSubscriptionPopupDataUseCaseProtocol {
    
    let remoteconfigRepository: RemoteConfigRepositoryProtocol
    
    init(remoteconfigRepository: RemoteConfigRepositoryProtocol) {
        self.remoteconfigRepository = remoteconfigRepository
    }
    
    func secondaryButtonTitle() -> String {
        return remoteconfigRepository.string(forKey: .subscribePopUpSecondaryButtonTitle)
    }
    
    func mainButtonTitleUnclick() -> String {
        return remoteconfigRepository.string(forKey: .subscribePopUpMainButtonTitleUnclick)
    }
    
    func subtitle() -> String {
        return remoteconfigRepository.string(forKey: .subscribePopUpSubtitle)
    }
    
    func title() -> String {
        return remoteconfigRepository.string(forKey: .subscribePopupTitle)
    }
    
    func imageUrl() -> URL {
        let defaultUrl = "https://prospera-public.s3-eu-west-1.amazonaws.com/img/subscription-popup-image.jpg"
        let urlString = remoteconfigRepository.string(forKey: .subscribePopUpImageUrl)
        return URL(string: urlString) ?? URL(string: remoteconfigRepository.getDefaultValue(forKey: RemoteConfigParameterKey.subscribePopUpImageUrl.rawValue) ?? defaultUrl)!
    }
    
    func mainButtonTitleClick() -> String {
        return remoteconfigRepository.string(forKey: .subscribePopUpMainButtonTitleClick)
    }
    
    func minDate() -> String {
        return remoteconfigRepository.string(forKey: .subscribePopupMinDate)
    }
    
    func maxDate() -> String {
        return remoteconfigRepository.string(forKey: .subscribePopupMaxDate)
    }
}
