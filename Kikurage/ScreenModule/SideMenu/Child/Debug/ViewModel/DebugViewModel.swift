//
//  DebugViewModel.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2022/6/6.
//  Copyright © 2022 shusuke. All rights reserved.
//

import Foundation

protocol DebugViewModelDelegate: AnyObject {}

class DebugViewModel {
    weak var delegate: DebugViewModelDelegate?

    init() {
    }
}
