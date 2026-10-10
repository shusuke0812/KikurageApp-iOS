//
//  HomeViewController.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2019/02/26.
//  Copyright © 2019 shusuke. All rights reserved.
//

import KAAnalytics
import KSHomeService
import RxSwift
import UIKit

class HomeViewController: UIViewController, UIViewControllerNavigatable, HomeAccessable {
    private var baseView: HomeBaseView!
    private var viewModel: HomeViewModelType!

    private var sideMenuBarButtonItem: UIBarButtonItem!

    private let disposeBag = RxSwift.DisposeBag()
    private var dateTimer: Timer?

    var kikurageState: KikurageState!
    var kikurageUser: KikurageUser!

    deinit {
        // KLogger.debug("call deinit")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = HomeViewModel(kikurageUser: kikurageUser)
        viewModel.input.listenKikurageState()

        baseView = HomeBaseView(delegate: self, state: viewModel.state)
        addBaseView(baseView: baseView)

        viewModel.state.kikurageName = R.string.localizable.screen_home_kikurage_name(kikurageUser.kikurageName ?? "-")

        setNavigationItem()
        adjustNavigationBarBackgroundColor()
        makeForeBackgroundObserver()

        rxBaseView()
        rxSideMenu()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setDateTimer()
        loadKikurageState()
        viewModel.state.isAnimating = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        dateTimer?.invalidate()
        dateTimer = nil
        viewModel.state.isAnimating = false
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        FirebaseAnalyticsManager.sendScreenViewEvent(.home)
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
                self?.viewModel.state.nowTimeString = self?.viewModel.output.dateNowString ?? "-"
            }
        })
    }

    private func makeForeBackgroundObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
}

// MARK: - Rx

extension HomeViewController {
    private func rxBaseView() {
        viewModel.output.kikurageState.subscribe(
            onNext: { [weak self] kikurageState in
                DispatchQueue.main.async {
                    self?.updateState(kikurageState: kikurageState)
                }
            }
        )
        .disposed(by: disposeBag)

        viewModel.output.error.subscribe(
            onNext: { [weak self] _ in
                DispatchQueue.main.async {
                    self?.onFailedLoadingKikurageState(errorMessage: "error") // TODO: error.description()
                }
            }
        )
        .disposed(by: disposeBag)
    }

    private func rxSideMenu() {
        sideMenuBarButtonItem.rx.tap.asDriver()
            .drive(
                onNext: { [weak self] in
                    self?.modalToSideMenu()
                }
            )
            .disposed(by: disposeBag)
    }
}

// MARK: - State Update

extension HomeViewController {
    private func updateState(kikurageState: KikurageState) {
        viewModel.state.statusMessage = kikurageState.message ?? "-"
        viewModel.state.temperature = kikurageState.temperature ?? 0
        viewModel.state.humidity = kikurageState.humidity ?? 0
        viewModel.state.advice = kikurageState.advice ?? "-"
        if let type = kikurageState.type {
            viewModel.state.stateImages = type.getStateImages()
            viewModel.state.hasStateError = false
        } else {
            viewModel.state.hasStateError = true
        }
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
        viewModel.state.isAnimating = true
    }

    @objc private func didEnterBackground() {
        dateTimer?.invalidate()
        dateTimer = nil
        viewModel.state.isAnimating = false
    }
}

// MARK: - Error

extension HomeViewController {
    private func onFailedLoadingKikurageState(errorMessage: String) {
        UIAlertController.showAlert(style: .alert, viewController: self, title: errorMessage, message: nil, okButtonTitle: R.string.localizable.common_alert_ok_btn_ok(), cancelButtonTitle: nil) { [weak self] in
            self?.viewModel.state.hasStateError = true
        }
    }
}

// MARK: - HomeBaseViewDelegate

extension HomeViewController: HomeBaseViewDelegate {
    func homeBaseViewDidTapCultivationButton() {
        pushToCultivation()
    }

    func homeBaseViewDidTapRecipeButton() {
        pushToRecipe()
    }

    func homeBaseViewDidTapCommunicationButton() {
        pushToCommunication()
    }
}
