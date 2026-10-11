//
//  DictionaryViewController.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2022/3/30.
//  Copyright © 2022 shusuke. All rights reserved.
//

import KAAnalytics
import UIKit

class DictionaryViewController: UIViewController, UIViewControllerNavigatable {
    private let dictionaryTriviaVC = DictionaryTriviaViewController()
    private let dictionaryTwitterVC = DictionaryTwitterViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigation()

        let baseView = DictionaryBaseView(
            triviaViewController: dictionaryTriviaVC,
            twitterViewController: dictionaryTwitterVC
        )
        let _ = addBaseView(baseView: baseView)
    }

    // MARK: - Action

    @objc private func close(_ sender: UIBarButtonItem) {
        presentingViewController?.dismiss(animated: true)
    }
}

// MARK: - Initialized

extension DictionaryViewController {
    private func setNavigation() {
        let closeButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(close(_:)))
        navigationItem.rightBarButtonItems = [closeButtonItem]
        navigationItem.title = ""
    }
}
