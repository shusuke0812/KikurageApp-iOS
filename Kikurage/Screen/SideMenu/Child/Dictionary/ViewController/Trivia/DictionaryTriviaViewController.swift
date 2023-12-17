//
//  DictionaryTriviaViewController.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2022/4/2.
//  Copyright © 2022 shusuke. All rights reserved.
//

import UIKit
import WebKit

class DictionaryTriviaViewController: UIViewController {
    private var baseView: DictionaryTriviaBaseView { self.view as! DictionaryTriviaBaseView } // swiftlint:disable:this force_cast

    override func viewDidLoad() {
        super.viewDidLoad()

        baseView.delegate = self

        if let url = URL(string: "https://midorikoubou.jp/blog/2018/08/08/kikuragecultivation-faq") {
            baseView.startLoadingIindicator()
            baseView.loadWebSite(url: url)
        }
    }
}

// MARK: - DictionaryTriviaBaseViewDelegate

extension DictionaryTriviaViewController: DictionaryTriviaBaseViewDelegate {
    func dictonaryTriviaBaseView(_ dictionaryTriviaBaseView: DictionaryTriviaBaseView, didFinish navigation: WKNavigation!) {
        baseView.stopLoadingIndicator()
    }
}
