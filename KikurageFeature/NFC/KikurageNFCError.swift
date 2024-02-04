//
//  KikurageNFCError.swift
//  KikurageFeature
//
//  Created by Shusuke Ota on 2023/4/29.
//  Copyright © 2023 shusuke. All rights reserved.
//

import Foundation

enum KikurageNFCError: Error {
    case notAvailable
    case messageGetFail

    var description: String {
        switch self {
        case .notAvailable:
            return ResorceManager.getLocalizedString("nfc_available_fail_description")
        case .messageGetFail:
            return ResorceManager.getLocalizedString("nfc_message_get_fail_description")
        }
    }
}
