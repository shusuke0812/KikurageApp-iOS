//
//  NavigationProtocol+Home.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2024/10/29.
//  Copyright © 2024 shusuke. All rights reserved.
//

import Foundation

protocol HomeAccessable: PushNavigationProtocol, ModalNavigationProtocol {
    func modalToSideMenu()
    func pushToCultivation()
    func pushToRecipe()
    func pushToCommunication()
}

extension HomeAccessable {
    // MARK: - Push

    func pushToCultivation() {
        let vc = CultivationViewController()
        push(to: vc)
    }

    func pushToRecipe() {
        let vc = RecipeViewController()
        push(to: vc)
    }

    func pushToCommunication() {
        let vc = CommunicationViewController()
        push(to: vc)
    }

    // MARK: - Modal

    func modalToSideMenu() {
        let vc = SideMenuViewController()
        present(to: vc, transitionStyle: .crossDissolve, presentationStyle: .overCurrentContext)
    }
}
