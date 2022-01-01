//
//  KikurageStateHelper.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2020/10/22.
//  Copyright © 2020 shusuke. All rights reserved.
//

import UIKit

struct KikurageStateHelper {
    private init() {}

    /// きくらげの状態によって表情を変える
    /// - Parameter type: きくらげの状態（Firestoreより取得する文字列）
    static func setStateImage(type: KikurageStateType) -> [UIImage] {
        var kikurageStateImages: [UIImage] = []
        let beforeImage = UIImage(named: "\(type.rawValue)_01")! // swiftlint:disable:this force_unwrapping
        let afterImage = UIImage(named: "\(type.rawValue)_02")!  // swiftlint:disable:this force_unwrapping

        kikurageStateImages.append(beforeImage)
        kikurageStateImages.append(afterImage)

        return kikurageStateImages
    }
}
