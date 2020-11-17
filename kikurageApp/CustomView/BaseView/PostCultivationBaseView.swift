//
//  PostCultivationBaseView.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2020/11/14.
//  Copyright © 2020 shusuke. All rights reserved.
//

import UIKit

class PostCultivationBaseView: UIView {
    
    @IBOutlet weak var cameraCollectionView: UICollectionView!
    @IBOutlet weak var textView: UITextViewWithPlaceholder!
    @IBOutlet weak var currentTextViewNumberLabel: UILabel!
    @IBOutlet weak var maxTextViewNumberLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initUI()
    }
}
// MARK: - Initialized Method
extension PostCultivationBaseView {
    private func initUI() {
        self.textView.placeholder = "観察メモ"
    }
}

