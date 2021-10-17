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
    @IBOutlet private weak var navigationItem: UINavigationItem!
    @IBOutlet weak var cameraCollectionView: UICollectionView!
    @IBOutlet weak var textView: UITextViewWithPlaceholder!
    @IBOutlet private weak var currentTextViewNumberLabel: UILabel!
    @IBOutlet private weak var maxTextViewNumberLabel: UILabel!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet private weak var postButton: UIButton!

    weak var delegate: PostCultivationBaseViewDelegate?

    var datePicker = UIDatePicker()
    /// 観察メモの最大入力可能文字数
    let maxTextViewNumber = 200

    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        registerCameraCell()
        initUI()
        initDatePicker()
    }
    // MARK: - Action
    @IBAction private func didTapPostButton(_ sender: Any) {
        delegate?.didTapPostButton()
    }
    @IBAction private func didTapCloseButton(_ sender: Any) {
        delegate?.didTapCloseButton()
    }
}
// MARK: - Initialized
extension PostCultivationBaseView {
    private func registerCameraCell() {
        cameraCollectionView.register(R.nib.cameraCell)
    }
    private func initUI() {
        // タイトル
        navigationItem.title = "さいばいきろく保存"
        // 背景色
        backgroundColor = .themeColor
        cameraCollectionView.backgroundColor = .themeColor
        textView.backgroundColor = .themeColor
        // プレースホルダー
        textView.placeholder = "観察メモ"
        dateTextField.placeholder = "日付を選択"
        // 保存するボタン
        postButton.layer.masksToBounds = true
        postButton.layer.cornerRadius = 5
        // 最大入力文字数
        maxTextViewNumberLabel.text = "\(maxTextViewNumber)"
    }
    private func initDatePicker() {
        // DatePickerの基本設定
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        datePicker.timeZone = NSTimeZone.local
        datePicker.locale = Locale.current
        // 現在の日付の1ヶ月前
        let minDate = Calendar.current.date(byAdding: .month, value: -1, to: Date())
        // DatePickerの範囲設定
        datePicker.minimumDate = minDate
        datePicker.maximumDate = Date()
        // TextFieldの入力にDatePickerを接続
        dateTextField.inputView = datePicker
    }
}
// MARK: - Setting UI Method
extension PostCultivationBaseView {
    func setCurrentTextViewNumber(text: String) {
        currentTextViewNumberLabel.text = "\(text.count)"
    }
}
