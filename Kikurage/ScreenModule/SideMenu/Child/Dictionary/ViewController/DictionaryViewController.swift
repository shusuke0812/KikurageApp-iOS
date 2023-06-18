//
//  DictionaryViewController.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2022/3/30.
//  Copyright © 2022 shusuke. All rights reserved.
//

// Doc: https://developer.apple.com/documentation/uikit/view_controllers/creating_a_custom_container_view_controller

import UIKit

class DictionaryViewController: UIViewController {
    private var baseView: DictionaryBaseView { view as! DictionaryBaseView } // swiftlint:disable:this force_cast

    private lazy var dictionaryTriviaVC: DictionaryTriviaViewController = {
        let vc = R.storyboard.dictionaryTriviaViewController.instantiateInitialViewController()! // swiftlint:disable:this force_cast
        return vc
    }()

    private lazy var dictonaryTwitterVC: DictionaryTwitterViewController = {
        let vc = R.storyboard.dictionaryTwitterViewController.instantiateInitialViewController()! // swiftlint:disable:this force_cast
        return vc
    }()

    private var currentViewController: UIViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigation()
        baseView.delegate = self

        setContainerViewController(dictionaryTriviaVC)
    }

    // MARK: - Action

    @objc private func close(_ sender: UIBarButtonItem) {
        presentingViewController?.dismiss(animated: true)
    }
}

// MARK: - Initialized

extension DictionaryViewController {
    private func setContainerViewController(_ vc: UIViewController) {
        currentViewController = vc
        addChild(vc)
        baseView.addContainerView(vc.view)
        vc.didMove(toParent: self)
    }

    private func setNavigation() {
        let closeButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(close(_:)))
        navigationItem.rightBarButtonItems = [closeButtonItem]
        navigationItem.title = ""
    }

    private func removeContainerViewController() {
        guard let vc = currentViewController else {
            return
        }
        vc.willMove(toParent: nil)
        vc.view.removeFromSuperview()
        vc.removeFromParent()
    }

    private func showContainerView(index: Int) {
        removeContainerViewController()
        if index == 0 {
            setContainerViewController(dictionaryTriviaVC)
        } else if index == 1 {
            setContainerViewController(dictonaryTwitterVC)
        }
    }
}

// MARK: - DictionaryBaseViewDelegate

extension DictionaryViewController: DictionaryBaseViewDelegate {
    func dictionaryBaseView(_ dictionaryBaseView: DictionaryBaseView, didChangeSegmentedAt index: Int) {
        showContainerView(index: index)
    }
}
