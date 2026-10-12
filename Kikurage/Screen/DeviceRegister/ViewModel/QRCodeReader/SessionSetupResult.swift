//
//  SessionSetupResult.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2022/7/24.
//  Copyright © 2022 shusuke. All rights reserved.
//

import Foundation

enum SessionSetupResult: Equatable {
    case success
    case error(SessionSetupError)
}

enum SessionSetupError {
    case failure
    case notAuthorized
    case notReadQRCode

    // TODO: add description for displaying error message alert
}
