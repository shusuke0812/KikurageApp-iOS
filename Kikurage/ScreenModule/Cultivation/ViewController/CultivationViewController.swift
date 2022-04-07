//
//  saibaiViewController.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2019/03/02.
//  Copyright © 2019 shusuke. All rights reserved.
//

import UIKit
import PKHUD
import RxSwift

class CultivationViewController: UIViewController, UIViewControllerNavigatable, CultivationAccessable {
    private var baseView: CultivationBaseView { self.view as! CultivationBaseView } // swiftlint:disable:this force_cast
    private var viewModel: CultivationViewModel!

    private let disposeBag = RxSwift.DisposeBag()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = CultivationViewModel(cultivationRepository: CultivationRepository())

        setDelegateDataSource()
        setNavigationItem()
        setNotificationCenter()
        setRefreshControl()

        adjustNavigationBarBackgroundColor()

        if let kikurageUserId = LoginHelper.shared.kikurageUserId {
            HUD.show(.progress)
            viewModel.loadCultivations(kikurageUserId: kikurageUserId)
        }

        // RX
        rxBaseView()
        rxTransition()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    // MARK: - Action

    @objc private func refresh(_ sender: UIRefreshControl) {
        if let kikurageUserId = LoginHelper.shared.kikurageUserId {
            viewModel.loadCultivations(kikurageUserId: kikurageUserId)
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
        refresh.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        baseView.setRefreshControlInCollectionView(refresh)
    }
    private func setDelegateDataSource() {
        baseView.collectionView.delegate = self
    }
}

// MARK: - Rx

extension CultivationViewController {
    private func rxBaseView() {
        viewModel.output.cultivations.bind(to: baseView.collectionView.rx.items) { collectionView, row, element in
            let indexPath = NSIndexPath(row: row, section: 0) as IndexPath
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.cultivationCollectionViewCell, for: indexPath)! // swiftlint:disable:this force_unwrapping
            cell.setUI(cultivation: element.cultivation)
            return cell
        }
        .disposed(by: disposeBag)

        viewModel.output.cultivations.subscribe(
            onNext: { [weak self] cultivations in
                DispatchQueue.main.async {
                    HUD.hide()
                    self?.baseView.collectionView.refreshControl?.endRefreshing()
                    self?.baseView.collectionView.reloadData()
                    self?.baseView.noCultivationLabelIsHidden(!cultivations.isEmpty)
                }
            },
            onError: { error in
                DispatchQueue.main.async {
                    HUD.hide()
                    self.baseView.collectionView.refreshControl?.endRefreshing()

                    let error = error as! ClientError // swiftlint:disable:this force_cast
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
            onNext: { [weak self] cultivation in
                transitionCultivationDetailPage(cultivation: cultivation)
            }
        )
        .disposed(by: disposeBag)
    }
}

// MARK: - Transition

extension CultivationViewController {
    private func transitionCultivationDetailPage(cultivation: KikurageCultivation) {
        pushToCultivationDetail(cultivation: cultivation.cultivation)
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
        if let kikurageUserId = LoginHelper.shared.kikurageUserId {
            viewModel.loadCultivations(kikurageUserId: kikurageUserId)
        }
    }
}
