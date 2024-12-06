//
//  PostRecipeBaseView.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2020/12/28.
//  Copyright © 2020 shusuke. All rights reserved.
//

import KikurageUI
import UIKit

protocol PostRecipeBaseViewDelegate: AnyObject {
    func postRecipeBaseViewDidTappedPostButton(_ postRecipeBaseView: PostRecipeBaseView)
    func postRecipeBaseViewDidEndEditingRecipeName(_ postRecipeBaseView: PostRecipeBaseView, text: String)
    func postRecipeBaseViewDidEndEditingRecipeMemo(_ postRecipeBaseView: PostRecipeBaseView, text: String)
}

class PostRecipeBaseView: UIView {
    private(set) var cameraCollectionView: UICollectionView!
    private var recipeNameTextField: KUIMaterialTextField!
    private var recipeMemoTextView: KUIMaterialTextView!
    private var dateTextFiled: KUIDropdownTextField!
    private var postButton: KUIButton!

    weak var delegate: PostRecipeBaseViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupComponent()
        setupAction()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func cofigCollectionView(delegate: UICollectionViewDelegate, dataSource: UICollectionViewDataSource) {
        cameraCollectionView.delegate = delegate
        cameraCollectionView.dataSource = dataSource
    }

    private func setupComponent() {
        backgroundColor = .systemGroupedBackground

        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 80, height: 80)
        flowLayout.minimumLineSpacing = 10
        flowLayout.minimumInteritemSpacing = 10
        cameraCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cameraCollectionView.backgroundColor = .systemGroupedBackground
        cameraCollectionView.register(KUISelectImageCollectionViewCell.self, forCellWithReuseIdentifier: KUISelectImageCollectionViewCell.identifier)
        cameraCollectionView.translatesAutoresizingMaskIntoConstraints = false

        recipeNameTextField = KUIMaterialTextField(props: KUIMaterialTextFieldProps(
            maxTextCount: 20,
            placeHolder: R.string.localizable.screen_post_recipe_recipe_name_textfield_placeholder()
        ))
        recipeNameTextField.translatesAutoresizingMaskIntoConstraints = false

        recipeMemoTextView = KUIMaterialTextView(props: KUIMaterialTextViewProps(
            maxTextCount: 100,
            placeHolder: R.string.localizable.screen_post_recipe_recipe_memo_textview_placeholder(),
            backgroundColor: .systemGroupedBackground
        ))
        recipeMemoTextView.translatesAutoresizingMaskIntoConstraints = false

        dateTextFiled = KUIDropdownTextField(props: KUIDropDownTextFieldProps(
            variant: .date,
            textFieldProps: KUITextFieldProps(placeHolder: R.string.localizable.screen_post_recipe_recipe_date_textfield_placeholder())
        ))
        dateTextFiled.translatesAutoresizingMaskIntoConstraints = false

        postButton = KUIButton(props: KUIButtonProps(
            variant: .primary,
            title: R.string.localizable.screen_post_recipe_post_button_title()
        ))
        postButton.translatesAutoresizingMaskIntoConstraints = false

        addSubview(cameraCollectionView)
        addSubview(recipeNameTextField)
        addSubview(recipeMemoTextView)
        addSubview(dateTextFiled)
        addSubview(postButton)

        NSLayoutConstraint.activate([
            cameraCollectionView.heightAnchor.constraint(equalToConstant: 180),
            cameraCollectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 15),
            cameraCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            cameraCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),

            recipeNameTextField.topAnchor.constraint(equalTo: cameraCollectionView.bottomAnchor, constant: 15),
            recipeNameTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            recipeNameTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),

            recipeMemoTextView.heightAnchor.constraint(equalToConstant: 70),
            recipeMemoTextView.topAnchor.constraint(equalTo: recipeNameTextField.bottomAnchor, constant: 30),
            recipeMemoTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            recipeMemoTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),

            dateTextFiled.topAnchor.constraint(equalTo: recipeMemoTextView.bottomAnchor, constant: 20),
            dateTextFiled.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            dateTextFiled.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),

            postButton.heightAnchor.constraint(equalToConstant: 45),
            postButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            postButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            postButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: 10)
        ])
    }

    private func setupAction() {
        postButton.onTap = { [weak self] in
            guard let self else {
                return
            }
            self.delegate?.postRecipeBaseViewDidTappedPostButton(self)
        }
        
        recipeNameTextField.onDidEndEditing = { [weak self] text in
            guard let self else {
                return
            }
            self.delegate?.postRecipeBaseViewDidEndEditingRecipeName(self, text: text)
        }
        
        recipeMemoTextView.onDidEndEditing = { [weak self] text in
            guard let self else {
                return
            }
            self.delegate?.postRecipeBaseViewDidEndEditingRecipeMemo(self, text: text)
        }
    }
}
