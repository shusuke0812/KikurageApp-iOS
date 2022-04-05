//
//  APIClient.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2022/4/3.
//  Copyright © 2022 shusuke. All rights reserved.
//

import Foundation

protocol APIClientProtocol {
    func sendRequest<T: APIRequestProtocol>(_ request: T, completion: @escaping (Result<T.Response, ClientError>) -> Void)
}

struct APIClient: APIClientProtocol {
    func sendRequest<T: APIRequestProtocol>(_ request: T, completion: @escaping (Result<T.Response, ClientError>) -> Void) {
        let session = URLSession.shared
        let task = session.dataTask(with: request.buildUrlRequest()) { data, response, error in
            if let error = error {
                completion(.failure(.networkConnectionError(error)))
                return
            }
            guard let data = data, let response = response as? HTTPURLResponse else {
                // TODO: change error type
                completion(.failure(.unknown))
                return
            }
            // TODO: write decode method outside this type
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601

            if (200 ..< 300).contains(response.statusCode) {
                do {
                    let apiResponse = try decoder.decode(T.Response.self, from: data)
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
}
