//
//  NavigationProtocol+Cultivation.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2022/3/6.
//  Copyright © 2022 shusuke. All rights reserved.
//

import UIKit

protocol CultivationAccessable: PushNavigationProtocol, ModalNavigationProtocol {
    func pushToCultivation()
    func pushToCultivationDetail(cultivation: KikurageCultivation)
    func modalToPostCultivation()
}

extension CultivationAccessable {
    // MARK: - Push

    func pushToCultivation() {
        guard let vc = R.storyboard.cultivationViewController.instantiateInitialViewController() else {
            return
        }
        push(to: vc)
    }

    func pushToCultivationDetail(cultivation: KikurageCultivation) {
        guard let vc = R.storyboard.cultivationDetailViewController.instantiateInitialViewController() else {
            return
        }
        vc.cultivation = cultivation
        push(to: vc)
    }

    // MARK: - Modal

    func modalToPostCultivation() {
        guard let vc = R.storyboard.postCultivationViewController.instantiateInitialViewController() else {
            return
        }
        present(to: vc, presentationStyle: .automatic)
    }
}
