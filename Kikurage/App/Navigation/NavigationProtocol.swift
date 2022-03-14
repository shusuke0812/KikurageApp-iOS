//
//  NavigationProtocol.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2022/3/6.
//  Copyright © 2022 shusuke. All rights reserved.
//

import UIKit
import SafariServices

// MARK: - Push

protocol PushNavigationProtocol {
    var navigationController: UINavigationController? { get }

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

// MARK: - Modal

protocol ModalNavigationProtocol {
    var viewController: UIViewController { get }

    func present(to vc: UIViewController, style: UIModalPresentationStyle, completion: (() -> Void)?)
}

extension ModalNavigationProtocol {
    func present(to vc: UIViewController, style: UIModalPresentationStyle  = .fullScreen, completion: (() -> Void)? = nil) {
        let nc = CustomNavigationController(rootViewController: vc)
        nc.modalPresentationStyle = style
        viewController.present(nc, animated: true, completion: completion)
    }
}

extension ModalNavigationProtocol where Self: UIViewController {
    var viewController: UIViewController {
        self
    }
}

// MARK: - SafariView

protocol SafariViewNavigationProtocol {
    func presentSafariView(from vc: UIViewController, urlString: String?, onError:(() -> Void)?)
}

extension SafariViewNavigationProtocol {
    func presentSafariView(from vc: UIViewController, urlString: String?, onError:(() -> Void)?) {
        let url: URL?
        guard let urlString = urlString else { onError?(); return }
        // 不正なURLであるかを判定する（不正なものはhttpsプレフィックスをつけてブラウザでエラーハンドリングする）
        if urlString.hasPrefix("http://") || urlString.hasPrefix("https") {
            url = URL(string: urlString)
        } else {
            url = URL(string: "https://" + urlString)
        }

        if let url = url {
            let safariVC = SFSafariViewController(url: url)
            vc.present(safariVC, animated: true, completion: nil)
        } else {
            onError?()
        }
    }
}
