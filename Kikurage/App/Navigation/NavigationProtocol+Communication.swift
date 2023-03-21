//
//  NavigationProtocol+Communication.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2022/3/12.
//  Copyright © 2022 shusuke. All rights reserved.
//

import UIKit

protocol CommunicationAccessable: PushNavigationProtocol, SafariViewNavigationProtocol {
    func pushToCommunication()
    func presentToSafariView(from vc: UIViewController, urlString: String?, onError: (() -> Void)?)
}

extension CommunicationAccessable {
    // MARK: - Push

    func pushToCommunication() {
        guard let vc = R.storyboard.communicationViewController.instantiateInitialViewController() else {
            return
        }
        push(to: vc)
    }

    // MARK: - SafariView

    func presentToSafariView(from vc: UIViewController, urlString: String?, onError: (() -> Void)?) {
        presentSafariView(from: vc, urlString: urlString, onError: onError)
    }
}
