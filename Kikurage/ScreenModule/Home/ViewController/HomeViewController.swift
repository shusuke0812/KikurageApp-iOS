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

    @IBOutlet private weak var sideMenuBarButtonItem: UIBarButtonItem!

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

        // Rx
        rxTransition()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setDateTimer()
        loadKikurageState()
        startKikurageStateViewAnimation()
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
    }
    private func setDateTimer() {
        dateTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateUI), userInfo: nil, repeats: true)
    }
    @objc private func updateUI() {
        baseView.updateTimeLabel()
    }
    private func setDelegateDataSource() {
        viewModel.delegate = self
    }
    private func makeForeBackgroundObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    private func startKikurageStateViewAnimation() {
        baseView.setKikurageStateUI(kikurageState: viewModel.kikurageState)
        baseView.kikurageStatusViewAnimation(true)
    }
}

// MARK: - Rx

extension HomeViewController {
    private func rxTransition() {
        baseView.footerButtonView.cultivationButton.rx.tap.subscribe(
            onNext: { [weak self] in
                guard let vc = R.storyboard.cultivationViewController.instantiateInitialViewController() else { return }
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        )
        .disposed(by: disposeBag)

        baseView.footerButtonView.recipeButton.rx.tap.subscribe(
            onNext: { [weak self] in
                guard let vc = R.storyboard.recipeViewController.instantiateInitialViewController() else { return }
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        )
        .disposed(by: disposeBag)

        baseView.footerButtonView.communicationButton.rx.tap.subscribe(
            onNext: { [weak self] in
                guard let vc = R.storyboard.communicationViewController.instantiateInitialViewController() else { return }
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        )
        .disposed(by: disposeBag)

        sideMenuBarButtonItem.rx.tap.subscribe(
            onNext: { [weak self] in
                self?.performSegue(withIdentifier: R.segue.homeViewController.sideMenu.identifier, sender: nil)
            }
        )
        .disposed(by: disposeBag)
    }
}

// MARK: - API

extension HomeViewController {
    private func loadKikurageState() {
        viewModel.loadKikurageState()
    }
}

// MARK: - Observer

extension HomeViewController {
    @objc private func willEnterForeground() {
        setDateTimer()
        startKikurageStateViewAnimation()
    }
    @objc private func didEnterBackground() {
        if let dateTimer = self.dateTimer {
            dateTimer.invalidate()
        }
        baseView.kikurageStatusViewAnimation(false)
    }
}

// MARK: - HomeViewModel Delegate

extension HomeViewController: HomeViewModelDelgate {
    func homeViewModelDidSuccessGetKikurageState(_ homeViewModel: HomeViewModel) {
        DispatchQueue.main.async {
            self.baseView.setKikurageStateUI(kikurageState: homeViewModel.kikurageState)
        }
    }
    func homeViewModelDidFailedGetKikurageState(_ homeViewModel: HomeViewModel, with errorMessage: String) {
        DispatchQueue.main.async {
            UIAlertController.showAlert(style: .alert, viewController: self, title: errorMessage, message: nil, okButtonTitle: R.string.localizable.common_alert_ok_btn_ok(), cancelButtonTitle: nil) { [weak self] in
                self?.baseView.setKikurageStateUI(kikurageState: homeViewModel.kikurageState)
            }
        }
    }
    func homeViewModelDidChangedKikurageState(_ homeViewModel: HomeViewModel) {
        baseView.setKikurageStateUI(kikurageState: homeViewModel.kikurageState)
    }
}
