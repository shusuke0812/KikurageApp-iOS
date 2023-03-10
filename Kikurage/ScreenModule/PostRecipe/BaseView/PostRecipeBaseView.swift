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
}

class PostRecipeBaseView: UIView {
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

    let maxRecipeNameNumer = 20
    let maxRecipeMemoNumber = 100

    override func awakeFromNib() {
        super.awakeFromNib()
        registerCameraCell()
        initUI()
        initDatePicker()
    }

    // MARK: - Action

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
        backgroundColor = .systemGroupedBackground
        cameraCollectionView.backgroundColor = .systemGroupedBackground
        recipeMemoTextView.backgroundColor = .systemGroupedBackground

        recipeMemoTextView.placeholder = R.string.localizable.screen_post_recipe_recipe_memo_textview_placeholder()
        recipeNameTextField.placeholder = R.string.localizable.screen_post_recipe_recipe_name_textfield_placeholder()
        dateTextField.placeholder = R.string.localizable.screen_post_recipe_recipe_date_textfield_placeholder()
        postButton.layer.masksToBounds = true
        postButton.layer.cornerRadius = .buttonCornerRadius

        maxRecipeNameNumberLabel.text = "\(maxRecipeNameNumer)"
        maxRecipeMemoNumberLabel.text = "\(maxRecipeMemoNumber)"
    }

    private func initDatePicker() {
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        datePicker.datePickerMode = .date
        datePicker.timeZone = NSTimeZone.local
        datePicker.locale = Locale.current

        let minDate = Calendar.current.date(byAdding: .month, value: -1, to: Date())
        datePicker.minimumDate = minDate
        datePicker.maximumDate = Date()

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
