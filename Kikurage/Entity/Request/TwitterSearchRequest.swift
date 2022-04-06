//
//  TwitterAPIRequest.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2022/4/3.
//  Copyright © 2022 shusuke. All rights reserved.
//

// Doc: https://developer.twitter.com/en/docs/twitter-api/v1/tweets/search/api-reference/get-search-tweets

import Foundation

struct TwitterSearchRequest: APIRequestProtocol {
    let searchWord: String
    let searchCount: Int
    let maxId: Int64?
    let sinceId: Int64?

    typealias Response = Tweet

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

    var baseUrl: String {
        "https://api.twitter.com/1.1"
    }
    var method: HTTPMethod {
        .get
    }
    var path: String {
        "/search/tweets.json"
    }
    var parameters: [URLQueryItem]? {
        [
            URLQueryItem(name: "q", value: searchWord),
            URLQueryItem(name: "count", value: "\(searchCount)"),
            URLQueryItem(name: "max_id", value: "\(maxId ?? 0)"),
            URLQueryItem(name: "since_id", value: "\(sinceId ?? 0)")
        ]
    }
    var header: [String: String]? {
        [
            "Content-type": "application/x-www-form-urlencoded;charset=UTF-8",
            "Authorization": "Bearer \(bearerToken)"
        ]
    }
    var body: Data? {
        nil
    }
}
