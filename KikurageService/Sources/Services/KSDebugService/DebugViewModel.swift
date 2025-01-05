//
//  DebugViewModel.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2022/6/6.
//  Copyright © 2022 shusuke. All rights reserved.
//

import Foundation

public protocol DebugViewModelDelegate: AnyObject {}

public class DebugViewModel {
    public weak var delegate: DebugViewModelDelegate?

    public init() {}
}
