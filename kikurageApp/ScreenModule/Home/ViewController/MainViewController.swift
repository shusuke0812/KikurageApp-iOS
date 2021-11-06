//
//  ViewController.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2019/02/26.
//  Copyright © 2019 shusuke. All rights reserved.
//

import UIKit
import MessageUI
import RxSwift

class MainViewController: UIViewController, UIViewControllerNavigatable {
    private var baseView: MainBaseView { self.view as! MainBaseView } // swiftlint:disable:this force_cast
    private var viewModel: MainViewModel!

    private let disposeBag = RxSwift.DisposeBag()
    private var timer: Timer?

    var kikurageState: KikurageState!
    var kikurageUser: KikurageUser!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        // Util
        viewModel = MainViewModel(kikurageStateRepository: KikurageStateRepository(), kikurageStateListenerRepository: KikurageStateListenerRepository(), kikurageUser: kikurageUser, kikurageState: kikurageState)
        setDelegateDataSource()

        // UI
        baseView.setKikurageNameUI(kikurageUser: viewModel.kikurageUser)
        setNavigationItem()
        adjustNavigationBarBackgroundColor()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setTimer()
        loadKikurageState()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // メモリ節約のため、他ViewControllerに移動する前にタイマーを停止する
        if let timer = self.timer {
            timer.invalidate()
        }
        baseView.kikurageStatusView.stopAnimating()
    }
}

// MARK: - Initialized

extension MainViewController {
    private func setNavigationItem() {
        setNavigationBackButton(buttonTitle: "もどる", buttonColor: .black)
    }
    private func setTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateUI), userInfo: nil, repeats: true)
    }
    @objc private func updateUI() {
        baseView.updateTimeLabel()
    }
    private func setDelegateDataSource() {
        viewModel.delegate = self
        baseView.delegate = self
    }
}

// MARK: - MainBaseView Delegate

extension MainViewController: MainBaseViewDelegate {
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
        performSegue(withIdentifier: R.segue.mainViewController.sideMenu.identifier, sender: nil)
    }
}

// MARK: - MainViewModel Delegate

extension MainViewController: MainViewModelDelgate {
    private func loadKikurageState() {
        viewModel.loadKikurageState()
    }
    func didSuccessGetKikurageState() {
        baseView.setKikurageStateUI(kikurageState: viewModel.kikurageState)
    }
    func didFailedGetKikurageState(errorMessage: String) {
        DispatchQueue.main.async {
            UIAlertController.showAlert(style: .alert, viewController: self, title: errorMessage, message: nil, okButtonTitle: "OK", cancelButtonTitle: nil, completionOk: nil)
        }
    }
    func didChangedKikurageState() {
        baseView.setKikurageStateUI(kikurageState: viewModel.kikurageState)
    }
}
