//
//  NavigationProtocol+DeviceRegister.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2024/12/28.
//  Copyright © 2024 shusuke. All rights reserved.
//

import KDEntity
import Foundation

protocol DeviceRegisterAccessable: PushNavigationProtocol {
    func pushToHome(kikurageState: KikurageState, kikurageUser: KikurageUser)
}

extension DeviceRegisterAccessable {
    // MARK: - Push

    func pushToHome(kikurageState: KikurageState, kikurageUser: KikurageUser) {
        let vc = HomeViewController()
        vc.kikurageUser = kikurageUser
        vc.kikurageState = kikurageState
        push(to: vc)
    }
}
