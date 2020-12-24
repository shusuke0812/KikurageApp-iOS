//
//  CultivationDetailViewController.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2020/12/19.
//  Copyright © 2020 shusuke. All rights reserved.
//

import UIKit

class CultivationDetailViewController: UIViewController {
    
    /// BaseView
    private var baseView: CultivationDetailBaseView { self.view as! CultivationDetailBaseView }
    /// ViewModel
    private var viewModel: CultivationDetailViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = CultivationDetailViewModel()
        self.setDelegateDataSource()
        self.setNavigationItem()
    }
}
// MARK: - Private Method
extension CultivationDetailViewController {
    private func setNavigationItem() {
        self.setNavigationBar(title: "さいばいきろく詳細")
    }
    private func setDelegateDataSource() {
        self.baseView.collectionView.delegate = self
        self.baseView.collectionView.dataSource = self.viewModel
    }
}
// MARK: - UICollectionView Delegate Method
extension CultivationDetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO: 画像拡大処理を書く
    }
}
// MARK: - UICollectionView Delegate FlowLayout Method
extension CultivationDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let horiizontalSpace: CGFloat = 0.0
        let cellWidth: CGFloat = self.baseView.bounds.width - horiizontalSpace
        let cellHeight: CGFloat = cellWidth
        return CGSize(width: cellWidth, height: cellHeight)
    }
}
