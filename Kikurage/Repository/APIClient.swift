//
//  APIClient.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2022/4/3.
//  Copyright © 2022 shusuke. All rights reserved.
//

import Foundation

protocol APIClientProtocol {
    func sendRequest<T: APIRequestProtocol>(_ request: T, completion: @escaping (Result<T.Response, Error>) -> Void)
}

struct APIClient: APIClientProtocol {
    func sendRequest<T: APIRequestProtocol>(_ request: T, completion: @escaping (Result<T.Response, Error>) -> Void) {
    }
}
