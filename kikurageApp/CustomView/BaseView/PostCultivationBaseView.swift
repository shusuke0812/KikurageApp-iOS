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
    /// 閉じるボタンが押された時の処理
    func didTapCloseButton()
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
    /// 日付選択Picker
    var datePicker = UIDatePicker()
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initUI()
        self.initDatePicker()
    }
    // MARK: - Action Method
    @IBAction func didTapPostButton(_ sender: Any) {
        self.delegate?.didTapPostButton()
    }
    @IBAction func didTapCloseButton(_ sender: Any) {
        self.delegate?.didTapCloseButton()
    }
}
// MARK: - Initialized Method
extension PostCultivationBaseView {
    private func initUI() {
        // タイトル
        self.navigationItem.title = "さいばいきろく保存"
        // 背景色
        self.backgroundColor = .themeColor
        self.cameraCollectionView.backgroundColor = .themeColor
        self.textView.backgroundColor = .themeColor
        // プレースホルダー
        self.textView.placeholder = "観察メモ"
        self.dateTextField.placeholder = "日付を選択"
        // 保存するボタン
        self.postButton.layer.masksToBounds = true
        self.postButton.layer.cornerRadius = 5
    }
    private func initDatePicker() {
        self.datePicker.preferredDatePickerStyle = .wheels
        self.datePicker.datePickerMode = .date
        self.datePicker.timeZone = NSTimeZone.local
        self.datePicker.locale = Locale.current
        self.dateTextField.inputView = self.datePicker
    }
}

