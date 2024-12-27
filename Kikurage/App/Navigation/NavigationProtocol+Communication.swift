//
//  NavigationProtocol+Communication.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2022/3/12.
//  Copyright © 2022 shusuke. All rights reserved.
//

import UIKit

protocol CommunicationAccessable: PushNavigationProtocol, SafariViewNavigationProtocol {
    func presentToSafariView(urlString: String?, onError: (() -> Void)?)
}

extension CommunicationAccessable {
    // MARK: - SafariView

    func presentToSafariView(urlString: String?, onError: (() -> Void)?) {
        presentSafariView(urlString: urlString, onError: onError)
    }
}
