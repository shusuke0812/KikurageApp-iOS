//
//  ViewController.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2019/02/26.
//  Copyright © 2019 shusuke. All rights reserved.
//

import UIKit
import RxSwift

class HomeViewController: UIViewController, UIViewControllerNavigatable {
    private var baseView: HomeBaseView { self.view as! HomeBaseView } // swiftlint:disable:this force_cast
    private var viewModel: HomeViewModel!

    private let disposeBag = RxSwift.DisposeBag()
    private var dateTimer: Timer?

    var kikurageState: KikurageState!
    var kikurageUser: KikurageUser!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        // Util
        viewModel = HomeViewModel(kikurageStateRepository: KikurageStateRepository(), kikurageStateListenerRepository: KikurageStateListenerRepository())
        viewModel.config(kikurageUser: kikurageUser, kikurageState: kikurageState)
        setDelegateDataSource()

        // UI
        baseView.setKikurageNameUI(kikurageUser: viewModel.kikurageUser)
        setNavigationItem()
        adjustNavigationBarBackgroundColor()
        
        // Other
        makeForeBackgroundObserver()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setDateTimer()
        loadKikurageState()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // メモリ節約のため、他ViewControllerに移動する前にタイマーを停止する
        if let dateTimer = self.dateTimer {
            dateTimer.invalidate()
        }
        baseView.kikurageStatusViewAnimation(false)
    }
}

// MARK: - Initialized

extension HomeViewController {
    private func setNavigationItem() {
        setNavigationBackButton(buttonTitle: R.string.localizable.common_navigation_back_btn_title(), buttonColor: .black)
        setNavigationBar(title: R.string.localizable.screen_home_title())
    }
    private func setDateTimer() {
        dateTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateUI), userInfo: nil, repeats: true)
    }
    @objc private func updateUI() {
        baseView.updateTimeLabel()
    }
    private func setDelegateDataSource() {
        viewModel.delegate = self
        baseView.delegate = self
    }
    private func makeForeBackgroundObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
}

// MARK: - Observer

extension HomeViewController {
    @objc private func willEnterForeground() {
        setDateTimer()
        baseView.setKikurageStateUI(kikurageState: viewModel.kikurageState)
        baseView.kikurageStatusViewAnimation(true)
    }
    @objc private func didEnterBackground() {
        if let dateTimer = self.dateTimer {
            dateTimer.invalidate()
        }
        baseView.kikurageStatusViewAnimation(false)
    }
}

// MARK: - HomeBaseView Delegate

extension HomeViewController: HomeBaseViewDelegate {
    func didTapCultivationButton() {
        guard let vc = R.storyboard.cultivationViewController.instantiateInitialViewController() else { return }
        navigationController?.pushViewController(vc, animated: true)
    }
    func didTapRecipeButton() {
        guard let vc = R.storyboard.recipeViewController.instantiateInitialViewController() else { return }
        navigationController?.pushViewController(vc, animated: true)
    }
    func didTapCommunicationButton() {
        guard let vc = R.storyboard.communicationViewController.instantiateInitialViewController() else { return }
        navigationController?.pushViewController(vc, animated: true)
    }
    func didTapSideMenuButton() {
        performSegue(withIdentifier: R.segue.homeViewController.sideMenu.identifier, sender: nil)
    }
}

// MARK: - HomeViewModel Delegate

extension HomeViewController: HomeViewModelDelgate {
    private func loadKikurageState() {
        viewModel.loadKikurageState()
    }
    func didSuccessGetKikurageState() {
        baseView.setKikurageStateUI(kikurageState: viewModel.kikurageState)
    }
    func didFailedGetKikurageState(errorMessage: String) {
        DispatchQueue.main.async {
            UIAlertController.showAlert(style: .alert, viewController: self, title: errorMessage, message: nil, okButtonTitle: R.string.localizable.common_alert_ok_btn_ok(), cancelButtonTitle: nil, completionOk: nil)
        }
    }
    func didChangedKikurageState() {
        baseView.setKikurageStateUI(kikurageState: viewModel.kikurageState)
    }
}
