//
//  UserDefaultClient.swift
//  KikurageDomain
//
//  Created by Shusuke Ota on 2025/1/2.
//

import Foundation

public protocol UserDefaultClientProtocol {
    func read<T>(with key: String, completion: @escaping (Result<T, Error?>) -> Void)
    func update<T>(with key: String, onError: ((Error) -> Void)?)
    func remove(with key: String)
}

public class UserDefaultClient: UserDefaultClientProtocol {
    public init() {}
    
    func read<T>(with key: String, completion: @escaping (Result<T, Error?>) -> Void) {
        if let data = UserDefaults.standard.object(forKey: key) as? Data {
            do {
                if let response = try NSKeyedUnarchiver.unarchivedObject(ofClass: T.self, from: data) {
                    completion(.success(response))
                    return
                }
            } catch {
                completion(.failure(error))
                return
            }
        }
        completion(.failure(nil))
    }
    
    func update<T>(with key: String, onError: ((Error) -> Void)?) {
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: T, requiringSecureCoding: true)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            onError?(error)
        }
    }
    
    func remove(with key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
