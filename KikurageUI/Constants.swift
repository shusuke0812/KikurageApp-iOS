//
//  Constants.swift
//  KikurageUI
//
//  Created by Shusuke Ota on 2024/6/17.
//  Copyright © 2024 shusuke. All rights reserved.
//

import UIKit

enum Constants {
    enum Color: RawRepresentable {
        case cultivation
        case recipe
        case communication

        typealias RawValue = UIColor

        init?(rawValue: RawValue) {
            switch rawValue {
            case UIColor(hex: "4A90E2"): self = .cultivation
            case UIColor(hex: "F5A623"): self = .recipe
            case UIColor(hex: "7ED321"): self = .communication
            default: return nil
            }
        }

        var rawValue: RawValue {
            switch self {
            case .cultivation:
                return UIColor(hex: "4A90E2")
            case .recipe:
                return UIColor(hex: "F5A623")
            case .communication:
                return UIColor(hex: "7ED321")
            }
        }
    }
}
