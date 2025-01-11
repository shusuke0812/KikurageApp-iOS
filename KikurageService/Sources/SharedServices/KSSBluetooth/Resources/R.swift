//
//  R.swift
//  KikurageService
//
//  Created by Shusuke Ota on 2025/1/11.
//

import UIKit

enum R {
    enum Image {
        static let signalFair = assetImage(named: "signal-fair")
        static let signalGood = assetImage(named: "signal-good")
        static let signalLost = assetImage(named: "signal-lost")
        static let signalWeak = assetImage(named: "signal-weak")
    }

    private static func assetImage(named name: String) -> UIImage? {
        guard let image = UIImage(named: name, in: .module, with: nil) else {
            assertionFailure("Not found asset image: \(name)")
            return nil
        }
        return image
    }
}
