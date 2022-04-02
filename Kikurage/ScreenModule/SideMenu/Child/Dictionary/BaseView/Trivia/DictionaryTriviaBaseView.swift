//
//  DictionaryTriviaBaseView.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2022/4/2.
//  Copyright © 2022 shusuke. All rights reserved.
//

import UIKit
import WebKit

protocol DictionaryTriviaBaseViewDelegate: AnyObject {
    func didFinishLoadWebSite(_ dictionaryTriviaBaseView: DictionaryTriviaBaseView)
}

class DictionaryTriviaBaseView: UIView {
    @IBOutlet private weak var webView: WKWebView!
    @IBOutlet private weak var loadingIndicatorView: UIActivityIndicatorView!

    weak var delegate: DictionaryTriviaBaseViewDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        initUI()
    }
}

// MARK: - Initialized

extension DictionaryTriviaBaseView {
    private func initUI() {
        loadingIndicatorView.isHidden = true
        webView.navigationDelegate = self
    }
}

// MARK: - WKNavigationDelegate

extension DictionaryTriviaBaseView: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        delegate?.didFinishLoadWebSite(self)
    }
}

// MARK: - Config

extension DictionaryTriviaBaseView {
    func loadWebSite(url: URL) {
        webView.load(URLRequest(url: url))
    }
    func startLoadingIindicator() {
        loadingIndicatorView.startAnimating()
        loadingIndicatorView.isHidden = false
    }
    func stopLoadingIndicator() {
        loadingIndicatorView.stopAnimating()
        loadingIndicatorView.isHidden = true
    }
}
