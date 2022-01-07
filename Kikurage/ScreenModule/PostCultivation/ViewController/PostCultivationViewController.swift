//
//  PostCultivationViewController.swift
//  Kikurage
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
        adjustNavigationBarBackgroundColor()
    }
}

// MARK: - Initialized

extension PostCultivationViewController {
    private func setDelegateDataSource() {
        baseView.delegate = self
        baseView.configTextView(delegate: self)
        baseView.configTextView(delegate: self)
        baseView.configCollectionView(delegate: self, dataSource: cameraCollectionViewModel)
        cameraCollectionViewModel.cameraCellDelegate = self
        viewModel.delegate = self
    }
}

// MARK: - PostCultivatioBaseView Delegate

extension PostCultivationViewController: PostCultivationBaseViewDelegate {
    func postCultivationBaseViewDidTappedPostButton(_ postCultivationBaseView: PostCultivationBaseView) {
        UIAlertController.showAlert(style: .alert, viewController: self, title: R.string.localizable.screen_post_cultivation_alert_post_cultivation_title(), message: nil, okButtonTitle: R.string.localizable.common_alert_ok_btn_ok(), cancelButtonTitle: R.string.localizable.common_alert_cancel_btn_cancel()) {
            // HUD表示（始）
            HUD.show(.progress)
            if let kikurageUserId = LoginHelper.shared.kikurageUserId {
                self.viewModel.postCultivation(kikurageUserId: kikurageUserId)
            }
        }
    }
    func postCultivationBaseViewDidTappedCloseButton(_ postCultivationBaseView: PostCultivationBaseView) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITextField Delegate

extension PostCultivationViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        let dateString = DateHelper.formatToString(date: baseView.datePicker.date)
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
    func postCultivationViewModelDidSuccessPostCultivation(_ postCultivationViewModel: PostCultivationViewModel) {
        // nil要素を取り除いた選択した画像のみのData型に変換する
        let postImageData: [Data?] = cameraCollectionViewModel.changeToImageData(compressionQuality: 0.8).filter { $0 != nil }
        // Firestoreにデータ登録後、そのdocumentIDをパスに使ってStorageへ画像を投稿する
        if let kikurageUserId = LoginHelper.shared.kikurageUserId {
            viewModel.postCultivationImages(kikurageUserId: kikurageUserId, imageData: postImageData)
        }
    }
    func postCultivationViewModelDidFailedPostCultivation(_ postCultivationViewModel: PostCultivationViewModel, with errorMessage: String) {
        DispatchQueue.main.async {
            HUD.hide()
            UIAlertController.showAlert(style: .alert, viewController: self, title: errorMessage, message: nil, okButtonTitle: R.string.localizable.common_alert_ok_btn_ok(), cancelButtonTitle: nil, completionOk: nil)
        }
    }
    func postCultivationViewModelDidSuccessPostCultivationImages(_ postCultivationViewModel: PostCultivationViewModel) {
        DispatchQueue.main.async {
            HUD.hide()
            UIAlertController.showAlert(style: .alert, viewController: self, title: R.string.localizable.screen_post_cultivation_alert_post_cultivation_success_title(), message: nil, okButtonTitle: R.string.localizable.common_alert_ok_btn_ok(), cancelButtonTitle: nil) {
                NotificationCenter.default.post(name: .updatedCultivations, object: nil)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    func postCultivationViewModelDidFailedPostCultivationImages(_ postCultivationViewModel: PostCultivationViewModel, with errorMessage: String) {
        DispatchQueue.main.async {
            HUD.hide()
            UIAlertController.showAlert(style: .alert, viewController: self, title: errorMessage, message: nil, okButtonTitle: R.string.localizable.screen_post_cultivation_alert_post_cultivation_success_title(), cancelButtonTitle: nil, completionOk: nil)
        }
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
