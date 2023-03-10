//
//  CommunicationViewModel.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2021/12/1.
//  Copyright © 2021 shusuke. All rights reserved.
//

import Foundation

protocol CommunicationViewModelDelegate: AnyObject {
    func didSuccessGetFacebookGroupURL()
    func didFailedGetFacebookGroupURL()
}

class CommunicationViewModel {
    private(set) var faceboolGroupURL: String = ""

    weak var delegate: CommunicationViewModelDelegate?

    init() {
        firebaseRemoteCofigRepository = firebaseRemoteCofigRepository
    }
}

// MARK: - Firebase RemoteConfig

extension CommunicationViewModel {
    func loadFacebookGroupURL() {
        firebaseRemoteCofigRepository.fetch(key: .facebookGroupURL) { [weak self] response in
            switch response {
            case .success(let urlString):
                self?.faceboolGroupURL = urlString
                self?.delegate?.didSuccessGetFacebookGroupURL()
            case .failure(let error):
                Logger.verbose("Failed to get Facebook Group Url from Remote Config : " + error.localizedDescription)
                self?.delegate?.didFailedGetFacebookGroupURL()
            }
        }
    }
}
