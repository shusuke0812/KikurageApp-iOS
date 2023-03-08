//
//  AccessToken.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2022/4/5.
//  Copyright © 2022 shusuke. All rights reserved.
//

import Foundation

struct AccessToken: Codable {
    let apiKey: String
    let apiSecretKey: String
    let bearerToken: String

    enum CodingKeys: String, CodingKey {
        case apiKey = "api_key"
        case apiSecretKey = "api_key_secret"
        case bearerToken = "bearer_token"
    }
}
