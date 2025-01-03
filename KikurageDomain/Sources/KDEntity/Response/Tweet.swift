//
//  Tweet.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2022/4/3.
//  Copyright © 2022 shusuke. All rights reserved.
//

// Doc: https://developer.twitter.com/en/docs/twitter-api/v1/tweets/search/api-reference/get-search-tweets

import Foundation

public struct Tweet: Codable {
    public let statuses: [Status]

    public struct Status: Codable {
        public let id: Int64
        public let text: String
        public let user: User
        public let createdAt: Date

        public enum CodingKeys: String, CodingKey {
            case id
            case text
            case user
            case createdAt = "created_at"
        }
    }

    public struct User: Codable {
        public let name: String
        public let screenName: String
        public let profileImageURL: String

        public enum CodingKeys: String, CodingKey {
            case name
            case screenName = "screen_name"
            case profileImageURL = "profile_image_url_https"
        }
    }
}
