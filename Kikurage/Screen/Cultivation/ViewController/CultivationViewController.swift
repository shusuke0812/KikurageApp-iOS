//
//  CultivationViewController.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2019/03/02.
//  Copyright © 2019 shusuke. All rights reserved.
//

import KAAnalytics
import KSCultivationService
import RxSwift
import UIKit

class CultivationViewController: UIViewController, UIViewControllerNavigatable, CultivationAccessable {
    private var viewModel: CultivationViewModelType!

    private let disposeBag = RxSwift.DisposeBag()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = CultivationViewModel()

        let baseView = CultivationBaseView(delegate: self, state: viewModel.state)
        addBaseView(baseView: baseView)

        setNavigationItem()
        setNotificationCenter()
        adjustNavigationBarBackgroundColor()

        loadCultivations()

        // RX
        rxBaseView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        FirebaseAnalyticsManager.sendScreenViewEvent(.cultivation)
    }

    // MARK: - Action

    private func loadCultivations() {
        viewModel.state.isLoading = true
        viewModel.input.loadCultivations()
    }
}

// MARK: - Initialized

extension CultivationViewController {
    private func setNavigationItem() {
        setNavigationBar(title: R.string.localizable.screen_cultivation_title())
    }
}

// MARK: - Rx

extension CultivationViewController {
    private func rxBaseView() {
        viewModel.output.cultivations.subscribe(
            onNext: { [weak self] cultivations in
                DispatchQueue.main.async {
                    self?.viewModel.state.isLoading = false
                    self?.viewModel.state.cultivations = cultivations
                }
            }
        )
        .disposed(by: disposeBag)

        viewModel.output.error.subscribe(
            onNext: { [weak self] _ in
                DispatchQueue.main.async {
                    // TODO: error.description()を表示させる
                    self?.viewModel.state.isLoading = false
                    self?.viewModel.state.hasError = true
                }
            }
        )
        .disposed(by: disposeBag)
    }
}

// MARK: - NotificationCenter

extension CultivationViewController {
    private func setNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(didPostCultivation), name: .updatedCultivations, object: nil)
    }

    @objc private func didPostCultivation(notification: Notification) {
        loadCultivations()
    }
}

// MARK: - CultivationBaseViewDelegate

extension CultivationViewController: CultivationBaseViewDelegate {
    func cultivationBaseViewDidTapAddButton() {
        modalToPostCultivation()
    }

    func cultivationBaseViewDidSelectCultivation(_ cultivation: KikurageCultivationTuple) {
        pushToCultivationDetail(cultivation: cultivation.data)
    }

    func cultivationBaseViewDidPullToRefresh() {
        loadCultivations()
    }
}
