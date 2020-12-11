//
//  PostCultivationViewController.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2020/11/14.
//  Copyright © 2020 shusuke. All rights reserved.
//

import UIKit

class PostCultivationViewController: UIViewController {
    /// BaseView
    private var baseView: PostCultivationBaseView { self.view as! PostCultivationBaseView}
    /// ViewModel
    private var viewModel: PostCultivationViewModel!
    /// CameraCell ViewModel
    private var cameraCollectionViewModel: CameraCollectionViewModel!
    /// きくらげユーザーID
    var kikurageUserId: String?
    
    private let dateHelper: DateHelper = DateHelper()
    
    // テスト用ID（後で消す）
    let userId: String = "i0GrcLgkBBoLrBgGtrjp"
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = PostCultivationViewModel(cultivationRepository: CultivationRepository())
        self.cameraCollectionViewModel = CameraCollectionViewModel(selectedImageMaxNumber: Constants.CameraCollectionCell.maxNumber)
        self.setDelegateDataSource()
    }
}
// MARK: - Initialized Method
extension PostCultivationViewController {
    private func setDelegateDataSource() {
        self.baseView.delegate = self
        self.baseView.dateTextField.delegate = self
        self.baseView.textView.delegate = self
        self.baseView.cameraCollectionView.delegate = self
        self.baseView.cameraCollectionView.dataSource = self.cameraCollectionViewModel
        self.cameraCollectionViewModel.cameraCellDelegate = self
        self.viewModel.delegate = self
    }
}
// MARK: - BaseView Delegate Method
extension PostCultivationViewController: PostCultivationBaseViewDelegate {
    func didTapPostButton() {
        UIAlertController.showAlert(style: .alert, viewController: self, title: "こちらの投稿内容で\n良いですか？", message: nil, okButtonTitle: "OK", cancelButtonTitle: "キャンセル ") {
            self.viewModel.postCultivation(kikurageUserId: self.userId)
        }
    }
    func didTapCloseButton() {
        self.dismiss(animated: true, completion: nil)
    }
}
// MARK: - UITextField Delegate Method
extension PostCultivationViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        let dateString = dateHelper.formatToString(date: self.baseView.datePicker.date)
        self.baseView.dateTextField.text = dateString
        self.viewModel.cultivation.viewDate = dateString
    }
}
// MARK: - UITextView Delegate Method
extension PostCultivationViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let resultTextNumber: String = (textView.text! as NSString).replacingCharacters(in: range, with: text)
        return resultTextNumber.count <= self.baseView.maxTextViewNumber
    }
    func textViewDidChange(_ textView: UITextView) {
        self.baseView.textView.switchPlaceholderDisplay(text: textView.text)
        self.viewModel.cultivation.memo = textView.text
        self.baseView.setCurrentTextViewNumber(text: textView.text)
    }
}
// MARK: - CameraCell Delegate Method
extension PostCultivationViewController: CameraCellDelegate {
    func didTapImageCancelButton(cell: CameraCell) {
        let index = cell.tag
        self.cameraCollectionViewModel.cancelImage(index: index)
        self.baseView.cameraCollectionView.reloadItems(at: [IndexPath(row: index, section: 0)])
    }
}
// MARK: - PostCultivationViewModel Delegate Method
extension PostCultivationViewController: PostCultivationViewModelDelegate {
    func didSuccessPostCultivation() {
        // nil要素を取り除いた選択した画像のみのData型に変換する
        let postImageData: [Data?] = self.cameraCollectionViewModel.changeToImageData(compressionQuality: 0.8).filter{ $0 != nil }
        // Firestoreにデータ登録後、そのdocumentIDをパスに使ってStorageへ画像を投稿する
        self.viewModel.postCultivationImages(kikurageUserId: self.userId, imageData: postImageData, firestoreDocumentId: self.viewModel.postedCultivationDocumentId!)
    }
    func didFailedPostCultivation(errorMessage: String) {
        print(errorMessage)
    }
    func didSuccessPostCultivationImages() {
        UIAlertController.showAlert(style: .alert, viewController: self, title: "画像を保存しました", message: nil, okButtonTitle: "OK", cancelButtonTitle: nil, completionOk: nil)
    }
    func didFailedPostCultivationImages(errorMessage: String) {
        print(errorMessage)
    }
}
// MARK: - UICollectionView Delegate Method
extension PostCultivationViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.openImagePicker()
    }
}
// MARK: - UIImagePickerController Delegate Method
extension PostCultivationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        guard let selectedIndexPath = self.baseView.cameraCollectionView.indexPathsForSelectedItems?.first else { return }
        picker.dismiss(animated: true, completion: { [weak self] in
            self?.cameraCollectionViewModel.setImage(selectedImage: originalImage, index: selectedIndexPath.item)
            self?.baseView.cameraCollectionView.reloadItems(at: [selectedIndexPath])
        })
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
