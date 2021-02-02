//
//  saibaiViewController.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2019/03/02.
//  Copyright © 2019 shusuke. All rights reserved.
//

import UIKit

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
        if let kikurageUserId = UserDefaults.standard.string(forKey: Constants.UserDefaultsKey.userId) {
            self.viewModel.loadCultivations(kikurageUserId: kikurageUserId)
        }
    }
}
// MARK: - Initialized Method
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
// MARK: - Private Method
extension CultivationViewController {
    private func transitionCultivationDetailPage(indexPath: IndexPath) {
        let s = UIStoryboard(name: "CultivationDetailViewController", bundle: nil)
        let vc = s.instantiateInitialViewController() as! CultivationDetailViewController // swiftlint:disable:this force_cast
        vc.cultivation = self.viewModel.cultivations[indexPath.row].cultivation
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
// MARK: - CultivationBaseView Delegate Method
extension CultivationViewController: CultivationBaseViewDelegate {
    func didTapPostCultivationPageButton() {
        let s = UIStoryboard(name: "PostCultivationViewController", bundle: nil)
        let vc = s.instantiateInitialViewController() as! PostCultivationViewController // swiftlint:disable:this force_cast
        self.present(vc, animated: true, completion: nil)
    }
}
// MARK: - CultivationViewModel Delegate Method
extension CultivationViewController: CultivationViewModelDelegate {
    func didSuccessGetCultivations() {
        self.baseView.collectionView.reloadData()
    }
    func didFailedGetCultivations(errorMessage: String) {
        print(errorMessage)
    }
}
// MARK: - UICollectionView Delegate FlowLayout Method
extension CultivationViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let horizontalSpace: CGFloat = 1.0
        let cellWidth: CGFloat = self.baseView.bounds.width / 2 - horizontalSpace
        let cellHeight: CGFloat = cellWidth
        return CGSize(width: cellWidth, height: cellHeight)
    }
}
// MARK: - UICollectionView Delegate Method
extension CultivationViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.transitionCultivationDetailPage(indexPath: indexPath)
    }
}
