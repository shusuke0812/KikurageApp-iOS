//
//  PostRecipeViewController.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2020/12/28.
//  Copyright © 2020 shusuke. All rights reserved.
//

import UIKit
import PKHUD

class PostRecipeViewController: UIViewController {
    /// BaseView
    private var baseView: PostRecipeBaseView { self.view as! PostRecipeBaseView } // swiftlint:disable:this force_cast
    /// ViewModel
    private var viewModel: PostRecipeViewModel!
    /// CameraCell ViewModel
    private var cameraCollectionViewModel: CameraCollectionViewModel!
    /// Date型変換ヘルパー
    private let dateHelper = DateHelper()

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
        self.baseView.recipeMemoTextView.delegate = self
        self.baseView.cameraCollectionView.delegate = self
        self.baseView.cameraCollectionView.dataSource = self.cameraCollectionViewModel
        self.cameraCollectionViewModel.cameraCellDelegate = self
        self.viewModel.delegate = self
    }
}
// MARK: - BaseView Delegate Method
extension PostRecipeViewController: PostRecipeBaseViewDelegate {
    func didTapPostButton() {
        UIAlertController.showAlert(style: .alert, viewController: self, title: "こちらの投稿内容で\n良いですか", message: nil, okButtonTitle: "OK", cancelButtonTitle: "キャンセル") {
            // HUD表示（始）
            HUD.show(.progress)
            if let kikurageUserId = LoginHelper.kikurageUserId {
                self.viewModel.postRecipe(kikurageUserId: kikurageUserId)
            }
        }
    }
    func didTapCloseButton() {
        self.dismiss(animated: true, completion: nil)
    }
}
// MARK: - UITextField Delegate Method
extension PostRecipeViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.tag == Constants.TextFieldTag.recipeName {
            if let text = textField.text {
                let resultText = (text as NSString).replacingCharacters(in: range, with: string)
                return resultText.count <= self.baseView.maxRecipeNameNumer
            }
        }
        return true
    }
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text else { return }
        self.baseView.setCurrentRecipeNameNumber(text: text)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField.tag {
        case Constants.TextFieldTag.recipeDate:
            self.setRecipeDateTextFieldData()
        case Constants.TextFieldTag.recipeName:
            self.setRecipeNameTextFieldData()
        default:
            break
        }
    }
    private func setRecipeDateTextFieldData() {
        let dateString = self.dateHelper.formatToString(date: self.baseView.datePicker.date)
        self.baseView.dateTextField.text = dateString
        self.viewModel.recipe.cookDate = dateString
    }
    private func setRecipeNameTextFieldData() {
        guard let recipeName = self.baseView.recipeNameTextField.text else { return }
        self.viewModel.recipe.name = recipeName
    }
}
// MARK: - UITextView Delegate Method
extension PostRecipeViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        var resultText = ""
        if let text = textView.text {
            resultText = (text as NSString).replacingCharacters(in: range, with: text)
        }
        return resultText.count <= self.baseView.maxRecipeMemoNumber
    }
    func textViewDidChange(_ textView: UITextView) {
        guard let text = textView.text else { return }
        self.baseView.recipeMemoTextView.switchPlaceholderDisplay(text: text)
        self.viewModel.recipe.memo = text
        self.baseView.setCurrentRecipeMemoNumber(text: text)
    }
}
// MARK: - CameraCell Delegate Method
extension PostRecipeViewController: CameraCellDelegate {
    func didTapImageCancelButton(cell: CameraCell) {
        let index = cell.tag
        self.cameraCollectionViewModel.cancelImage(index: index)
        self.baseView.cameraCollectionView.reloadItems(at: [IndexPath(row: index, section: 0)])
    }
}
// MARK: - UICollectionView Delegate Method
extension PostRecipeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.openImagePicker()
    }
}
// MAARK: - UIImagePickerController Delegage Method
extension PostRecipeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        guard let selectedIndexPath = self.baseView.cameraCollectionView.indexPathsForSelectedItems?.first else { return }
        picker.dismiss(animated: true) { [weak self] in
            self?.cameraCollectionViewModel.setImage(selectedImage: originalImage, index: selectedIndexPath.item)
            self?.baseView.cameraCollectionView.reloadItems(at: [selectedIndexPath])
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
// MARK: - PostRecipeViewModel Method
extension PostRecipeViewController: PostRecipeViewModelDelegate {
    func didSuccessPostRecipe() {
        // nil要素を取り除き、選択した画像のみData型に変換する
        let postIamgeData: [Data?] = self.cameraCollectionViewModel.changeToImageData(compressionQuality: 0.5).filter { $0 != nil }
        // Firestoreにデータ登録後、そのdocumentIDをパスに使ってStorageへ画像を投稿する
        if let kikurageUserId = LoginHelper.kikurageUserId {
            self.viewModel.postRecipeImages(kikurageUserId: kikurageUserId, imageData: postIamgeData)
        }
    }
    func didFailedPostRecipe(errorMessage: String) {
        print(errorMessage)
        // HUD表示（終）
        HUD.hide()
        UIAlertController.showAlert(style: .alert, viewController: self, title: "料理記録の登録に失敗しました", message: nil, okButtonTitle: "OK", cancelButtonTitle: nil, completionOk: nil)
    }
    func didSuccessPostRecipeImages() {
        // HUD表示（終）
        HUD.hide()
        UIAlertController.showAlert(style: .alert, viewController: self, title: "栽培記録を保存しました", message: nil, okButtonTitle: "OK", cancelButtonTitle: nil) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    func didFailedPostRecipeImages(errorMessage: String) {
        print(errorMessage)
        // HUD表示（終）
        HUD.hide()
        UIAlertController.showAlert(style: .alert, viewController: self, title: "料理記録の登録に失敗しました", message: nil, okButtonTitle: "OK", cancelButtonTitle: nil, completionOk: nil)
    }
}
