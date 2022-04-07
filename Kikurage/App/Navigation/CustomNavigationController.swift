//
//  CustomNavigationController.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2022/3/6.
//  Copyright © 2022 shusuke. All rights reserved.
//

import UIKit

class CustomNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
}

// MARK: - UINavigationController Delegate

extension CustomNavigationController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController is NavigationBarHiddenApplicatable {
            (viewController as? NavigationBarHiddenApplicatable)?.setDesignedNavigationBar()
        } else {
            navigationBar.setBackgroundImage(nil, for: .default)
            navigationBar.shadowImage = nil
        }
    }
}

// MARK: - NavigationBar

protocol NavigationBarHiddenApplicatable: UIViewController {
    func setDesignedNavigationBar()
    func undoDesignedNavigationBar()

    var navigationBackgroundImage: UIImage? { get }
    var navigationShadowImage: UIImage { get }
}

extension NavigationBarHiddenApplicatable {
    func setDesignedNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(navigationBackgroundImage, for: .default)
        navigationController?.navigationBar.shadowImage = navigationShadowImage
    }
    func undoDesignedNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
    }

    var navigationBackgroundImage: UIImage? {
        UIImage()
    }
    var navigationShadowImage: UIImage {
        UIImage()
    }
}
