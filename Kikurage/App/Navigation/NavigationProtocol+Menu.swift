//
//  NavigationProtocol+Menu.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2022/3/12.
//  Copyright © 2022 shusuke. All rights reserved.
//

import UIKit

protocol MenuAccessable: ModalNavigationProtocol {
    func modalToCalendar(completion: (() -> Void)?)
    func modalToGraph(completion: (() -> Void)?)
    func modalToSetting(completion: (() -> Void)?)
}

extension MenuAccessable {
    func modalToCalendar(completion: (() -> Void)? = nil) {
        guard let vc = R.storyboard.calendarViewController.instantiateInitialViewController() else { return }
        present(to: vc, style: .automatic, completion: completion)
    }
    func modalToGraph(completion: (() -> Void)? = nil) {
        guard let vc = R.storyboard.graphViewController.instantiateInitialViewController() else { return }
        present(to: vc, style: .automatic, completion: completion)
    }
    func modalToSetting(completion: (() -> Void)? = nil) {
        guard let vc = R.storyboard.settingViewController.instantiateInitialViewController() else { return }
        present(to: vc, style: .automatic, completion: completion)
    }
}
