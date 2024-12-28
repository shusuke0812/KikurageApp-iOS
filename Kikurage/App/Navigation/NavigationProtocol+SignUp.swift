//
//  NavigationProtocol+SignUp.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2024/12/28.
//  Copyright © 2024 shusuke. All rights reserved.
//

import Foundation

protocol SignUpAccessable: PushNavigationProtocol {
    func pushToDeviceRegister()
}

extension SignUpAccessable {
    // MARK: - Push

    func pushToDeviceRegister() {
        let vc = DeviceRegisterViewController()
        push(to: vc)
    }
}
