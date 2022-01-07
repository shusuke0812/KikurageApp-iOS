//
//  PostRecipeBaseView.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2020/12/28.
//  Copyright © 2020 shusuke. All rights reserved.
//

import UIKit

protocol PostRecipeBaseViewDelegate: AnyObject {
    func postRecipeBaseViewDidTappedPostButton(_ postRecipeBaseView: PostRecipeBaseView)
    func postRecipeBaseViewDidTappedCloseButton(_ postRecipeBaseView: PostRecipeBaseView)
}

class PostRecipeBaseView: UIView {
    @IBOutlet private weak var navigationItem: UINavigationItem!
    @IBOutlet private(set) weak var cameraCollectionView: UICollectionView!
    @IBOutlet private(set) weak var recipeNameTextField: UITextField!
    @IBOutlet private weak var currentRecipeNameNumberLabel: UILabel!
    @IBOutlet private weak var maxRecipeNameNumberLabel: UILabel!
    @IBOutlet private(set) weak var recipeMemoTextView: UITextViewWithPlaceholder!
    @IBOutlet private weak var currentRecipeMemoNumberLabel: UILabel!
    @IBOutlet private weak var maxRecipeMemoNumberLabel: UILabel!
    @IBOutlet private(set) weak var dateTextField: UITextField!
    @IBOutlet private weak var postButton: UIButton!

    weak var delegate: PostRecipeBaseViewDelegate?

    var datePicker = UIDatePicker()
    /// 料理名の最大入力可能文字数
    let maxRecipeNameNumer = 20
    /// 料理メモの最大入力可能文字数
    let maxRecipeMemoNumber = 100

    override func awakeFromNib() {
        super.awakeFromNib()
        registerCameraCell()
        initUI()
        initDatePicker()
    }

    // MARK: - Action

    @IBAction private func close(_ sender: Any) {
        delegate?.postRecipeBaseViewDidTappedCloseButton(self)
    }
    @IBAction private func post(_ sender: Any) {
        delegate?.postRecipeBaseViewDidTappedPostButton(self)
    }
}

// MARK: - Initialized

extension PostRecipeBaseView {
    private func registerCameraCell() {
        cameraCollectionView.register(R.nib.cameraCell)
    }
    private func initUI() {
        // タイトル
        navigationItem.title = R.string.localizable.screen_post_recipe_title()
        // 背景色
        backgroundColor = .systemGroupedBackground
        cameraCollectionView.backgroundColor = .systemGroupedBackground
        recipeMemoTextView.backgroundColor = .systemGroupedBackground
        // プレースホルダー
        recipeMemoTextView.placeholder = R.string.localizable.screen_post_recipe_recipe_memo_textview_placeholder()
        recipeNameTextField.placeholder = R.string.localizable.screen_post_recipe_recipe_name_textfield_placeholder()
        dateTextField.placeholder = R.string.localizable.screen_post_recipe_recipe_date_textfield_placeholder()
        // 保存するボタン
        postButton.layer.masksToBounds = true
        postButton.layer.cornerRadius = .buttonCornerRadius
        // 最大入力文字数
        maxRecipeNameNumberLabel.text = "\(maxRecipeNameNumer)"
        maxRecipeMemoNumberLabel.text = "\(maxRecipeMemoNumber)"
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

extension PostRecipeBaseView {
    func setCurrentRecipeNameNumber(text: String) {
        currentRecipeNameNumberLabel.text = "\(text.count)"
    }
    func setCurrentRecipeMemoNumber(text: String) {
        currentRecipeMemoNumberLabel.text = "\(text.count)"
    }
    func cofigCollectionView(delegate: UICollectionViewDelegate, dataSource: UICollectionViewDataSource) {
        cameraCollectionView.delegate = delegate
        cameraCollectionView.dataSource = dataSource
    }
    func configTextField(delegate: UITextFieldDelegate) {
        recipeNameTextField.delegate = delegate
        dateTextField.delegate = delegate
    }
    func configTextView(delegate: UITextViewDelegate) {
        recipeMemoTextView.delegate = delegate
    }
}
