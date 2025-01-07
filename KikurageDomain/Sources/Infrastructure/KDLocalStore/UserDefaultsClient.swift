//
//  UserDefaultsClient.swift
//  KikurageDomain
//
//  Created by Shusuke Ota on 2025/1/2.
//

import Foundation

public protocol UserDefaultClientProtocol {
    func read<T: UserDefaultsRequestProtocol>(_ request: T) -> Result<T.Response, LocalStoreError>
    func update<T: UserDefaultsRequestProtocol>(_ request: T, onError: ((LocalStoreError) -> Void)?)
    func remove<T: UserDefaultsRequestProtocol>(_ request: T)
}

public class UserDefaultClient: UserDefaultClientProtocol {
    public init() {}

    public func read<T: UserDefaultsRequestProtocol>(_ request: T) -> Result<T.Response, LocalStoreError> {
        if let data = UserDefaults.standard.object(forKey: request.key) as? Data {
            do {
                // TODO: Replace to JSONEncoder and JSONDecoder
                if let response = try NSKeyedUnarchiver.unarchivedObject(ofClass: T.Response.self, from: data) {
                    return .success(response)
                }
            } catch {
                return .failure(.failedToDecode(error))
            }
        }
        return .failure(.notFound)
    }

    public func update<T: UserDefaultsRequestProtocol>(_ request: T, onError: ((LocalStoreError) -> Void)?) {
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: T.Response.self, requiringSecureCoding: true)
            UserDefaults.standard.set(data, forKey: request.key)
        } catch {
            onError?(.failedToEncode(error))
        }
    }

    public func remove<T: UserDefaultsRequestProtocol>(_ request: T) {
        UserDefaults.standard.removeObject(forKey: request.key)
    }
}
