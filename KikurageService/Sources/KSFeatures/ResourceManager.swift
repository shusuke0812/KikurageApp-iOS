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
public class ResourceManager {
    // MARK: Localizable

    /// Localizable.stringデータから文字列を取得する
    @available(*, deprecated, message: "This is legacy system. You should replace to `String catalogs`")
    public static func getLocalizedString(_ string: String) -> String {
        NSLocalizedString(string, tableName: nil, bundle: .main, comment: string)
    }

    // MARK: Assets

    /// AssetsデータからUIImageを取得する
    public static func getImage(name: String) -> UIImage? {
        UIImage(named: name, in: .main, compatibleWith: nil)
    }
}
