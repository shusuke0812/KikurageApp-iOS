//
//  PostRecipeViewController.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2020/12/28.
//  Copyright © 2020 shusuke. All rights reserved.
//

import PKHUD
import UIKit

class PostRecipeViewController: UIViewController, UIViewControllerNavigatable {
    private var baseView: PostRecipeBaseView { view as! PostRecipeBaseView } // swiftlint:disable:this force_cast
    private var viewModel: PostRecipeViewModel!
    private var cameraCollectionViewModel: CameraCollectionViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        cameraCollectionViewModel = CameraCollectionViewModel(selectedImageMaxNumber: Constants.CameraCollectionCell.maxNumber)
        viewModel = PostRecipeViewModel(recipeRepository: RecipeRepository())
        setDelegateDataSource()
        setNavigation()
        adjustNavigationBarBackgroundColor()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        FirebaseAnalyticsHelper.sendScreenViewEvent(.postRecipe)
    }

    // MARK: - Action

    @objc private func close(_ sender: UIBarButtonItem) {
        presentingViewController?.dismiss(animated: true)
    }
}

// MARK: - Initialized

extension PostRecipeViewController {
    private func setDelegateDataSource() {
        baseView.delegate = self
        baseView.configTextField(delegate: self)
        baseView.configTextView(delegate: self)
        baseView.cofigCollectionView(delegate: self, dataSource: cameraCollectionViewModel)
        cameraCollectionViewModel.cameraCellDelegate = self
        viewModel.delegate = self
    }

    private func setNavigation() {
        let closeButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(close(_:)))
        navigationItem.rightBarButtonItems = [closeButtonItem]
        navigationItem.title = R.string.localizable.screen_post_recipe_title()
    }
}

// MARK: - PostRecipeBaseView Delegate

extension PostRecipeViewController: PostRecipeBaseViewDelegate {
    func postRecipeBaseViewDidTappedPostButton(_ postRecipeBaseView: PostRecipeBaseView) {
        UIAlertController.showAlert(style: .alert, viewController: self, title: R.string.localizable.screen_post_recipe_alert_post_recipe_title(), message: nil, okButtonTitle: R.string.localizable.common_alert_ok_btn_ok(), cancelButtonTitle: R.string.localizable.common_alert_cancel_btn_cancel()) {
            HUD.show(.progress)
            if let kikurageUserID = LoginHelper.shared.kikurageUserID {
                self.viewModel.postRecipe(kikurageUserID: kikurageUserID)
            }
        }
    }

    func postRecipeBaseViewDidTappedCloseButton(_ postRecipeBaseView: PostRecipeBaseView) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITextField Delegate

extension PostRecipeViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == baseView.recipeNameTextField {
            if let text = textField.text {
                let resultText = (text as NSString).replacingCharacters(in: range, with: string)
                return resultText.count <= baseView.maxRecipeNameNumer
            }
        }
        return true
    }

    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text else {
            return
        }
        baseView.setCurrentRecipeNameNumber(text: text)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case baseView.dateTextField:
            setRecipeDateTextFieldData()
        case baseView.recipeNameTextField:
            setRecipeNameTextFieldData()
        default:
            break
        }
    }

    private func setRecipeDateTextFieldData() {
        let dateString = DateHelper.formatToString(date: baseView.datePicker.date)
        baseView.dateTextField.text = dateString
        viewModel.recipe.cookDate = dateString
    }

    private func setRecipeNameTextFieldData() {
        guard let recipeName = baseView.recipeNameTextField.text else {
            return
        }
        viewModel.recipe.name = recipeName
    }
}

// MARK: - UITextView Delegate

extension PostRecipeViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        var resultText = ""
        if let text = textView.text {
            resultText = (text as NSString).replacingCharacters(in: range, with: text)
        }
        return resultText.count <= baseView.maxRecipeMemoNumber
    }

    func textViewDidChange(_ textView: UITextView) {
        guard let text = textView.text else {
            return
        }
        baseView.recipeMemoTextView.switchPlaceholderDisplay(text: text)
        viewModel.recipe.memo = text
        baseView.setCurrentRecipeMemoNumber(text: text)
    }
}

// MARK: - CameraCell Delegate

extension PostRecipeViewController: CameraCellDelegate {
    func didTapImageCancelButton(cell: CameraCell) {
        let index = cell.tag
        cameraCollectionViewModel.cancelImage(index: index)
        baseView.cameraCollectionView.reloadItems(at: [IndexPath(row: index, section: 0)])
    }
}

// MARK: - UICollectionView Delegate

extension PostRecipeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        FirebaseAnalyticsHelper.sendTapEvent(.recipeImageButton)
        openImagePicker()
    }
}

// MARK: - UIImagePickerController Delegage

extension PostRecipeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        guard let selectedIndexPath = baseView.cameraCollectionView.indexPathsForSelectedItems?.first else {
            return
        }
        picker.dismiss(animated: true) { [weak self] in
            self?.cameraCollectionViewModel.setImage(selectedImage: originalImage, index: selectedIndexPath.item)
            self?.baseView.cameraCollectionView.reloadItems(at: [selectedIndexPath])
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

// MARK: - PostRecipeViewModel Delegate

extension PostRecipeViewController: PostRecipeViewModelDelegate {
    func postRecipeViewModelDidSuccessPostRecipe(_ postRecipeViewModel: PostRecipeViewModel) {
        // 選択した画像のみData型に変換する
        let postIamgeData: [Data?] = cameraCollectionViewModel.changeToImageData(compressionQuality: 0.3).filter { $0 != nil }
        // Firestoreにデータ登録後、そのdocumentIDをパスに使ってStorageへ画像を投稿する
        if let kikurageUserID = LoginHelper.shared.kikurageUserID {
            postRecipeViewModel.postRecipeImages(kikurageUserID: kikurageUserID, imageData: postIamgeData)
        }
    }

    func postRecipeViewModelDidFailedPostRecipe(_ postRecipeViewModel: PostRecipeViewModel, with errorMessage: String) {
        DispatchQueue.main.async {
            HUD.hide()
            UIAlertController.showAlert(style: .alert, viewController: self, title: errorMessage, message: nil, okButtonTitle: R.string.localizable.common_alert_ok_btn_ok(), cancelButtonTitle: nil, completionOk: nil)
        }
    }

    func postRecipeViewModelDidSuccessPostRecipeImages(_ postRecipeViewModel: PostRecipeViewModel) {
        DispatchQueue.main.async {
            HUD.hide()
            UIAlertController.showAlert(style: .alert, viewController: self, title: R.string.localizable.screen_post_recipe_alert_post_recipe_success_title(), message: nil, okButtonTitle: R.string.localizable.common_alert_ok_btn_ok(), cancelButtonTitle: nil) {
                NotificationCenter.default.post(name: .updatedRecipes, object: nil)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }

    func postRecipeViewModelDidFailedPostRecipeImages(_ postRecipeViewModel: PostRecipeViewModel, with errorMessage: String) {
        DispatchQueue.main.async {
            HUD.hide()
            UIAlertController.showAlert(style: .alert, viewController: self, title: errorMessage, message: nil, okButtonTitle: R.string.localizable.common_alert_ok_btn_ok(), cancelButtonTitle: nil, completionOk: nil)
        }
    }
}
