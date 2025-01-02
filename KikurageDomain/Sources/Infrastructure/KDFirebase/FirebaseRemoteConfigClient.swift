//
//  FirebaseRemoteConfigClient.swift
//  KikurageDomain
//
//  Created by Shusuke Ota on 2024/12/31.
//

import FirebaseRemoteConfig
import Foundation

public protocol FirebaseRemoteConfigClientProtocol {
    func fetch(key: String, completion: @escaping (Result<String, FirebaseClientError>) -> Void)
}

public class FirebaseRemoteConfigClient: FirebaseRemoteConfigClientProtocol {
    private let remoteConfig: RemoteConfig

    public init() {
        remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        #if DEBUG
            settings.minimumFetchInterval = 0
        #endif
        remoteConfig.configSettings = settings
    }
    
    public func fetch(key: String, completion: @escaping (Result<String, FirebaseClientError>) -> Void) {
        remoteConfig.fetchAndActivate { [weak self] status, error in
            if let error = error {
                completion(.failure(.apiError(.readError)))
                return
            }
            switch status {
            case .successFetchedFromRemote, .successUsingPreFetchedData:
                if let resultString = self?.remoteConfig[key].stringValue {
                    completion(.success(resultString))
                    return
                }
                completion(.failure(.unknown))
            case .error:
                completion(.failure(.apiError(.readError)))
            @unknown default:
                assertionFailure()
            }
        }
    }
}
