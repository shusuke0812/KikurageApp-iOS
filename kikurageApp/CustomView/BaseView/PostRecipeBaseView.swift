//
//  PostRecipeBaseView.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2020/12/28.
//  Copyright © 2020 shusuke. All rights reserved.
//

import UIKit

protocol PostRecipeBaseViewDelegate: class {
    /// 料理記録を保存するボタンを押した時の処理
    func didTapPostButton()
    /// 閉じるボタンを押した時の処理
    func didTapCloseButton()
}

class PostRecipeBaseView: UIView {
    @IBOutlet weak var navigationItem: UINavigationBar!
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    // MARK: - Action Method
    @IBAction func didTapCloseButton(_ sender: Any) {
        self.delegate?.didTapCloseButton()
    }
    @IBAction func didTapPostButton(_ sender: Any) {
        self.delegate?.didTapPostButton()
    }
}
// MARK: - Initialized Method
extension PostRecipeBaseView {
    
}
// MARK: - Setting UI Method
extension PostRecipeBaseView {
    
}
