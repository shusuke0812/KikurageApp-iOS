//
//  PageObjectable.swift
//  KikurageUITests
//
//  Created by Shusuke Ota on 2022/2/12.
//  Copyright © 2022 shusuke. All rights reserved.
//

import Foundation
import XCTest

protocol PageObjectable {
    associatedtype A11y
    var app: XCUIApplication { get }
    var exists: Bool { get }
    var pageTitle: XCUIElement { get }
    
    func elementsExist(_ elements: [XCUIElement], timeout: Double) -> Bool
}
