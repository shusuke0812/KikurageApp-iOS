//
//  RealmClient.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2022/8/13.
//  Copyright © 2022 shusuke. All rights reserved.
//

import Foundation

protocol RealmClientProtocol {
    func writeRequest<T>(_ request: T, completion: @escaping (Result<Void, Error>) -> Void)
}
