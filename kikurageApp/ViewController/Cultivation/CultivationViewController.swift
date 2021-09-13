//
//  saibaiViewController.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2019/03/02.
//  Copyright © 2019 shusuke. All rights reserved.
//

import UIKit
import PKHUD

class CultivationViewController: UIViewController {
    /// BaseView
    private var baseView: CultivationBaseView { self.view as! CultivationBaseView } // swiftlint:disable:this force_cast
    /// ViewModel
    private var viewModel: CultivationViewModel!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = CultivationViewModel(cultivationRepository: CultivationRepository())
        self.setNavigationItem()
        self.setDelegateDataSource()
        if let kikurageUserId = LoginHelper.shared.kikurageUserId {
            HUD.show(.progress)
            self.viewModel.loadCultivations(kikurageUserId: kikurageUserId)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}
// MARK: - Initialized
extension CultivationViewController {
    private func setNavigationItem() {
        self.setNavigationBar(title: "さいばいきろく")
    }
    private func setDelegateDataSource() {
        self.baseView.delegate = self
        self.baseView.collectionView.delegate = self
        self.baseView.collectionView.dataSource = self.viewModel
        self.viewModel.delegate = self
    }
}
// MARK: - Private
extension CultivationViewController {
    private func transitionCultivationDetailPage(indexPath: IndexPath) {
        guard let vc = R.storyboard.cultivationDetailViewController.instantiateInitialViewController() else { return }
        vc.cultivation = self.viewModel.cultivations[indexPath.row].cultivation
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
// MARK: - CultivationBaseView Delegate
extension CultivationViewController: CultivationBaseViewDelegate {
    func didTapPostCultivationPageButton() {
        guard let vc = R.storyboard.postCultivationViewController.instantiateInitialViewController() else { return }
        self.present(vc, animated: true, completion: nil)
    }
}
// MARK: - CultivationViewModel Delegate
extension CultivationViewController: CultivationViewModelDelegate {
    func didSuccessGetCultivations() {
        DispatchQueue.main.async {
            HUD.hide()
            self.baseView.collectionView.reloadData()
            self.baseView.noCultivationLabel.isHidden = !(self.viewModel.cultivations.isEmpty)
        }
    }
    func didFailedGetCultivations(errorMessage: String) {
        print(errorMessage)
        DispatchQueue.main.async {
            HUD.hide()
        }
    }
}
// MARK: - UICollectionView Delegate FlowLayout
extension CultivationViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let horizontalSpace: CGFloat = 1.0
        let cellWidth: CGFloat = self.baseView.bounds.width / 2 - horizontalSpace
        let cellHeight: CGFloat = cellWidth
        return CGSize(width: cellWidth, height: cellHeight)
    }
}
// MARK: - UICollectionView Delegate
extension CultivationViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.transitionCultivationDetailPage(indexPath: indexPath)
    }
}
