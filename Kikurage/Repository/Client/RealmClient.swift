//
//  RealmClient.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2022/8/13.
//  Copyright © 2022 shusuke. All rights reserved.
//

import Foundation
import RealmSwift

protocol RealmClientProtocol {
    func writeRequest<T: RealmSwift.Object>(_ object: T, completion: @escaping (Result<Void, Error>) -> Void)
    func readRequest<T: RealmSwift.Object>(id: String, completion: @escaping (Result<T, Error>) -> Void)
}

struct RealmClient: RealmClientProtocol {
    func writeRequest<T: RealmSwift.Object>(_ object: T, completion: @escaping (Result<Void, Error>) -> Void) {
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
}
