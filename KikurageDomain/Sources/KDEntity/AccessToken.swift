//
//  AccessToken.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2022/4/5.
//  Copyright © 2022 shusuke. All rights reserved.
//

import Foundation

public struct AccessToken: Codable {
    public let apiKey: String
    public let apiSecretKey: String
    public let bearerToken: String

    public enum CodingKeys: String, CodingKey {
        case apiKey = "api_key"
        case apiSecretKey = "api_key_secret"
        case bearerToken = "bearer_token"
    }
}
