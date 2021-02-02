//
//  PostCultivationBaseView.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2020/12/8.
//  Copyright © 2020 shusuke. All rights reserved.
//

import UIKit

protocol PostCultivationBaseViewDelegate: AnyObject {
    /// 栽培記録保存するボタンを押した時の処理
    func didTapPostButton()
    /// 閉じるボタンを押した時の処理
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
    /// 観察メモの最大入力可能文字数
    let maxTextViewNumber = 200

    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.registerCameraCell()
        self.initUI()
        self.initDatePicker()
    }
    // MARK: - Action Method
    @IBAction private func didTapPostButton(_ sender: Any) {
        self.delegate?.didTapPostButton()
    }
    @IBAction private func didTapCloseButton(_ sender: Any) {
        self.delegate?.didTapCloseButton()
    }
}
// MARK: - Initialized Method
extension PostCultivationBaseView {
    private func registerCameraCell() {
        self.cameraCollectionView.register(UINib(nibName: "CameraCell", bundle: nil), forCellWithReuseIdentifier: "CameraCell")
    }
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
        // 最大入力文字数
        self.maxTextViewNumberLabel.text = "\(self.maxTextViewNumber)"
    }
    private func initDatePicker() {
        // DatePickerの基本設定
        self.datePicker.preferredDatePickerStyle = .wheels
        self.datePicker.datePickerMode = .date
        self.datePicker.timeZone = NSTimeZone.local
        self.datePicker.locale = Locale.current
        // 現在の日付の1ヶ月前
        let minDate = Calendar.current.date(byAdding: .month, value: -1, to: Date())
        // DatePickerの範囲設定
        self.datePicker.minimumDate = minDate
        self.datePicker.maximumDate = Date()
        // TextFieldの入力にDatePickerを接続
        self.dateTextField.inputView = self.datePicker
    }
}
// MARK: - Setting UI Method
extension PostCultivationBaseView {
    func setCurrentTextViewNumber(text: String) {
        self.currentTextViewNumberLabel.text = "\(text.count)"
    }
}
