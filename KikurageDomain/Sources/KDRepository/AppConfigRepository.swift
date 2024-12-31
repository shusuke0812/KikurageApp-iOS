//
//  FirebaseRemoteConfigRepository.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2021/12/1.
//  Copyright © 2021 shusuke. All rights reserved.
//

import KDFirebase

enum FirebaseRemoteConfigPrimaryKey: String {
    case facebookGroupURL = "facebook_group_url"
    case termsURL = "terms_url"
    case privacyPolicyURL = "privacy_policy_url"
    case latestAppVersion = "ios_latest_app_version"
}

public protocol AppConfigRepositoryProtocol {
    func getFacebookGroupUrl(completion: @escaping (Result<String, FirebaseClientError>) -> Void)
    func getTermsUrl(completion: @escaping (Result<String, FirebaseClientError>) -> Void)
    func getPrivacyPolicyUrl(completion: @escaping (Result<String, FirebaseClientError>) -> Void)
    func getLatestAppVersion(completion: @escaping (Result<String, FirebaseClientError>) -> Void)
}

public class AppConfigRepository: AppConfigRepositoryProtocol {
    private let firebaseRemoteConfigClient: FirebaseRemoteConfigClientProtocol

    public init(firebaseRemoteConfigClient: FirebaseRemoteConfigClientProtocol = FirebaseRemoteConfigClient()) {
        self.firebaseRemoteConfigClient = firebaseRemoteConfigClient
    }
}

extension AppConfigRepository {
    public func getFacebookGroupUrl(completion: @escaping (Result<String, FirebaseClientError>) -> Void) {
        firebaseRemoteConfigClient.fetch(key: FirebaseRemoteConfigPrimaryKey.facebookGroupURL.rawValue) { result in
            switch result {
            case .success(let url):
                completion(.success(url))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func getTermsUrl(completion: @escaping (Result<String, KDFirebase.FirebaseClientError>) -> Void) {
        firebaseRemoteConfigClient.fetch(key: FirebaseRemoteConfigPrimaryKey.termsURL.rawValue) { result in
            switch result {
            case .success(let url):
                completion(.success(url))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func getPrivacyPolicyUrl(completion: @escaping (Result<String, KDFirebase.FirebaseClientError>) -> Void) {
        firebaseRemoteConfigClient.fetch(key: FirebaseRemoteConfigPrimaryKey.privacyPolicyURL.rawValue) { result in
            switch result {
            case .success(let url):
                completion(.success(url))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func getLatestAppVersion(completion: @escaping (Result<String, KDFirebase.FirebaseClientError>) -> Void) {
        firebaseRemoteConfigClient.fetch(key: FirebaseRemoteConfigPrimaryKey.latestAppVersion.rawValue) { result in
            switch result {
            case .success(let url):
                completion(.success(url))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
