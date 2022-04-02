//
//  DictionaryBaseView.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2022/3/30.
//  Copyright © 2022 shusuke. All rights reserved.
//

import UIKit
import WebKit

class DictionaryBaseView: UIView {
    @IBOutlet private weak var navigationItem: UINavigationItem!
    @IBOutlet private weak var segmentedControl: UISegmentedControl!
    @IBOutlet private weak var webView: WKWebView!

    override func awakeFromNib() {
        super.awakeFromNib()
        initUI()
    }

    // MARK: - Action
    @IBAction private func changeViews(_ sender: Any) {
    }
}

// MARK: - Initialized

extension DictionaryBaseView {
    private func initUI() {
        segmentedControl.setTitle(R.string.localizable.side_menu_dictionary_segment_title_trivia(), forSegmentAt: 0)
        segmentedControl.setTitle(R.string.localizable.side_menu_dictionary_segment_title_twitter(), forSegmentAt: 1)
        segmentedControl.selectedSegmentIndex = .zero

        if let url = URL(string: "https://midorikoubou.jp/blog/2018/08/08/kikuragecultivation-faq") {
            webView.load(URLRequest(url: url))
        }
    }
}
