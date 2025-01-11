//
//  APIClient.swift
//  KikurageDomain
//
//  Created by Shusuke Ota on 2024/12/31.
//

import Foundation
import RxSwift

public protocol APIClientProtocol {
    func sendRequest<T: APIRequestProtocol>(_ request: T, completion: @escaping (Result<T.Response, RestApiClientError>) -> Void)
    func sendRequest<T: APIRequestProtocol>(_ request: T) -> Single<T.Response>
}

public struct APIClient: APIClientProtocol {
    public init() {}

    public func sendRequest<T: APIRequestProtocol>(_ request: T, completion: @escaping (Result<T.Response, RestApiClientError>) -> Void) {
        let session = URLSession.shared
        let task = session.dataTask(with: request.buildURLRequest()) { data, response, error in
            if let error = error {
                completion(.failure(.networkConnectionError(error)))
                return
            }
            guard let data = data, let response = response as? HTTPURLResponse else {
                completion(.failure(.noResponse))
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

    public func sendRequest<T: APIRequestProtocol>(_ request: T) -> Single<T.Response> {
        Single<T.Response>.create { single in
            let session = URLSession.shared
            let task = session.dataTask(with: request.buildURLRequest()) { data, response, error in
                if let error = error {
                    single(.failure(error))
                    return
                }
                guard let data = data, let response = response as? HTTPURLResponse else {
                    // TODO: change error type
                    single(.failure(RestApiClientError.unknown))
                    return
                }
                if (200 ..< 300).contains(response.statusCode) {
                    do {
                        let apiResponse = try request.decodeData(T.Response.self, from: data)
                        single(.success(apiResponse))
                    } catch {
                        single(.failure(RestApiClientError.parseError(error)))
                    }
                } else {
                    // TODO: decode in case of custom error type
                    single(.failure(RestApiClientError.unknown))
                }
            }
            task.resume()
            return Disposables.create()
        }
    }
}
