//
//  KikurageState.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2020/10/15.
//  Copyright © 2020 shusuke. All rights reserved.
//

import UIKit

public struct KikurageState: Codable {
    public var temperature: Int?
    public var humidity: Int?
    public var message: String?
    public var typeString: String? // dry, normal, hot
    public var advice: String?

    public enum CodingKeys: String, CodingKey {
        case temperature
        case humidity
        case message
        case typeString = "judge"
        case advice
    }

    public var type: KikurageStateType? {
        if typeString == KikurageStateType.normal.rawValue {
            return .normal
        } else if typeString == KikurageStateType.wet.rawValue {
            return .wet
        } else if typeString == KikurageStateType.dry.rawValue {
            return .dry
        } else {
            return nil
        }
    }
}

public enum KikurageStateType: String, Codable {
    case normal
    case wet
    case dry

    public func getStateImages() -> [UIImage] {
        var kikurageStateImages: [UIImage] = []
        let beforeImage = UIImage(named: "\(rawValue)_01")! // swiftlint:disable:this force_unwrapping
        let afterImage = UIImage(named: "\(rawValue)_02")! // swiftlint:disable:this force_unwrapping

        kikurageStateImages.append(beforeImage)
        kikurageStateImages.append(afterImage)

        return kikurageStateImages
    }
}
