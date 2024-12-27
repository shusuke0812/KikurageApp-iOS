//
//  HomeViewController.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2019/02/26.
//  Copyright © 2019 shusuke. All rights reserved.
//

import KikurageFeature
import RxSwift
import UIKit

class HomeViewController: UIViewController, UIViewControllerNavigatable, HomeAccessable {
    private var baseView: HomeBaseView = .init()
    private var viewModel: HomeViewModelType!

    private var sideMenuBarButtonItem: UIBarButtonItem!

    private let disposeBag = RxSwift.DisposeBag()
    private var dateTimer: Timer?

    var kikurageState: KikurageState!
    var kikurageUser: KikurageUser!

    deinit {
        KLogger.debug("call deinit")
    }

    // MARK: - Lifecycle

    override func loadView() {
        view = baseView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Config
        viewModel = HomeViewModel(kikurageUser: kikurageUser, kikurageStateRepository: KikurageStateRepository(), kikurageStateListenerRepository: KikurageStateListenerRepository())
        viewModel.input.listenKikurageState()

        // UI
        baseView.setKikurageNameUI(kikurageUser: kikurageUser)
        setNavigationItem()
        adjustNavigationBarBackgroundColor()

        // Other
        makeForeBackgroundObserver()

        // Rx
        rxTransition()
        rxBaseView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setDateTimer()
        loadKikurageState()
        startKikurageStateViewAnimation()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // For prevented memory over usage, timer is stopped and disposed before screen transition
        dateTimer?.invalidate()
        dateTimer = nil
        baseView.kikurageStatusViewAnimation(false)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        FirebaseAnalyticsHelper.sendScreenViewEvent(.home)
    }
}

// MARK: - Initialized

extension HomeViewController {
    private func setNavigationItem() {
        setNavigationBackButton(buttonTitle: R.string.localizable.common_navigation_back_btn_title(), buttonColor: .black)

        sideMenuBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "line.horizontal.3")
        )
        navigationItem.leftBarButtonItems = [sideMenuBarButtonItem]
    }

    private func setDateTimer() {
        dateTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [weak self] _ in
            DispatchQueue.main.async {
                self?.updateUI()
            }
        })
    }

    @objc private func updateUI() {
        baseView.updateTimeLabel()
    }

    private func makeForeBackgroundObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }

    private func startKikurageStateViewAnimation() {
        baseView.kikurageStatusViewAnimation(true)
    }
}

// MARK: - Rx

extension HomeViewController {
    private func rxBaseView() {
        viewModel.output.kikurageState.subscribe(
            onNext: { [weak self] kikurageState in
                self?.baseView.setKikurageStateUI(kikurageState: kikurageState)
            }
        )
        .disposed(by: disposeBag)

        viewModel.output.error.subscribe(
            onNext: { [weak self] error in
                self?.onFailedLoadingKikurageState(errorMessage: error.description())
            }
        )
        .disposed(by: disposeBag)
    }

    private func rxTransition() {
        baseView.footerButtonView.cultivationButton.rx.tap.asDriver()
            .drive(
                onNext: { [weak self] in
                    self?.pushToCultivation()
                }
            )
            .disposed(by: disposeBag)

        baseView.footerButtonView.recipeButton.rx.tap.asDriver()
            .drive(
                onNext: { [weak self] in
                    self?.pushToRecipe()
                }
            )
            .disposed(by: disposeBag)

        baseView.footerButtonView.communicationButton.rx.tap.asDriver()
            .drive(
                onNext: { [weak self] in
                    self?.pushToCommunication()
                }
            )
            .disposed(by: disposeBag)

        sideMenuBarButtonItem.rx.tap.asDriver()
            .drive(
                onNext: { [weak self] in
                    self?.modalToSideMenu()
                }
            )
            .disposed(by: disposeBag)
    }
}

// MARK: - API

extension HomeViewController {
    private func loadKikurageState() {
        viewModel.input.loadKikurageState()
    }
}

// MARK: - Observer

extension HomeViewController {
    @objc private func willEnterForeground() {
        setDateTimer()
        startKikurageStateViewAnimation()
    }

    @objc private func didEnterBackground() {
        dateTimer?.invalidate()
        dateTimer = nil
        baseView.kikurageStatusViewAnimation(false)
    }
}

// MARK: - Error

extension HomeViewController {
    private func onFailedLoadingKikurageState(errorMessage: String) {
        DispatchQueue.main.async {
            UIAlertController.showAlert(style: .alert, viewController: self, title: errorMessage, message: nil, okButtonTitle: R.string.localizable.common_alert_ok_btn_ok(), cancelButtonTitle: nil) { [weak self] in
                self?.baseView.setKikurageStateUI(kikurageState: nil)
            }
        }
    }
}
