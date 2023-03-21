//
//  APIClient.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2022/4/3.
//  Copyright © 2022 shusuke. All rights reserved.
//

import Foundation
import RxSwift

protocol APIClientProtocol {
    func sendRequest<T: APIRequestProtocol>(_ request: T, completion: @escaping (Result<T.Response, ClientError>) -> Void)
    func sendRequest<T: APIRequestProtocol>(_ request: T) -> Single<T.Response>
}

struct APIClient: APIClientProtocol {
    func sendRequest<T: APIRequestProtocol>(_ request: T, completion: @escaping (Result<T.Response, ClientError>) -> Void) {
        let session = URLSession.shared
        let task = session.dataTask(with: request.buildURLRequest()) { data, response, error in
            if let error = error {
                completion(.failure(.networkConnectionError(error)))
                return
            }
            guard let data = data, let response = response as? HTTPURLResponse else {
                // TODO: change error type
                completion(.failure(.unknown))
                return
            }
            if (200 ..< 300).contains(response.statusCode) {
                do {
                    let apiResponse = try request.decodeData(T.Response.self, from: data)
                    completion(.success(apiResponse))
                } catch {
                    completion(.failure(.responseParseError(error)))
                }
            } else {
                // TODO: decode in case of custom error type
                completion(.failure(.unknown))
            }
        }
        task.resume()
    }

    func sendRequest<T: APIRequestProtocol>(_ request: T) -> Single<T.Response> {
        Single<T.Response>.create { single in
            let session = URLSession.shared
            let task = session.dataTask(with: request.buildURLRequest()) { data, response, error in
                if let error = error {
                    single(.failure(error))
                    return
                }
                guard let data = data, let response = response as? HTTPURLResponse else {
                    // TODO: change error type
                    single(.failure(ClientError.unknown))
                    return
                }
                if (200 ..< 300).contains(response.statusCode) {
                    do {
                        let apiResponse = try request.decodeData(T.Response.self, from: data)
                        single(.success(apiResponse))
                    } catch {
                        single(.failure(ClientError.parseError(error)))
                    }
                } else {
                    // TODO: decode in case of custom error type
                    single(.failure(ClientError.unknown))
                }
            }
            task.resume()
            return Disposables.create()
        }
    }
}
