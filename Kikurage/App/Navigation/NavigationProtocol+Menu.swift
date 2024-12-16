//
//  NavigationProtocol+Menu.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2022/3/12.
//  Copyright © 2022 shusuke. All rights reserved.
//

import UIKit

protocol MenuAccessable: ModalNavigationProtocol, SafariViewNavigationProtocol {
    func modalToCalendar(completion: (() -> Void)?)
    func modalToGraph(completion: (() -> Void)?)
    func modalToAccountSetting(completion: (() -> Void)?)
    func presentToSafariView(from vc: UIViewController, urlString: String?, onError: (() -> Void)?)
}

extension MenuAccessable {
    // MARK: - Modal

    func modalToCalendar(completion: (() -> Void)? = nil) {
        let vc = CalendarViewController()
        present(to: vc, presentationStyle: .automatic, completion: completion)
    }

    func modalToGraph(completion: (() -> Void)? = nil) {
        let vc = GraphViewController()
        present(to: vc, presentationStyle: .automatic, completion: completion)
    }

    func modalToAccountSetting(completion: (() -> Void)? = nil) {
        let vc = AccountSettingViewController()
        present(to: vc, presentationStyle: .automatic, completion: completion)
    }

    func modalToDictionary(completion: (() -> Void)? = nil) {
        guard let vc = R.storyboard.dictionaryViewController.instantiateInitialViewController() else {
            return
        }
        present(to: vc, presentationStyle: .automatic, completion: completion)
    }

    func modalToWiFi(completion: (() -> Void)? = nil) {
        let vc = WiFiSelectDeviceViewController()
        present(to: vc, presentationStyle: .fullScreen, completion: completion)
    }

    func modalToDebug(completion: (() -> Void)? = nil) {
        guard let vc = R.storyboard.debugViewController.instantiateInitialViewController() else {
            return
        }
        present(to: vc, presentationStyle: .fullScreen, completion: completion)
    }

    // MARK: - SafariView

    func presentToSafariView(from vc: UIViewController, urlString: String?, onError: (() -> Void)? = nil) {
        presentSafariView(from: vc, urlString: urlString, onError: onError)
    }
}
