//
//  CultivationDetailViewController.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2020/12/19.
//  Copyright © 2020 shusuke. All rights reserved.
//

import UIKit

class CultivationDetailViewController: UIViewController, UIViewControllerNavigatable {
    private var baseView: CultivationDetailBaseView { view as! CultivationDetailBaseView } // swiftlint:disable:this force_cast
    private var viewModel: CultivationDetailViewModel!

    var cultivation: KikurageCultivation!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = CultivationDetailViewModel(cultivation: cultivation)
        setDelegateDataSource()
        setNavigationItem()
        setUI()
        adjustNavigationBarBackgroundColor()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        FirebaseAnalyticsHelper.sendScreenViewEvent(.cultivationDetail)
    }
}

// MARK: - Private

extension CultivationDetailViewController {
    private func setNavigationItem() {
        setNavigationBar(title: R.string.localizable.screen_cultivation_detail_title())
    }

    private func setDelegateDataSource() {
        baseView.configCollectionView(delegate: self, dataSource: viewModel)
    }

    private func setUI() {
        baseView.setUI(cultivation: cultivation)
        baseView.configPageControl(imageCount: cultivation.imageStoragePaths.count)
    }
}

// MARK: - UICollectionView Delegate

extension CultivationDetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO: 画像拡大処理を書く
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = viewModel.currentPage(on: scrollView)
        DispatchQueue.main.async {
            self.baseView.configPageControl(didChangedCurrentPage: page)
        }
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
