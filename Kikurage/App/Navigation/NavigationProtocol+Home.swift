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
        guard let vc = R.storyboard.cultivationViewController.instantiateInitialViewController() else {
            return
        }
        push(to: vc)
    }

    func pushToRecipe() {
        guard let vc = R.storyboard.recipeViewController.instantiateInitialViewController() else {
            return
        }
        push(to: vc)
    }

    func pushToCommunication() {
        guard let vc = R.storyboard.communicationViewController.instantiateInitialViewController() else {
            return
        }
        push(to: vc)
    }

    // MARK: - Modal

    func modalToSideMenu() {
        guard let vc = R.storyboard.sideMenuViewController.instantiateInitialViewController() else {
            return
        }
        present(to: vc, transitionStyle: .crossDissolve, presentationStyle: .overCurrentContext)
    }
}
