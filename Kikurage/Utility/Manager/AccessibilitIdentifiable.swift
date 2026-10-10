//
//  AccessibilitIdentifiable.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2022/2/8.
//  Copyright © 2022 shusuke. All rights reserved.
//

import UIKit
import SwiftUI

protocol AccessibilitIdentifiable {
    func generateAccessibilityIdentifier(filepath: String)
}

extension AccessibilitIdentifiable where Self: UIView {
    func generateAccessibilityIdentifier(filepath: String = #file) {
        #if DEBUG
        let mirror = Mirror(reflecting: self)

        for child in mirror.children {
            if let view = child.value as? UIView,
               let propertyName = child.label?.replacingOccurrences(of: ".storage", with: "") {
                view.accessibilityIdentifier = "\(className(from: filepath)).\(propertyName)"
            }
        }
        #endif
    }
}

struct Accessibility {
    static func generateIdentifier(filepath: String = #file) -> String {
        "\(className(from: filepath))"
    }
}

fileprivate func className(from filepath: String) -> String {
    let fileName = filepath.components(separatedBy: "/").last
    return fileName?.components(separatedBy: ".").first ?? ""
}
