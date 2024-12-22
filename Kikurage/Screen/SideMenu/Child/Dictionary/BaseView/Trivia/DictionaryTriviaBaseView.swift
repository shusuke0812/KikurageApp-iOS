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
    func dictonaryTriviaBaseView(_ dictionaryTriviaBaseView: DictionaryTriviaBaseView, didFinish navigation: WKNavigation!)
}

class DictionaryTriviaBaseView: UIView {
    private var webView: WKWebView!
    private var loadingIndicatorView: UIActivityIndicatorView!

    weak var delegate: DictionaryTriviaBaseViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupComponent()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupComponent() {
        webView = WKWebView()
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false

        loadingIndicatorView = UIActivityIndicatorView()
        loadingIndicatorView.isHidden = true
        loadingIndicatorView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(webView)
        addSubview(loadingIndicatorView)

        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: topAnchor),
            webView.leadingAnchor.constraint(equalTo: leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: bottomAnchor),

            loadingIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: - WKNavigationDelegate

extension DictionaryTriviaBaseView: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        delegate?.dictonaryTriviaBaseView(self, didFinish: navigation)
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
