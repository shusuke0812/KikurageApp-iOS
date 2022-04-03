//
//  APIClient.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2022/4/3.
//  Copyright © 2022 shusuke. All rights reserved.
//

import Foundation

protocol APIClientProtocol {
    func sendRequest<T: APIRequestProtocol>(_ request: T, completion: @escaping (Result<T.Response, T.ErrorResponse>) -> Void)
}

struct APIClient: APIClientProtocol {
    func sendRequest<T: APIRequestProtocol>(_ request: T, completion: @escaping (Result<T.Response, T.ErrorResponse>) -> Void) {
        let session = URLSession.shared
        let errorResponse = T.ErrorResponse.self as! T.ErrorResponse
        let task = session.dataTask(with: request.buildUrlRequest()) { data, response, error in
            if let error = error {
                KLogger.debug(error.localizedDescription)
                completion(.failure(errorResponse))
                return
            }
            guard let data = data, let response = response as? HTTPURLResponse else {
                completion(.failure(errorResponse))
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
                    completion(.failure(errorResponse))
                }
            } else {
                // TODO: decode in case of custom error type
                completion(.failure(errorResponse))
            }
        }
        task.resume()
    }
}
