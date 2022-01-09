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
 * （bundleを指定しないとframework内のbundleが呼ばれないため）
 */
class ResorceManager {

    // MARK: Localizable

    /// Localizable.stringデータから文字列を取得する
    static func getLocalizedString(_ string: String) -> String {
        NSLocalizedString(string, tableName: nil, bundle: Bundle(for: self), comment: string)
    }
    
    // MARK: Assets

    /// AssetsデータからUIImageを取得する
    static func getImage(name: String) -> UIImage? {
        UIImage(named: name, in: Bundle(for: self), compatibleWith: nil)
    }
}
