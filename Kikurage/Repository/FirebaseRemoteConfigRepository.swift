//
//  FirebaseRemoteConfigRepository.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2021/12/1.
//  Copyright © 2021 shusuke. All rights reserved.
//

import FirebaseRemoteConfig
import Foundation
import KikurageFeature

enum FirebaseRemoteConfigPrimaryKey: String {
    case facebookGroupURL = "facebook_group_url"
    case termsURL = "terms_url"
    case privacyPolicyURL = "privacy_policy_url"
    case latestAppVersion = "ios_latest_app_version"
}

protocol FirebaseRemoteConfigRepositoryProtocol {
    func fetch(key: FirebaseRemoteConfigPrimaryKey, completion: @escaping (Result<String, Error>) -> Void)
}

class FirebaseRemoteConfigRepository: FirebaseRemoteConfigRepositoryProtocol {
    private let remoteConfig: RemoteConfig

    init() {
        remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        #if DEBUG
            settings.minimumFetchInterval = 0
        #endif
        remoteConfig.configSettings = settings
    }
}

extension FirebaseRemoteConfigRepository {
    func fetch(key: FirebaseRemoteConfigPrimaryKey, completion: @escaping (Result<String, Error>) -> Void) {
        remoteConfig.fetchAndActivate { [weak self] status, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            switch status {
            case .successFetchedFromRemote, .successUsingPreFetchedData:
                if let urlString = self?.remoteConfig[key.rawValue].stringValue {
                    completion(.success(urlString))
                } else {
                    completion(.failure(ClientError.unknown))
                }
            case .error:
                completion(.failure(ClientError.apiError(.readError)))
            @unknown default:
                KLogger.devFatalError("remote config")
            }
        }
    }
}
