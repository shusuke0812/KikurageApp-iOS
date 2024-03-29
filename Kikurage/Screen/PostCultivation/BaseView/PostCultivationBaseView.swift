//
//  PostCultivationBaseView.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2020/12/8.
//  Copyright © 2020 shusuke. All rights reserved.
//

import UIKit

protocol PostCultivationBaseViewDelegate: AnyObject {
    func postCultivationBaseViewDidTappedPostButton(_ postCultivationBaseView: PostCultivationBaseView)
}

class PostCultivationBaseView: UIView {
    @IBOutlet private(set) weak var cameraCollectionView: UICollectionView!
    @IBOutlet private(set) weak var textView: UITextViewWithPlaceholder!
    @IBOutlet private weak var currentTextViewNumberLabel: UILabel!
    @IBOutlet private weak var maxTextViewNumberLabel: UILabel!
    @IBOutlet private(set) weak var dateTextField: UITextField!
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

    @IBAction private func post(_ sender: Any) {
        delegate?.postCultivationBaseViewDidTappedPostButton(self)
    }
}

// MARK: - Initialized

extension PostCultivationBaseView {
    private func registerCameraCell() {
        cameraCollectionView.register(R.nib.cameraCell)
    }

    private func initUI() {
        // 背景色
        backgroundColor = .systemGroupedBackground
        cameraCollectionView.backgroundColor = .systemGroupedBackground
        textView.backgroundColor = .systemGroupedBackground
        // プレースホルダー
        textView.placeholder = R.string.localizable.screen_post_cultivation_textview_placeholder()
        dateTextField.placeholder = R.string.localizable.screen_post_cultivation_date_textfield_placeholder()
        // 保存するボタン
        postButton.layer.masksToBounds = true
        postButton.layer.cornerRadius = .buttonCornerRadius
        // 最大入力文字数
        maxTextViewNumberLabel.text = "\(maxTextViewNumber)"
    }

    private func initDatePicker() {
        // DatePickerの基本設定
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
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

// MARK: - Config

extension PostCultivationBaseView {
    func setCurrentTextViewNumber(text: String) {
        currentTextViewNumberLabel.text = "\(text.count)"
    }

    func configCollectionView(delegate: UICollectionViewDelegate, dataSource: UICollectionViewDataSource) {
        cameraCollectionView.delegate = delegate
        cameraCollectionView.dataSource = dataSource
    }

    func configTextView(delegate: UITextViewDelegate) {
        textView.delegate = delegate
    }

    func configTextField(delegate: UITextFieldDelegate) {
        dateTextField.delegate = delegate
    }
}
