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
    /// 栽培記録
    var cultivation: KikurageCultivation?
    
    private let dateHelper: DateHelper = DateHelper()
    
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
    private func initUI() {
        
    }
    private func setDelegateDataSource() {
        self.baseView.delegate = self
        self.baseView.dateTextField.delegate = self
        self.baseView.cameraCollectionView.delegate = self
        self.baseView.cameraCollectionView.dataSource = self.cameraCollectionViewModel
    }
}

// MARK: - BaseView Delegate Method
extension PostCultivationViewController: PostCultivationBaseViewDelegate {
    func didTapPostButton() {
    }
    func didTapCloseButton() {
        self.dismiss(animated: true, completion: nil)
    }
}
extension PostCultivationViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        let dateString = dateHelper.formatToString(date: self.baseView.datePicker.date)
        self.baseView.dateTextField.text = dateString
        //self.cultivation?.viewDate = dateString
    }
}
// MARK: - PostCultivationViewModel Delegate Method
extension PostCultivationViewController: PostCultivationViewModelDelegate {
    func didSuccessPostCultivation() {
        print("")
    }
    func didFailedPostCultivation(errorMessage: String) {
        print("")
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
            self?.cameraCollectionViewModel.setImageData(selectedImage: originalImage, index: selectedIndexPath.item)
            self?.baseView.cameraCollectionView.reloadItems(at: [selectedIndexPath])
        })
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
