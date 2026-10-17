//
//  NavigationProtocol+Login.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2024/12/27.
//  Copyright © 2024 shusuke. All rights reserved.
//

import Foundation
import KDEntity
import KDLoginManager

protocol LoginAccessable: PushNavigationProtocol {
    func pushToHome(kikurageUser: KikurageUser)
}

extension LoginAccessable {
    // MARK: - Push

    func pushToHome(kikurageUser: KikurageUser) {
        let userId = LoginManager().userID ?? ""
        let vc = HomeViewController(productKey: kikurageUser.productKey, userId: userId)
        push(to: vc)
    }
}
