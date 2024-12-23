//
//  CultivationViewController.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2019/03/02.
//  Copyright © 2019 shusuke. All rights reserved.
//

import KikurageUI
import PKHUD
import RxSwift
import SwiftUI
import UIKit

class CultivationViewController: UIViewController, UIViewControllerNavigatable, CultivationAccessable {
    private var baseView: CultivationBaseView = .init()
    private var emptyHostingVC: UIHostingController<EmptyView>!
    private var viewModel: CultivationViewModelType!

    private let disposeBag = RxSwift.DisposeBag()

    // MARK: - Lifecycle

    override func loadView() {
        view = baseView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = CultivationViewModel(cultivationRepository: CultivationRepository())

        setDelegateDataSource()
        setNavigationItem()
        setNotificationCenter()
        setRefreshControl()

        adjustNavigationBarBackgroundColor()

        if let kikurageUserID = LoginHelper.shared.kikurageUserID {
            HUD.show(.progress)
            viewModel.input.loadCultivations(kikurageUserID: kikurageUserID)
        }

        // RX
        rxBaseView()
        rxTransition()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        FirebaseAnalyticsHelper.sendScreenViewEvent(.cultivation)
    }

    // MARK: - Action

    private func refresh() {
        if let kikurageUserID = LoginHelper.shared.kikurageUserID {
            viewModel.input.loadCultivations(kikurageUserID: kikurageUserID)
        }
    }
}

// MARK: - Initialized

extension CultivationViewController {
    private func setNavigationItem() {
        setNavigationBar(title: R.string.localizable.screen_cultivation_title())
    }

    private func setRefreshControl() {
        let refresh = UIRefreshControl()
        refresh.addAction(.init { [weak self] _ in
            self?.refresh()
        }, for: .valueChanged)
        baseView.setRefreshControlInCollectionView(refresh)
    }

    private func setDelegateDataSource() {
        baseView.collectionView.delegate = self
    }

    private func displayEmptyView(cultivations: [KikurageCultivationTuple]) {
        if cultivations.isEmpty {
            emptyHostingVC = addEmptyView(type: .notFoundCultivation)
        } else {
            removeEmptyView(hostingVC: emptyHostingVC)
        }
    }
}

// MARK: - Rx

extension CultivationViewController {
    private func rxBaseView() {
        viewModel.output.cultivations.bind(to: baseView.collectionView.rx.items) { collectionView, row, element in
            let indexPath = NSIndexPath(row: row, section: 0) as IndexPath
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KUICultivationCollectionViewCell.identifier, for: indexPath) as! KUICultivationCollectionViewCell // swiftlint:disable:this force_cast
            cell.setImage(imageStoragePath: element.data.imageStoragePaths.first)
            cell.setViewDate(dateString: element.data.viewDate)
            return cell
        }
        .disposed(by: disposeBag)

        viewModel.output.cultivations.subscribe(
            onNext: { [weak self] cultivations in
                DispatchQueue.main.async {
                    HUD.hide()
                    self?.baseView.collectionView.refreshControl?.endRefreshing()
                    self?.baseView.collectionView.reloadData()
                    self?.displayEmptyView(cultivations: cultivations)
                }
            }
        )
        .disposed(by: disposeBag)

        viewModel.output.error.subscribe(
            onNext: { [weak self] error in
                guard let `self` = self else {
                    return
                }
                DispatchQueue.main.async {
                    HUD.hide()
                    self.baseView.collectionView.refreshControl?.endRefreshing()
                    UIAlertController.showAlert(style: .alert, viewController: self, title: error.description(), message: nil, okButtonTitle: R.string.localizable.common_alert_ok_btn_ok(), cancelButtonTitle: nil, completionOk: nil)
                }
            }
        )
        .disposed(by: disposeBag)

        baseView.collectionView.rx.itemSelected
            .bind(to: viewModel.input.itemSelected)
            .disposed(by: disposeBag)
    }

    private func rxTransition() {
        baseView.postPageButton.rx.tap.asDriver()
            .drive(
                onNext: { [weak self] in
                    self?.modalToPostCultivation()
                }
            )
            .disposed(by: disposeBag)

        viewModel.output.cultivation.subscribe(
            onNext: { [weak self] cultivationTuple in
                self?.pushToCultivationDetail(cultivation: cultivationTuple.data)
            }
        )
        .disposed(by: disposeBag)
    }
}

// MARK: - UICollectionView Delegate FlowLayout

extension CultivationViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let horizontalSpace: CGFloat = .cellSpacing * 2
        let cellWidth: CGFloat = baseView.bounds.width / 2 - horizontalSpace
        let cellHeight: CGFloat = cellWidth
        return CGSize(width: cellWidth, height: cellHeight)
    }
}

// MARK: - NotificationCenter

extension CultivationViewController {
    private func setNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(didPostCultivation), name: .updatedCultivations, object: nil)
    }

    @objc private func didPostCultivation(notification: Notification) {
        if let kikurageUserID = LoginHelper.shared.kikurageUserID {
            HUD.show(.progress)
            viewModel.input.loadCultivations(kikurageUserID: kikurageUserID)
        }
    }
}
