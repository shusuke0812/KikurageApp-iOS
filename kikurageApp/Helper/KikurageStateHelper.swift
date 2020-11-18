//
//  KikurageStateHelper.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2020/10/22.
//  Copyright © 2020 shusuke. All rights reserved.
//

import UIKit

class KikurageStateHelper {
    /// きくらげの状態によって表情を変える
    /// - Parameter type: きくらげの状態（Firestoreより取得する文字列）
    internal func setStateImage(type: String) ->  [UIImage]{
        var kikurageStateImages: [UIImage] = []
        let beforeImage = UIImage(named: "\(type)_01")!
        let afterImage = UIImage(named: "\(type)_02")!
        
        kikurageStateImages.append(beforeImage)
        kikurageStateImages.append(afterImage)
        
        return kikurageStateImages
    }
}
