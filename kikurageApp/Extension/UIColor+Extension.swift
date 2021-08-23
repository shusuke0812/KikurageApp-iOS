//
//  UIColor+Extension.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2020/11/18.
//  Copyright © 2020 shusuke. All rights reserved.
//

import UIKit

extension UIColor {
    /// テーマカラー
    static var themeColor: UIColor {
        UIColor(named: "themeColor")! // swiftlint:disable:this force_unwrapping
    }
    /// サブカラー
    static var subColor: UIColor {
        UIColor(named: "subColor")! // swiftlint:disable:this force_unwrapping
    }
    /// お知らせカラー
    static var information: UIColor {
        UIColor(named: "informationColor")! // swiftlint:disable:this force_unwrapping
    }
}
