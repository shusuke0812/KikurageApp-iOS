//
//  TwitterSearchRequest.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2022/4/3.
//  Copyright © 2022 shusuke. All rights reserved.
//

// Doc: https://developer.twitter.com/en/docs/twitter-api/v1/tweets/search/api-reference/get-search-tweets

import KDRestApi
import Foundation

public struct TwitterSearchRequest: APIRequestProtocol {
    public let searchWord: String
    public let searchCount: Int
    public let maxID: Int64?
    public let sinceID: Int64?
    
    public init(searchWord: String, searchCount: Int, maxID: Int64?, sinceID: Int64?) {
        self.searchWord = searchWord
        self.searchCount = searchCount
        self.maxID = maxID
        self.sinceID = sinceID
    }

    public typealias Response = Tweet

    var bearerToken: String {
        guard let url = Bundle.main.url(forResource: "TwitterAccessKey", withExtension: "json") else {
            fatalError("can not read access token file")
        }
        guard let data = try? Data(contentsOf: url) else {
            fatalError("can not read access token data")
        }
        guard let accessToken = try? JSONDecoder().decode(AccessToken.self, from: data) else {
            fatalError("can not parse access token data to JSON")
        }
        return accessToken.bearerToken
    }

    // MARK: APIRequestProtocol properties

    public var baseURL: String {
        "https://api.twitter.com/1.1"
    }

    public var method: HTTPMethod {
        .get
    }

    public var path: String {
        "/search/tweets.json"
    }

    public var parameters: [URLQueryItem]? {
        [
            URLQueryItem(name: "q", value: searchWord),
            URLQueryItem(name: "count", value: "\(searchCount)"),
            URLQueryItem(name: "max_id", value: "\(maxID ?? 0)"),
            URLQueryItem(name: "since_id", value: "\(sinceID ?? 0)")
        ]
    }

    public var header: [String: String]? {
        [
            "Content-type": "application/x-www-form-urlencoded;charset=UTF-8",
            "Authorization": "Bearer \(bearerToken)"
        ]
    }

    public var body: Data? {
        nil
    }

    // MARK: - Response decoder

    public func decodeData<T>(_ type: T.Type, from data: Data) throws -> T where T: Decodable {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(twitterSearchDateFormat)
        return try decoder.decode(type, from: data)
    }
    
    private var twitterSearchDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE MMM dd HH:mm:ss ZZZZZ yyyy"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}
