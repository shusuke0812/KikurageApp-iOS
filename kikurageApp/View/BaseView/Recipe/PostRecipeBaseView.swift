//
//  PostRecipeBaseView.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2020/12/28.
//  Copyright © 2020 shusuke. All rights reserved.
//

import UIKit

protocol PostRecipeBaseViewDelegate: AnyObject {
    /// 料理記録を保存するボタンを押した時の処理
    func didTapPostButton()
    /// 閉じるボタンを押した時の処理
    func didTapCloseButton()
}

class PostRecipeBaseView: UIView {
    @IBOutlet weak var navigationItem: UINavigationItem!
    @IBOutlet weak var cameraCollectionView: UICollectionView!
    @IBOutlet weak var recipeNameTextField: UITextField!
    @IBOutlet weak var currentRecipeNameNumberLabel: UILabel!
    @IBOutlet weak var maxRecipeNameNumberLabel: UILabel!
    @IBOutlet weak var recipeMemoTextView: UITextViewWithPlaceholder!
    @IBOutlet weak var currentRecipeMemoNumberLabel: UILabel!
    @IBOutlet weak var maxRecipeMemoNumberLabel: UILabel!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var postButton: UIButton!
    /// デリゲート
    internal weak var delegate: PostRecipeBaseViewDelegate?
    /// 日付選択Picker
    var datePicker = UIDatePicker()
    /// 料理名の最大入力可能文字数
    let maxRecipeNameNumer = 20
    /// 料理メモの最大入力可能文字数
    let maxRecipeMemoNumber = 100

    override func awakeFromNib() {
        super.awakeFromNib()
        self.registerCameraCell()
        self.initUI()
        self.initTextFieldTag()
        self.initDatePicker()
    }
    // MARK: - Action Method
    @IBAction private func didTapCloseButton(_ sender: Any) {
        self.delegate?.didTapCloseButton()
    }
    @IBAction private func didTapPostButton(_ sender: Any) {
        self.delegate?.didTapPostButton()
    }
}
// MARK: - Initialized Method
extension PostRecipeBaseView {
    private func registerCameraCell() {
        self.cameraCollectionView.register(UINib(nibName: "CameraCell", bundle: nil), forCellWithReuseIdentifier: "CameraCell")
    }
    private func initUI() {
        // タイトル
        self.navigationItem.title = "りょうりきろく保存"
        // 背景色
        self.backgroundColor = .themeColor
        self.cameraCollectionView.backgroundColor = .themeColor
        self.recipeMemoTextView.backgroundColor = .themeColor
        // プレースホルダー
        self.recipeMemoTextView.placeholder = "料理メモ"
        self.recipeNameTextField.placeholder = "料理名"
        self.dateTextField.placeholder = "日付を選択"
        // 保存するボタン
        self.postButton.layer.masksToBounds = true
        self.postButton.layer.cornerRadius = 5
        // 最大入力文字数
        self.maxRecipeNameNumberLabel.text = "\(self.maxRecipeNameNumer)"
        self.maxRecipeMemoNumberLabel.text = "\(self.maxRecipeMemoNumber)"
    }
    private func initTextFieldTag() {
        self.recipeNameTextField.tag = Constants.TextFieldTag.recipeName
        self.dateTextField.tag = Constants.TextFieldTag.recipeDate
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
extension PostRecipeBaseView {
    func setCurrentRecipeNameNumber(text: String) {
        self.currentRecipeNameNumberLabel.text = "\(text.count)"
    }
    func setCurrentRecipeMemoNumber(text: String) {
        self.currentRecipeMemoNumberLabel.text = "\(text.count)"
    }
}
