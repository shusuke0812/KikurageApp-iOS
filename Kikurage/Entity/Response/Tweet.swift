//
//  Tweet.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2022/4/3.
//  Copyright © 2022 shusuke. All rights reserved.
//

// Doc: https://developer.twitter.com/en/docs/twitter-api/v1/tweets/search/api-reference/get-search-tweets

import Foundation

struct Tweet: Codable {
    let statuses: [Status]

    struct Status: Codable {
        let id: Int64
        let text: String
        let user: User
        let createdAt: Date

        enum CodingKeys: String, CodingKey {
            case id
            case text
            case user
            case createdAt = "created_at"
        }
    }

    struct User: Codable {
        let name: String
        let screenName: String
        let profileImageUrl: String

        enum CodingKeys: String, CodingKey {
            case name
            case screenName = "screen_name"
            case profileImageUrl = "profile_image_url_https"
        }
    }
}
