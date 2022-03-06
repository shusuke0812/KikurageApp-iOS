//
//  NavigationProtocol.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2022/3/6.
//  Copyright © 2022 shusuke. All rights reserved.
//

import UIKit

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

    func present(to vc: UIViewController, style: UIModalPresentationStyle)
}

extension ModalNavigationProtocol {
    func present(to vc: UIViewController, style: UIModalPresentationStyle  = .fullScreen) {
        let nc = CustomNavigationController(rootViewController: vc)
        nc.modalPresentationStyle = style
        viewController.present(nc, animated: true, completion: nil)
    }
}

extension ModalNavigationProtocol where Self: UIViewController {
    var viewController: UIViewController {
        self
    }
}
