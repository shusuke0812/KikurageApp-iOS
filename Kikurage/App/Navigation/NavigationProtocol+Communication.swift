//
//  NavigationProtocol+Communication.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2022/3/12.
//  Copyright © 2022 shusuke. All rights reserved.
//

import UIKit

protocol CommunicationAccessable: PushNavigationProtocol {
    func pushToCommunication()
}

extension CommunicationAccessable {
    func pushToCommunication() {
        guard let vc = R.storyboard.communicationViewController.instantiateInitialViewController() else { return }
        push(to: vc)
    }
}
