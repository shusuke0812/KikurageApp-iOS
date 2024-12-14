//
//  NavigationProtocol+Cultivation.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2022/3/6.
//  Copyright © 2022 shusuke. All rights reserved.
//

import UIKit

protocol CultivationAccessable: PushNavigationProtocol, ModalNavigationProtocol {
    func pushToCultivationDetail(cultivation: KikurageCultivation)
    func modalToPostCultivation()
}

extension CultivationAccessable {
    // MARK: - Push

    func pushToCultivationDetail(cultivation: KikurageCultivation) {
        let vc = CultivationDetailViewController()
        vc.cultivation = cultivation
        push(to: vc)
    }

    // MARK: - Modal

    func modalToPostCultivation() {
        let vc = PostCultivationViewController()
        present(to: vc, presentationStyle: .automatic)
    }
}
