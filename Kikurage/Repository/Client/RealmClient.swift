//
//  RealmClient.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2022/8/13.
//  Copyright © 2022 shusuke. All rights reserved.
//

/**
 * Ref:
 * - [ important ] transaction: https://www.mongodb.com/docs/realm/sdk/swift/crud/create/#run-a-transaction
 * - CRUD: https://www.mongodb.com/docs/realm/sdk/swift/crud/create/
 * - sort when read Object: https://www.mongodb.com/docs/realm/sdk/swift/crud/read/#sort-query-results
 * - chain queries when read Object: https://www.mongodb.com/docs/realm/sdk/swift/crud/read/#chain-queries
 * - limit of query: https://www.mongodb.com/docs/realm/sdk/swift/crud/read/#limiting-query-results
 * - [ important ] across threads: https://www.mongodb.com/docs/realm/sdk/swift/crud/threading/#communication-across-threads
 * - change listener: https://www.mongodb.com/docs/realm/sdk/swift/react-to-changes/#react-to-changes---swift-sdk
 */

import Foundation
import RealmSwift

protocol RealmClientProtocol {
    func createRequest<T: RealmSwift.Object>(_ object: T, completion: @escaping (Result<Void, Error>) -> Void)
    func readRequest<T: RealmSwift.Object>(id: String, completion: @escaping (Result<T, Error>) -> Void)
    func deleteRequest<T: RealmSwift.Object>(_ object: T, completion: @escaping (Result<Void, Error>) -> Void)
    func deleteAllRequest(completion: @escaping (Result<Void, Error>) -> Void)
}

struct RealmClient: RealmClientProtocol {
    func createRequest<T: RealmSwift.Object>(_ object: T, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(object)
                completion(.success(()))
            }
        } catch {
            completion(.failure(error))
        }
    }

    // If it runs to sort or use query for object, its method is declared in ViewMiodel using this result.
    func readRequest<T: RealmSwift.Object>(id: String, completion: @escaping (Result<T, Error>) -> Void) {
        do {
            let realm = try Realm()
            if let cache = realm.object(ofType: T.self, forPrimaryKey: T.primaryKey()) {
                completion(.success(cache))
            }
        } catch {
            completion(.failure(error))
        }
    }

    func deleteRequest<T: RealmSwift.Object>(_ object: T, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.delete(object)
                completion(.success(()))
            }
        } catch {
            completion(.failure(error))
        }
    }

    func deleteAllRequest(completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let realm = try Realm()
            realm.deleteAll()
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
    }
}
