//
//  saibaiViewController.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2019/03/02.
//  Copyright © 2019 shusuke. All rights reserved.
//

import UIKit
import PKHUD

class CultivationViewController: UIViewController, UIViewControllerNavigatable {
    private var baseView: CultivationBaseView { self.view as! CultivationBaseView } // swiftlint:disable:this force_cast
    private var viewModel: CultivationViewModel!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = CultivationViewModel(cultivationRepository: CultivationRepository())
        setNavigationItem()
        setDelegateDataSource()
        setNotificationCenter()
        setRefreshControl()

        adjustNavigationBarBackgroundColor()

        if let kikurageUserId = LoginHelper.shared.kikurageUserId {
            HUD.show(.progress)
            viewModel.loadCultivations(kikurageUserId: kikurageUserId)
        }
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
    private func setDelegateDataSource() {
        baseView.delegate = self
        baseView.configColletionView(delegate: self, dataSource: viewModel)
        viewModel.delegate = self
    }
    private func setRefreshControl() {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        baseView.setRefreshControlInCollectionView(refresh)
    }
}

// MARK: - Transition

extension CultivationViewController {
    private func transitionCultivationDetailPage(indexPath: IndexPath) {
        guard let vc = R.storyboard.cultivationDetailViewController.instantiateInitialViewController() else { return }
        vc.cultivation = viewModel.cultivations[indexPath.row].cultivation
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - CultivationBaseView Delegate

extension CultivationViewController: CultivationBaseViewDelegate {
    func cultivationBaseViewDidTapPostCultivationPageButton(_ cultivationBaseView: CultivationBaseView) {
        guard let vc = R.storyboard.postCultivationViewController.instantiateInitialViewController() else { return }
        present(vc, animated: true, completion: nil)
    }
}

// MARK: - CultivationViewModel Delegate

extension CultivationViewController: CultivationViewModelDelegate {
    func cultivationViewModelDidSuccessGetCultivations(_ cultivationViewModel: CultivationViewModel) {
        DispatchQueue.main.async {
            HUD.hide()
            self.baseView.collectionView.refreshControl?.endRefreshing()

            self.baseView.collectionView.reloadData()
            self.baseView.noCultivationLabelIsHidden(!(cultivationViewModel.cultivations.isEmpty))
        }
    }
    func cultivationViewModelDidFailedGetCultivations(_ cultivationViewModel: CultivationViewModel, with errorMessage: String) {
        DispatchQueue.main.async {
            HUD.hide()
            self.baseView.collectionView.refreshControl?.endRefreshing()

            UIAlertController.showAlert(style: .alert, viewController: self, title: errorMessage, message: nil, okButtonTitle: R.string.localizable.common_alert_ok_btn_ok(), cancelButtonTitle: nil, completionOk: nil)
        }
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

// MARK: - UICollectionView Delegate

extension CultivationViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        transitionCultivationDetailPage(indexPath: indexPath)
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
