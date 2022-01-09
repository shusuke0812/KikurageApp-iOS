//
//  ResourceManager.swift
//  KikurageFeature
//
//  Created by Shusuke Ota on 2022/1/9.
//  Copyright © 2022 shusuke. All rights reserved.
//

import UIKit

/**
 * Assets / Localizable からデータを取得するManagerクラス
 * （framework内のbundleが呼ばれない対策）
 */
class ResorceManager {
    /// AssetsデータからUIImageを取得する
    static func getImage(name: String) -> UIImage? {
        UIImage(named: name, in: Bundle(for: self), compatibleWith: nil)
    }
}
