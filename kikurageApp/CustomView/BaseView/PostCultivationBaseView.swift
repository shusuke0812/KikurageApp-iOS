//
//  PostCultivationBaseView.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2020/11/14.
//  Copyright © 2020 shusuke. All rights reserved.
//

import UIKit

protocol PostCultivationBaseViewDelegate: class {
    /// 栽培記録保存ボタンが押された時の処理
    func didTapPostButton()
}

class PostCultivationBaseView: UIView {
    
    @IBOutlet weak var navigationItem: UINavigationItem!
    @IBOutlet weak var cameraCollectionView: UICollectionView!
    @IBOutlet weak var textView: UITextViewWithPlaceholder!
    @IBOutlet weak var currentTextViewNumberLabel: UILabel!
    @IBOutlet weak var maxTextViewNumberLabel: UILabel!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var postButton: UIButton!
    
    /// デリゲート
    internal weak var delegate: PostCultivationBaseViewDelegate?
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initUI()
    }
    // MARK: - Action Method
    @IBAction func didTapPostButton(_ sender: Any) {
        self.delegate?.didTapPostButton()
    }
}
// MARK: - Initialized Method
extension PostCultivationBaseView {
    private func initUI() {
        self.navigationItem.title = "さいばいきろく保存"
        self.textView.placeholder = "観察メモ"
        self.postButton.layer.masksToBounds = true
        self.postButton.layer.cornerRadius = 5
    }
}

