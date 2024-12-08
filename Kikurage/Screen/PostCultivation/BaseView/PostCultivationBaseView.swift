//
//  PostCultivationBaseView.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2020/12/8.
//  Copyright © 2020 shusuke. All rights reserved.
//

import KikurageUI
import UIKit

protocol PostCultivationBaseViewDelegate: AnyObject {
    func postCultivationBaseViewDidTappedPostButton(_ postCultivationBaseView: PostCultivationBaseView)
    func postCultivationBaseViewDidEndEditingCultivationMemo(_ postCultivationBaseView: PostCultivationBaseView, text: String)
    func postCultivationBaseViewDidEndEditingCultivationDate(_ postCultivationBaseView: PostCultivationBaseView, date: Date)
}

class PostCultivationBaseView: UIView {
    private(set) var cameraCollectionView: UICollectionView!
    private var cultivationMemoTextView: KUIMaterialTextView!
    private var dateTextField: KUIDropdownTextField!
    private var postButton: KUIButton!

    weak var delegate: PostCultivationBaseViewDelegate?

    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupComponent()
        setupAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configCollectionView(delegate: UICollectionViewDelegate, dataSource: UICollectionViewDataSource) {
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
        
        cultivationMemoTextView = KUIMaterialTextView(props: KUIMaterialTextViewProps(
            maxTextCount: 200,
            placeHolder: R.string.localizable.screen_post_cultivation_textview_placeholder(),
            backgroundColor: .systemGroupedBackground
        ))
        cultivationMemoTextView.translatesAutoresizingMaskIntoConstraints = false
        
        dateTextField = KUIDropdownTextField(props: KUIDropDownTextFieldProps(
            variant: .date,
            textFieldProps: KUITextFieldProps(placeHolder: R.string.localizable.screen_post_cultivation_date_textfield_placeholder())
        ))
        dateTextField.translatesAutoresizingMaskIntoConstraints = false
        
        postButton = KUIButton(props: KUIButtonProps(
            variant: .primary,
            title: R.string.localizable.screen_post_cultivation_post_button_title()
        ))
        postButton.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(cameraCollectionView)
        addSubview(cultivationMemoTextView)
        addSubview(dateTextField)
        addSubview(postButton)
        
        NSLayoutConstraint.activate([
            cameraCollectionView.heightAnchor.constraint(equalToConstant: 180),
            cameraCollectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 30),
            cameraCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            cameraCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            
            cultivationMemoTextView.topAnchor.constraint(equalTo: cameraCollectionView.bottomAnchor, constant: 15),
            cultivationMemoTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            cultivationMemoTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            
            dateTextField.topAnchor.constraint(equalTo: cultivationMemoTextView.bottomAnchor, constant: 20),
            dateTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            dateTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            
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
            self.delegate?.postCultivationBaseViewDidTappedPostButton(self)
        }
        
        cultivationMemoTextView.onDidEndEditing = { [weak self] text in
            guard let self else {
                return
            }
            self.delegate?.postCultivationBaseViewDidEndEditingCultivationMemo(self, text: text)
        }
        
        dateTextField.onDidEndEditing = { [weak self] (date: Date) in
            guard let self else {
                return
            }
            self.delegate?.postCultivationBaseViewDidEndEditingCultivationDate(self, date: date)
        }
    }
}

// MARK: - Config

extension PostCultivationBaseView {
//    func setCurrentTextViewNumber(text: String) {
//        currentTextViewNumberLabel.text = "\(text.count)"
//    }
//
//    func configCollectionView(delegate: UICollectionViewDelegate, dataSource: UICollectionViewDataSource) {
//        cameraCollectionView.delegate = delegate
//        cameraCollectionView.dataSource = dataSource
//    }
//
//    func configTextView(delegate: UITextViewDelegate) {
//        textView.delegate = delegate
//    }
//
//    func configTextField(delegate: UITextFieldDelegate) {
//        dateTextField.delegate = delegate
//    }
}
