//
//  KikurageStateHelper.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2020/10/22.
//  Copyright © 2020 shusuke. All rights reserved.
//

import UIKit

class KikurageStateHelper {
    internal func setStateImage(type: String) ->  [UIImage]{
        // きくらげの状態によって表情を変える
        var kikurageStateImages: [UIImage] = []
        let beforeImage = UIImage(named: "\(type)_01")!
        let afterImage = UIImage(named: "\(type)_02")!
        
        kikurageStateImages.append(beforeImage)
        kikurageStateImages.append(afterImage)
        
        return kikurageStateImages
    }
}
