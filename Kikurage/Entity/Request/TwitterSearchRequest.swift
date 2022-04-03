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
    let bearerToken: String

    typealias Response = Tweet
    typealias ErrorResponse = ClientError

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
            "Content-type": "application/x-www-form-urlencoded;charset=UUTF-8",
            "Authorization": "Bearer \(bearerToken)"
        ]
    }
    var body: Data? {
        nil
    }
}
