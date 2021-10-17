//
//  PostCultivationViewController.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2020/11/14.
//  Copyright © 2020 shusuke. All rights reserved.
//

import UIKit
import PKHUD

class PostCultivationViewController: UIViewController, UIViewControllerNavigatable {
    private var baseView: PostCultivationBaseView { self.view as! PostCultivationBaseView } // swiftlint:disable:this force_cast
    private var viewModel: PostCultivationViewModel!
    private var cameraCollectionViewModel: CameraCollectionViewModel!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = PostCultivationViewModel(cultivationRepository: CultivationRepository())
        cameraCollectionViewModel = CameraCollectionViewModel(selectedImageMaxNumber: Constants.CameraCollectionCell.maxNumber)
        setDelegateDataSource()
    }
}
// MARK: - Initialized
extension PostCultivationViewController {
    private func setDelegateDataSource() {
        baseView.delegate = self
        baseView.dateTextField.delegate = self
        baseView.textView.delegate = self
        baseView.cameraCollectionView.delegate = self
        baseView.cameraCollectionView.dataSource = cameraCollectionViewModel
        cameraCollectionViewModel.cameraCellDelegate = self
        viewModel.delegate = self
    }
}
// MARK: - BaseView Delegate
extension PostCultivationViewController: PostCultivationBaseViewDelegate {
    func didTapPostButton() {
        UIAlertController.showAlert(style: .alert, viewController: self, title: "こちらの投稿内容で\n良いですか？", message: nil, okButtonTitle: "OK", cancelButtonTitle: "キャンセル ") {
            // HUD表示（始）
            HUD.show(.progress)
            if let kikurageUserId = LoginHelper.shared.kikurageUserId {
                self.viewModel.postCultivation(kikurageUserId: kikurageUserId)
            }
        }
    }
    func didTapCloseButton() {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
// MARK: - UITextField Delegate
extension PostCultivationViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        let dateString = DateHelper.shared.formatToString(date: baseView.datePicker.date)
        baseView.dateTextField.text = dateString
        viewModel.cultivation.viewDate = dateString
    }
}
// MARK: - UITextView Delegate
extension PostCultivationViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        var resultText = ""
        if let text = textView.text {
            resultText = (text as NSString).replacingCharacters(in: range, with: text)
        }
        return resultText.count <= baseView.maxTextViewNumber
    }
    func textViewDidChange(_ textView: UITextView) {
        guard let text = textView.text else { return }
        baseView.textView.switchPlaceholderDisplay(text: text)
        viewModel.cultivation.memo = text
        baseView.setCurrentTextViewNumber(text: text)
    }
}
// MARK: - CameraCell Delegate
extension PostCultivationViewController: CameraCellDelegate {
    func didTapImageCancelButton(cell: CameraCell) {
        let index = cell.tag
        cameraCollectionViewModel.cancelImage(index: index)
        baseView.cameraCollectionView.reloadItems(at: [IndexPath(row: index, section: 0)])
    }
}
// MARK: - PostCultivationViewModel Delegate
extension PostCultivationViewController: PostCultivationViewModelDelegate {
    func didSuccessPostCultivation() {
        // nil要素を取り除いた選択した画像のみのData型に変換する
        let postImageData: [Data?] = cameraCollectionViewModel.changeToImageData(compressionQuality: 0.8).filter { $0 != nil }
        // Firestoreにデータ登録後、そのdocumentIDをパスに使ってStorageへ画像を投稿する
        if let kikurageUserId = LoginHelper.shared.kikurageUserId {
            viewModel.postCultivationImages(kikurageUserId: kikurageUserId, imageData: postImageData)
        }
    }
    func didFailedPostCultivation(errorMessage: String) {
        print(errorMessage)
        HUD.hide()
        UIAlertController.showAlert(style: .alert, viewController: self, title: "栽培記録の登録に失敗しました", message: nil, okButtonTitle: "OK", cancelButtonTitle: nil, completionOk: nil)
    }
    func didSuccessPostCultivationImages() {
        HUD.hide()
        UIAlertController.showAlert(style: .alert, viewController: self, title: "栽培記録を保存しました", message: nil, okButtonTitle: "OK", cancelButtonTitle: nil) {
            // 栽培記録一覧画面へ更新イベントを通知
            NotificationCenter.default.post(name: .updatedCultivations, object: nil)
            self.dismiss(animated: true, completion: nil)
        }
    }
    func didFailedPostCultivationImages(errorMessage: String) {
        print(errorMessage)
        HUD.hide()
        UIAlertController.showAlert(style: .alert, viewController: self, title: "栽培記録の保存に失敗しました", message: nil, okButtonTitle: "OK", cancelButtonTitle: nil, completionOk: nil)
    }
}
// MARK: - UICollectionView Delegate
extension PostCultivationViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        openImagePicker()
    }
}
// MARK: - UIImagePickerController Delegate
extension PostCultivationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        guard let selectedIndexPath = baseView.cameraCollectionView.indexPathsForSelectedItems?.first else { return }
        picker.dismiss(animated: true) { [weak self] in
            self?.cameraCollectionViewModel.setImage(selectedImage: originalImage, index: selectedIndexPath.item)
            self?.baseView.cameraCollectionView.reloadItems(at: [selectedIndexPath])
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
