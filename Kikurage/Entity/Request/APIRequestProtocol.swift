//
//  APIRequestProtocol.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2022/4/3.
//  Copyright © 2022 shusuke. All rights reserved.
//

import Foundation
import KikurageFeature

protocol APIRequestProtocol {
    associatedtype Response: Codable

    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: [URLQueryItem]? { get }
    var header: [String: String]? { get }
    var body: Data? { get }

    func buildURLRequest() -> URLRequest
    func decodeData<T>(_ type: T.Type, from data: Data) throws -> T where T: Decodable
}

extension APIRequestProtocol {
    func buildURLRequest() -> URLRequest {
        let url = URL(string: baseURL.appending(path))! // swiftlint:disable:this force_unwrapping
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        switch method {
        case .get:
            components?.queryItems = parameters
        default:
            KLogger.devFatalError("this is not supported http method: \(method)")
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.url = components?.url
        urlRequest.httpMethod = method.rawValue
        header?.forEach { key, value in
            urlRequest.addValue(value, forHTTPHeaderField: key)
        }

        return urlRequest
    }
}
