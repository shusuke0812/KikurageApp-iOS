//
//  CultivationBaseView.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2020/11/18.
//  Copyright © 2020 shusuke. All rights reserved.
//

import UIKit

protocol CultivationBaseViewDelegate: AnyObject {
    /// 栽培記録保存画面のボタンをタップした時の処理
    func didTapPostCultivationPageButton()
}

class CultivationBaseView: UIView {
    @IBOutlet private weak var postPageButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet private weak var flowLayout: UICollectionViewFlowLayout!
    /// デリゲート
    weak var delegate: CultivationBaseViewDelegate?

    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setCollectionView()
    }
    // MARK: - Action Method
    @IBAction private func didTapPostCultivationPageButton(_ sender: Any) {
        self.delegate?.didTapPostCultivationPageButton()
    }
}
// MARK: - Initialized Method
extension CultivationBaseView {
    private func setCollectionView() {
        self.flowLayout.estimatedItemSize = .zero
        self.collectionView.register(R.nib.cultivationCollectionViewCell)
    }
}
