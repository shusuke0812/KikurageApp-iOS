//
//  Constants.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2020/10/9.
//  Copyright © 2020 shusuke. All rights reserved.
//

import UIKit

enum Constants {
    enum CameraCollectionCell {
        /// 画像選択の最大数
        static let maxNumber = 8
    }

    enum Week: String, CaseIterable {
        case monday
        case tuesday
        case wednesday
        case thursday
        case friday
        case saturday
        case sunday

        var localizedString: String {
            switch self {
            case .monday:
                return R.string.localizable.common_week_monday()
            case .tuesday:
                return R.string.localizable.common_week_tuesday()
            case .wednesday:
                return R.string.localizable.common_week_wednesday()
            case .thursday:
                return R.string.localizable.common_week_thursday()
            case .friday:
                return R.string.localizable.common_week_friday()
            case .saturday:
                return R.string.localizable.common_week_saturday()
            case .sunday:
                return R.string.localizable.common_week_sunday()
            }
        }
    }

    enum Email {
        static let address = "kikurageproject2019@googlegroups.com"
    }
}
