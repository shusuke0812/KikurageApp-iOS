//
//  PostCultivationViewController.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2020/11/14.
//  Copyright © 2020 shusuke. All rights reserved.
//

import KAAnalytics
import KSCultivationService
import UIKit

class PostCultivationViewController: UIViewController, UIViewControllerNavigatable {
    private var viewModel: PostCultivationViewModel!
    private var selectedImageSlotIndex: Int?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = PostCultivationViewModel(maxImageCount: Constants.CameraCollectionCell.maxNumber)
        viewModel.delegate = self

        let baseView = PostCultivationBaseView(delegate: self, state: viewModel.state)
        addBaseView(baseView: baseView)

        setNavigation()
        adjustNavigationBarBackgroundColor()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        FirebaseAnalyticsManager.sendScreenViewEvent(.postCultivation)
    }

    // MARK: - Action

    @objc private func close(_ sender: UIBarButtonItem) {
        presentingViewController?.dismiss(animated: true)
    }
}

// MARK: - Initialized

extension PostCultivationViewController {
    private func setNavigation() {
        let closeButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(close(_:)))
        navigationItem.rightBarButtonItems = [closeButtonItem]
        navigationItem.title = R.string.localizable.screen_post_cultivation_title()
    }
}

// MARK: - PostCultivationBaseView Delegate

extension PostCultivationViewController: PostCultivationBaseViewDelegate {
    func postCultivationBaseViewDidTapImageSlot(at index: Int) {
        FirebaseAnalyticsManager.sendTapEvent(.cultivationImageButton)
        selectedImageSlotIndex = index
        openImagePicker()
    }

    func postCultivationBaseViewDidTapPostButton() {
        if viewModel.postValidation() {
            viewModel.state.alert = .confirmPost
        } else {
            viewModel.state.alert = .validationFailed
        }
    }

    func postCultivationBaseViewDidConfirmPost() {
        viewModel.state.isPosting = true
        viewModel.postCultivation()
    }

    func postCultivationBaseViewDidConfirmPostSuccess() {
        NotificationCenter.default.post(name: .updatedCultivations, object: nil)
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - PostCultivationViewModel Delegate

extension PostCultivationViewController: PostCultivationViewModelDelegate {
    func postCultivationViewModelDidSuccessPostCultivation(_ postCultivationViewModel: PostCultivationViewModel) {
        viewModel.postCultivationImages()
    }

    func postCultivationViewModelDidFailedPostCultivation(_ postCultivationViewModel: PostCultivationViewModel, with errorMessage: String) {
        DispatchQueue.main.async {
            self.viewModel.state.isPosting = false
            self.viewModel.state.alert = .postFailed(message: errorMessage)
        }
    }

    func postCultivationViewModelDidSuccessPostCultivationImages(_ postCultivationViewModel: PostCultivationViewModel) {
        DispatchQueue.main.async {
            self.viewModel.state.isPosting = false
            self.viewModel.state.alert = .postSucceeded
        }
    }

    func postCultivationViewModelDidFailedPostCultivationImages(_ postCultivationViewModel: PostCultivationViewModel, with errorMessage: String) {
        DispatchQueue.main.async {
            self.viewModel.state.isPosting = false
            self.viewModel.state.alert = .postFailed(message: errorMessage)
        }
    }
}

// MARK: - UIImagePickerController Delegate

extension PostCultivationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        guard let selectedImageSlotIndex else {
            return
        }
        picker.dismiss(animated: true) { [weak self] in
            self?.viewModel.state.selectedImages[selectedImageSlotIndex] = originalImage
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
