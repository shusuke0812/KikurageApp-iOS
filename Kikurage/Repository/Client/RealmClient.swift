//
//  RealmClient.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2022/8/13.
//  Copyright © 2022 shusuke. All rights reserved.
//

//
// Ref:
//  - [ important ] transaction: https://www.mongodb.com/docs/realm/sdk/swift/crud/create/#run-a-transaction
//  - CRUD: https://www.mongodb.com/docs/realm/sdk/swift/crud/create/
//  - sort when read Object: https://www.mongodb.com/docs/realm/sdk/swift/crud/read/#sort-query-results
//  - chain queries when read Object: https://www.mongodb.com/docs/realm/sdk/swift/crud/read/#chain-queries
//  - limit of query: https://www.mongodb.com/docs/realm/sdk/swift/crud/read/#limiting-query-results
//  - [ important ] across threads: https://www.mongodb.com/docs/realm/sdk/swift/crud/threading/#communication-across-threads
//  - change listener: https://www.mongodb.com/docs/realm/sdk/swift/react-to-changes/#react-to-changes---swift-sdk
//

import Foundation
import RealmSwift

protocol RealmClientProtocol {
    static func configuration(completion: @escaping (Result<Void, Error>) -> Void)
    static func deleteFiles(completion: @escaping (Result<Void, Error>) -> Void)
    func createRequest<T: KikurageRealmObject>(_ object: T, completion: @escaping (Result<Void, Error>) -> Void)
    func readRequest<T: KikurageRealmObject>(id: String, completion: @escaping (Result<T, Error>) -> Void)
    func deleteRequest<T: KikurageRealmObject>(_ object: T, completion: @escaping (Result<Void, Error>) -> Void)
    func deleteAllRequest(completion: @escaping (Result<Void, Error>) -> Void)
    func updateRequest<T: KikurageRealmObject>(_ object: T, completion: @escaping (Result<Void, Error>) -> Void)
}

struct RealmClient: RealmClientProtocol {
    // MARK: - Initialize

    static func configuration(completion: @escaping (Result<Void, Error>) -> Void) {
        var config = Realm.Configuration()
        config.migrationBlock = { migration, oldSchemaVersion in
            // Must not called Realm() because it is occured dead lock.

            if oldSchemaVersion < 1 {
                migration.enumerateObjects(ofType: KikurageStateGraphObject.className()) { oldObject, newOnject in
                    // Migration. If value can not be set in migration, nothing here. It uses default value. However, it has to increment schemaVersion.

                    // If object is deleted, use delete() or deleteData().
                    // migration.delete(newOnject)
                    // migration.deleteData(forType: KikurageStateGraphObject.className())

                    // If object property name is changed, use renameProperty().
                    // migration.renameProperty(onType: KikurageStateGraphObject.className(), from: <#T##String#>, to: <#T##String#>)
                }
            }
            // In case of changing schema version from 1 to 3, othere condition are written here.
            // if oldSchemaVersion < 3 {}

            // If it is added new object, use create().
            // migration.create(KikurageStateGraphObject.className(), value: /* new value */)
        }
        config.schemaVersion = 1 // default value is `0`
        config.deleteRealmIfMigrationNeeded = false

        do {
            let realm = try Realm(configuration: config)
            completion(.success(()))
        } catch {
            assertionFailure("\(error)")
            completion(.failure(error))
        }
    }

    // MARK: - For Repositoy class

    func createRequest<T: KikurageRealmObject>(_ object: T, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(object, update: .modified)
                completion(.success(()))
            }
        } catch {
            completion(.failure(error))
        }
    }

    // If it runs to sort or use query for object, its method is declared in ViewMiodel using this result.
    func readRequest<T: KikurageRealmObject>(id: String, completion: @escaping (Result<T, Error>) -> Void) {
        do {
            let realm = try Realm()
            if let cache = realm.object(ofType: T.self, forPrimaryKey: T.primaryKey()) {
                completion(.success(cache))
            }
        } catch {
            completion(.failure(error))
        }
    }

    func deleteRequest<T: KikurageRealmObject>(_ object: T, completion: @escaping (Result<Void, Error>) -> Void) {
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

    func updateRequest<T>(_ object: T, completion: @escaping (Result<Void, Error>) -> Void) where T: KikurageRealmObject {
        do {
            let realm = try Realm()
            try realm.write {
                object.update()
                completion(.success(()))
            }
        } catch {
            completion(.failure(error))
        }
    }

    // MARK: - Clean

    static func deleteFiles(completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let fileManager = FileManager.default
            guard let fileURL = Realm.Configuration.defaultConfiguration.fileURL else {
                return
            }

            try fileManager.removeItem(at: fileURL)
            try fileManager.removeItem(at: fileURL.appendingPathExtension("lock"))
            try fileManager.removeItem(at: fileURL.appendingPathExtension("management"))
            completion(.success(()))
        } catch {
            assertionFailure("\(error)")
            completion(.failure(error))
        }
    }
}
