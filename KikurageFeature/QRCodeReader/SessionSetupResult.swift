//
//  SessionSetupResult.swift
//  KikurageFeature
//
//  Created by Shusuke Ota on 2022/7/24.
//  Copyright © 2022 shusuke. All rights reserved.
//

import Foundation

public enum SessionSetupResult {
    case success
    case error(SessionSetupError)
}

public enum SessionSetupError {
    case failure
    case notAuthorized
    
    // TODO: add description for displaying error message alert
}
