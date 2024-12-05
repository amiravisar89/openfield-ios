//
//  GetImagesGalleryImageSizeUseCase.swift
//  Openfield
//
//  Created by amir avisar on 19/08/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import FirebaseCrashlytics

class GetImagesGalleryImageSizeUseCase: GetImagesGalleryImageSizeUseCaseProtocol {
    let remoteconfigRepository: RemoteConfigRepositoryProtocol
    
    init(remoteconfigRepository: RemoteConfigRepositoryProtocol) {
        self.remoteconfigRepository = remoteconfigRepository
    }
    
    func size() -> Int {
        let limit = remoteconfigRepository.int(forKey: .image_size_for_gallery)
        guard limit >= -1 else {
            reportCrashlytics()
            return remoteconfigRepository.getDefaultValue(forKey: RemoteConfigParameterKey.image_size_for_gallery.rawValue) ?? -1
        }
        return limit
    }
    
    private func reportCrashlytics(){
        Crashlytics.crashlytics().record(error: AppErrors.RemoteConfigErrors.valueError)
        Crashlytics.crashlytics().sendUnsentReports()
    }
}
