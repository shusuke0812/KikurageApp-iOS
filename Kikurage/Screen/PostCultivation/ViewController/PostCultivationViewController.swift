//
//  PostCultivationViewController.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2020/11/14.
//  Copyright © 2020 shusuke. All rights reserved.
//

import KikurageUI
import PKHUD
import UIKit

class PostCultivationViewController: UIViewController, UIViewControllerNavigatable {
    private var baseView: PostCultivationBaseView = .init()
    private var viewModel: PostCultivationViewModel!
    private var cameraCollectionViewModel: KUISelectImageCollectionViewModel!

    // MARK: - Lifecycle

    override func loadView() {
        view = baseView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = PostCultivationViewModel(cultivationRepository: CultivationRepository())
        cameraCollectionViewModel = KUISelectImageCollectionViewModel(
            selectedImageMaxNumber: Constants.CameraCollectionCell.maxNumber,
            collectionViewDelegate: self
        )
        setDelegateDataSource()
        setNavigation()
        adjustNavigationBarBackgroundColor()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        FirebaseAnalyticsHelper.sendScreenViewEvent(.postCultivation)
    }

    // MARK: - Action

    @objc private func close(_ sender: UIBarButtonItem) {
        presentingViewController?.dismiss(animated: true)
    }
}

// MARK: - Initialized

extension PostCultivationViewController {
    private func setDelegateDataSource() {
        baseView.delegate = self
        baseView.configCollectionView(delegate: self, dataSource: cameraCollectionViewModel)
        viewModel.delegate = self
    }

    private func setNavigation() {
        let closeButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(close(_:)))
        navigationItem.rightBarButtonItems = [closeButtonItem]
        navigationItem.title = R.string.localizable.screen_post_cultivation_title()
    }
}

// MARK: - PostCultivatioBaseView Delegate

extension PostCultivationViewController: PostCultivationBaseViewDelegate {
    func postCultivationBaseViewDidEndEditingCultivationMemo(_ postCultivationBaseView: PostCultivationBaseView, text: String) {
        viewModel.cultivation.memo = text
    }

    func postCultivationBaseViewDidEndEditingCultivationDate(_ postCultivationBaseView: PostCultivationBaseView, date: Date) {
        viewModel.cultivation.viewDate = DateHelper.formatToString(date: date)
    }

    func postCultivationBaseViewDidTappedPostButton(_ postCultivationBaseView: PostCultivationBaseView) {
        if viewModel.postValidation() {
            UIAlertController.showAlert(style: .alert, viewController: self, title: R.string.localizable.screen_post_cultivation_alert_post_cultivation_title(), message: nil, okButtonTitle: R.string.localizable.common_alert_ok_btn_ok(), cancelButtonTitle: R.string.localizable.common_alert_cancel_btn_cancel()) {
                // HUD表示（始）
                HUD.show(.progress)
                if let kikurageUserID = LoginHelper.shared.kikurageUserID {
                    self.viewModel.postCultivation(kikurageUserID: kikurageUserID)
                }
            }
        } else {
            UIAlertController.showAlert(style: .alert, viewController: self, title: R.string.localizable.screen_post_cultivation_valid_view_date(), message: nil, okButtonTitle: R.string.localizable.common_alert_ok_btn_ok(), cancelButtonTitle: nil, completionOk: nil)
        }
    }
}

// MARK: - CameraCell Delegate

extension PostCultivationViewController: KUISelectImageCollectionViewCellDelegate {
    func didTapImageCancelButton(cell: KUISelectImageCollectionViewCell) {
        let index = cell.tag
        cameraCollectionViewModel.cancelImage(index: index)
        baseView.cameraCollectionView.reloadItems(at: [IndexPath(row: index, section: 0)])
    }
}

// MARK: - PostCultivationViewModel Delegate

extension PostCultivationViewController: PostCultivationViewModelDelegate {
    func postCultivationViewModelDidSuccessPostCultivation(_ postCultivationViewModel: PostCultivationViewModel) {
        // nil要素を取り除いた選択した画像のみのData型に変換する
        let postImageData: [Data?] = cameraCollectionViewModel.changeToImageData(compressionQuality: 0.3).filter { $0 != nil }
        // Firestoreにデータ登録後、そのdocumentIDをパスに使ってStorageへ画像を投稿する
        if let kikurageUserID = LoginHelper.shared.kikurageUserID {
            viewModel.postCultivationImages(kikurageUserID: kikurageUserID, imageData: postImageData)
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
        FirebaseAnalyticsHelper.sendTapEvent(.cultivationImageButton)
        openImagePicker()
    }
}

// MARK: - UIImagePickerController Delegate

extension PostCultivationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
