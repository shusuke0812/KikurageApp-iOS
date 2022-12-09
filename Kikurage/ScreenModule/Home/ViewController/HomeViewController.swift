//
//  ViewController.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2019/02/26.
//  Copyright © 2019 shusuke. All rights reserved.
//

import UIKit
import RxSwift
import KikurageFeature

class HomeViewController: UIViewController, UIViewControllerNavigatable, CultivationAccessable, RecipeAccessable, CommunicationAccessable {
    private var baseView: HomeBaseView { self.view as! HomeBaseView } // swiftlint:disable:this force_cast
    private var viewModel: HomeViewModelType!

    @IBOutlet private weak var sideMenuBarButtonItem: UIBarButtonItem!

    private let disposeBag = RxSwift.DisposeBag()
    private var dateTimer: Timer?

    var kikurageState: KikurageState!
    var kikurageUser: KikurageUser!

    deinit {
        KLogger.debug("call deinit")
    }

    // MARK: - Lifecycle

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
                self?.performSegue(withIdentifier: R.segue.homeViewController.sideMenu.identifier, sender: nil)
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
