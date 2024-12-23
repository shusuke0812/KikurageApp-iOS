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
    private var baseView: DictionaryBaseView = .init()

    private lazy var dictionaryTriviaVC: DictionaryTriviaViewController? = {
        let vc = DictionaryTriviaViewController()
        return vc
    }()

    private lazy var dictonaryTwitterVC: DictionaryTwitterViewController? = {
        let vc = DictionaryTwitterViewController()
        return vc
    }()

    private var currentViewController: UIViewController?

    override func loadView() {
        view = baseView
    }

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
    private func setContainerViewController(_ vc: UIViewController?) {
        if let vc = vc {
            currentViewController = vc
            addChild(vc)
            baseView.addContainerView(vc.view)
            vc.didMove(toParent: self)
        }
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
            FirebaseAnalyticsHelper.sendScreenViewEvent(.dictionaryTrivia)
        } else if index == 1 {
            setContainerViewController(dictonaryTwitterVC)
            FirebaseAnalyticsHelper.sendScreenViewEvent(.dictionaryTwitter)
        }
    }
}

// MARK: - DictionaryBaseViewDelegate

extension DictionaryViewController: DictionaryBaseViewDelegate {
    func dictionaryBaseView(_ dictionaryBaseView: DictionaryBaseView, didChangeSegmentedAt index: Int) {
        showContainerView(index: index)
    }
}
