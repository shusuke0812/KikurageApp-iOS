//
//  NavigationProtocol+Login.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2024/12/27.
//  Copyright © 2024 shusuke. All rights reserved.
//

import Foundation
import KDEntity

protocol LoginAccessable: PushNavigationProtocol {
    func pushToHome(kikurageState: KikurageState, kikurageUser: KikurageUser)
}

extension LoginAccessable {
    // MARK: - Push

    func pushToHome(kikurageState: KikurageState, kikurageUser: KikurageUser) {
        let vc = HomeViewController()
        vc.kikurageUser = kikurageUser
        vc.kikurageState = kikurageState
        push(to: vc)
    }
}
