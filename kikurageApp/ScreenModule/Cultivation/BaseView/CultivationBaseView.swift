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

    weak var delegate: CultivationBaseViewDelegate?

    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        initUI()
        setCollectionView()
    }
    // MARK: - Action
    @IBAction private func didTapPostCultivationPageButton(_ sender: Any) {
        delegate?.didTapPostCultivationPageButton()
    }
}
// MARK: - Initialized
extension CultivationBaseView {
    private func initUI() {
        noCultivationLabel.text = "さいばいきろくがありません"
        noCultivationLabel.textColor = .darkGray
        noCultivationLabel.isHidden = true
    }
    private func setCollectionView() {
        flowLayout.estimatedItemSize = .zero
        collectionView.register(R.nib.cultivationCollectionViewCell)
    }
}
