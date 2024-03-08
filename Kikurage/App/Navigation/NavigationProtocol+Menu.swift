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
    func presentToSafariView(urlString: String?, onError: (() -> Void)?)
}

extension MenuAccessable {
    // MARK: - Modal

    func modalToCalendar(completion: (() -> Void)? = nil) {
        guard let vc = R.storyboard.calendarViewController.instantiateInitialViewController() else {
            return
        }
        present(to: vc, style: .automatic, completion: completion)
    }

    func modalToGraph(completion: (() -> Void)? = nil) {
        guard let vc = R.storyboard.graphViewController.instantiateInitialViewController() else {
            return
        }
        present(to: vc, style: .automatic, completion: completion)
    }

    func modalToAccountSetting(completion: (() -> Void)? = nil) {
        guard let vc = R.storyboard.accountSettingViewController.instantiateInitialViewController() else {
            return
        }
        present(to: vc, style: .automatic, completion: completion)
    }

    func modalToDictionary(completion: (() -> Void)? = nil) {
        guard let vc = R.storyboard.dictionaryViewController.instantiateInitialViewController() else {
            return
        }
        present(to: vc, style: .automatic, completion: completion)
    }

    func modalToWiFi(completion: (() -> Void)? = nil) {
        let vc = WiFiSelectDeviceViewController()
        present(to: vc, style: .fullScreen, completion: completion)
    }

    func modalToDebug(completion: (() -> Void)? = nil) {
        guard let vc = R.storyboard.debugViewController.instantiateInitialViewController() else {
            return
        }
        present(to: vc, style: .fullScreen, completion: completion)
    }

    // MARK: - SafariView

    func presentToSafariView(urlString: String?, onError: (() -> Void)? = nil) {
        presentSafariView(urlString: urlString, onError: onError)
    }
}
