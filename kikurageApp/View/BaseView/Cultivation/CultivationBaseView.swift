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
    @IBOutlet weak var noCultivationLabel: UILabel!
    /// デリゲート
    weak var delegate: CultivationBaseViewDelegate?

    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initUI()
        self.setCollectionView()
    }
    // MARK: - Action
    @IBAction private func didTapPostCultivationPageButton(_ sender: Any) {
        self.delegate?.didTapPostCultivationPageButton()
    }
}
// MARK: - Initialized
extension CultivationBaseView {
    private func initUI() {
        self.noCultivationLabel.text = "さいばいきろくがありません"
        self.noCultivationLabel.textColor = .darkGray
        self.noCultivationLabel.isHidden = true
    }
    private func setCollectionView() {
        self.flowLayout.estimatedItemSize = .zero
        self.collectionView.register(R.nib.cultivationCollectionViewCell)
    }
}
