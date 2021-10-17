//
//  CultivationDetailViewController.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2020/12/19.
//  Copyright © 2020 shusuke. All rights reserved.
//

import UIKit

class CultivationDetailViewController: UIViewController, UIViewControllerNavigatable {
    private var baseView: CultivationDetailBaseView { self.view as! CultivationDetailBaseView } // swiftlint:disable:this force_cast
    private var viewModel: CultivationDetailViewModel!
    /// 前画面から渡された栽培記録データ
    var cultivation: KikurageCultivation!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = CultivationDetailViewModel(cultivation: self.cultivation)
        setDelegateDataSource()
        setNavigationItem()
        setUI()
    }
}
// MARK: - Private
extension CultivationDetailViewController {
    private func setNavigationItem() {
        setNavigationBar(title: "さいばいきろく詳細")
    }
    private func setDelegateDataSource() {
        baseView.collectionView.delegate = self
        baseView.collectionView.dataSource = viewModel
    }
    private func setUI() {
        baseView.setUI(cultivation: self.cultivation)
    }
}
// MARK: - UICollectionView Delegate
extension CultivationDetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO: 画像拡大処理を書く
    }
}
// MARK: - UICollectionView Delegate FlowLayout
extension CultivationDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let horiizontalSpace: CGFloat = 0.0
        let cellWidth: CGFloat = baseView.bounds.width - horiizontalSpace
        let cellHeight: CGFloat = baseView.collectionView.bounds.height
        return CGSize(width: cellWidth, height: cellHeight)
    }
}
