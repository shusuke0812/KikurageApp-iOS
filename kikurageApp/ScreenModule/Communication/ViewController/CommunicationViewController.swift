//
//  hakaseViewController.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2019/03/02.
//  Copyright © 2019 shusuke. All rights reserved.
//

import UIKit
import PKHUD

class CommunicationViewController: UIViewController, UIViewControllerNavigatable {
    private var baaseView: CommunicationBaseView { self.view as! CommunicationBaseView } // swiftlint:disable:this force_cast
    private var viewModel: CommunicationViewModel!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationItem()
        setDelegateDataSource()
        adjustNavigationBarBackgroundColor()

        viewModel = CommunicationViewModel(firebaseRemoteCofigRepository: FirebaseRemoteConfigRepository())
        viewModel.delegate = self
        loadFacebookGroupUrl()
    }
}
// MARK: - Initialized Method
extension CommunicationViewController {
    private func setNavigationItem() {
        setNavigationBar(title: R.string.localizable.screen_communication_title())
    }
    private func setDelegateDataSource() {
        baaseView.delegate = self
    }
    private func loadFacebookGroupUrl() {
        HUD.show(.progress)
        viewModel.loadFacebookGroupUrl()
    }
}
// MARK: - CommunicationBaseView Delegate
extension CommunicationViewController: CommunicationBaseViewDelegate {
    func didTapFacebookButton() {
        transitionSafariViewController(urlString: viewModel.faceboolGroupUrl)
    }
}
// MARK: - CommunicationViewMdeol Delegate
extension CommunicationViewController: CommunicationViewModelDelegate {
    func didSuccessGetFacebookGroupUrl() {
        HUD.hide()
    }
    func didFailedGetFacebookGroupUrl() {
        HUD.hide()
    }
}
