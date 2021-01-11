//
//  GraphBaseView.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2021/1/11.
//  Copyright © 2021 shusuke. All rights reserved.
//

import UIKit

protocol GraphBaaseViewDelegate: class {
    /// 閉じるボタンを押した時の処理
    func didTapCloseButton()
}

class GraphBaseView: UIView {
    
    @IBOutlet weak var navigationItem: UINavigationItem!
    /// デリゲート
    internal weak var delegate: GraphBaaseViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    // MARK: - Action Method
    @IBAction func didTapCloseButton(_ sender: Any) {
        self.delegate?.didTapCloseButton()
    }
}
// MARK: - Initialized Method
extension GraphBaseView {
    private func initUI() {
        // タイトル
        self.navigationItem.title = "グラフ"
    }
}
