//
//  CommunicationViewModel.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2021/12/1.
//  Copyright © 2021 shusuke. All rights reserved.
//

import Foundation

protocol CommunicationViewModelDelegate: AnyObject {
    func didSuccessGetFacebookGroupUrl()
    func didFailedGetFacebookGroupUrl()
}

class CommunicationViewModel {
    private let firebaseRemoteCofigRepository: FirebaseRemoteConfigRepositoryProtocol
    private(set) var faceboolGroupUrl: String = ""

    weak var delegate: CommunicationViewModelDelegate?

    init(firebaseRemoteCofigRepository: FirebaseRemoteConfigRepositoryProtocol) {
        self.firebaseRemoteCofigRepository = firebaseRemoteCofigRepository
    }
}

// MARK: - Firebase RemoteConfig
extension CommunicationViewModel {
    func loadFacebookGroupUrl() {
        firebaseRemoteCofigRepository.fetch(key: .facebookGroupUrl) { [weak self] response in
            switch response {
            case .success(let urlString):
                self?.faceboolGroupUrl = urlString
                self?.delegate?.didSuccessGetFacebookGroupUrl()
            case .failure(let error):
                Logger.verbose("Failed to get Facebook Group Url from Remote Config : " + error.localizedDescription)
                self?.delegate?.didFailedGetFacebookGroupUrl()
            }
        }
    }
}
