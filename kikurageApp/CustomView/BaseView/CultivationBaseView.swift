//
//  CultivationBaseView.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2020/11/18.
//  Copyright © 2020 shusuke. All rights reserved.
//

import UIKit

protocol CultivationBaseViewDelegate: class {
    /// 栽培記録保存画面のボタンをタップした時の処理
    func didTapPostCultivationPageButton()
}

class CultivationBaseView: UIView {
    
    @IBOutlet weak var postPageButton: UIButton!
    
    /// デリゲート
    internal weak var delegate: CultivationBaseViewDelegate?
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    // MARK: - Action Method
    @IBAction func didTapPostCultivationPageButton(_ sender: Any) {
        self.delegate?.didTapPostCultivationPageButton()
    }
}
// MARK: - Initialized Method
extension CultivationBaseView {
    private func initUI() {
    }
}
