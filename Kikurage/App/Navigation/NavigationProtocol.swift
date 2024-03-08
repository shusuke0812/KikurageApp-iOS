//
//  NavigationProtocol.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2022/3/6.
//  Copyright © 2022 shusuke. All rights reserved.
//

import SafariServices
import UIKit

// MARK: - Push

protocol PushNavigationProtocol where Self: UIViewController {
    func push(to vc: UIViewController)
    func setViewControllers(to vcs: [UIViewController])
}

extension PushNavigationProtocol {
    func push(to vc: UIViewController) {
        navigationController?.pushViewController(vc, animated: true)
    }

    func setViewControllers(to vcs: [UIViewController]) {
        navigationController?.setViewControllers(vcs, animated: true)
    }
}

// MARK: - Pop

protocol PopNavigationProtocol where Self: UIViewController {
    func pop()
    func pop(to vc: UIViewController)
    func popToRootViewController()
}

// MARK: - Modal

protocol ModalNavigationProtocol where Self: UIViewController {
    func present(to vc: UIViewController, style: UIModalPresentationStyle, completion: (() -> Void)?)
}

extension ModalNavigationProtocol {
    func present(to vc: UIViewController, style: UIModalPresentationStyle = .fullScreen, completion: (() -> Void)? = nil) {
        let nc = CustomNavigationController(rootViewController: vc)
        nc.modalPresentationStyle = style
        present(nc, animated: true, completion: completion)
    }
}

// MARK: - SafariView

protocol SafariViewNavigationProtocol where Self: UIViewController {
    func presentSafariView(urlString: String?, onError: (() -> Void)?)
}

extension SafariViewNavigationProtocol {
    func presentSafariView(urlString: String?, onError: (() -> Void)?) {
        let url: URL?
        guard let urlString = urlString else {
            onError?(); return
        }
        // 不正なURLであるかを判定する（不正なものはhttpsプレフィックスをつけてブラウザでエラーハンドリングする）
        if urlString.hasPrefix("http://") || urlString.hasPrefix("https") {
            url = URL(string: urlString)
        } else {
            url = URL(string: "https://" + urlString)
        }

        if let url = url {
            let safariVC = SFSafariViewController(url: url)
            present(safariVC, animated: true, completion: nil)
        } else {
            onError?()
        }
    }
}

// MARK: - Dismiss

protocol DismissNavigationProtocol where Self: UIViewController {
    func dismiss(animated: Bool)
}

extension DismissNavigationProtocol {
    func dismiss(animated: Bool) {
        dismiss(animated: animated)
    }
}
