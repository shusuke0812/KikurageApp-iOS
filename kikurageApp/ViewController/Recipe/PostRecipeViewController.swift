//
//  PostRecipeViewController.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2020/12/28.
//  Copyright © 2020 shusuke. All rights reserved.
//

import UIKit

class PostRecipeViewController: UIViewController {
    
    /// BaseView
    private var baseView: PostRecipeBaseView { self.view as! PostRecipeBaseView }
    /// ViewModel
    private var viewModel: PostRecipeViewModel!
    /// CameraCell ViewModel
    private var cameraCollectionViewModel: CameraCollectionViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.cameraCollectionViewModel = CameraCollectionViewModel(selectedImageMaxNumber: Constants.CameraCollectionCell.maxNumber)
        self.viewModel = PostRecipeViewModel(recipeRepository: RecipeRepository())
        self.setDelegateDataSource()
    }
}
// MARK: - Initialized Method
extension PostRecipeViewController {
    private func setDelegateDataSource() {
        self.baseView.delegate = self
        self.baseView.recipeNameTextField.delegate = self
        self.baseView.dateTextField.delegate = self
        self.baseView.cameraCollectionView.delegate = self
        self.baseView.cameraCollectionView.dataSource = self.cameraCollectionViewModel
        self.cameraCollectionViewModel.cameraCellDelegate = self
        self.viewModel.delegate = self
    }
}
// MARK: - BaseView Delegate Method
extension PostRecipeViewController: PostRecipeBaseViewDelegate {
    func didTapPostButton() {
        
    }
    func didTapCloseButton() {
        self.dismiss(animated: true, completion: nil)
    }
}
// MARK: - UITextField Delegate Method
extension PostRecipeViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField.tag {
        case Constants.TextFieldTag.recipeDate:
            print("")
        case Constants.TextFieldTag.recipeName:
            print("")
        default:
            break
        }
    }
}
// MARK: - CameraCell Delegate Method
extension PostRecipeViewController: CameraCellDelegate {
    func didTapImageCancelButton(cell: CameraCell) {
    }
}
// MARK: - UICollectionView Delegate Method
extension PostRecipeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}
// MARK: - PostRecipeViewModel Method
extension PostRecipeViewController: PostRecipeViewModelDelegate {
    func didSuccessPostRecipe() {
    }
    func didFailedPostRecipe(errorMessage: String) {
    }
    func didSuccessPostRecipeImages() {
    }
    func didFailedPostRecipeImages(errorMessage: String) {
    }
}
