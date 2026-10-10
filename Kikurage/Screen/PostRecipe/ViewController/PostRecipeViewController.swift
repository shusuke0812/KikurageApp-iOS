//
//  PostRecipeViewController.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2020/12/28.
//  Copyright © 2020 shusuke. All rights reserved.
//

import KAAnalytics
import KSRecipeService
import UIKit

class PostRecipeViewController: UIViewController, UIViewControllerNavigatable {
    private var viewModel: PostRecipeViewModel!
    private var selectedImageSlotIndex: Int?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = PostRecipeViewModel(maxImageCount: Constants.CameraCollectionCell.maxNumber)
        viewModel.delegate = self

        let baseView = PostRecipeBaseView(delegate: self, state: viewModel.state)
        addBaseView(baseView: baseView)

        setNavigation()
        adjustNavigationBarBackgroundColor()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        FirebaseAnalyticsManager.sendScreenViewEvent(.postRecipe)
    }

    // MARK: - Action

    @objc private func close(_ sender: UIBarButtonItem) {
        presentingViewController?.dismiss(animated: true)
    }
}

// MARK: - Initialized

extension PostRecipeViewController {
    private func setNavigation() {
        let closeButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(close(_:)))
        navigationItem.rightBarButtonItems = [closeButtonItem]
        navigationItem.title = R.string.localizable.screen_post_recipe_title()
    }
}

// MARK: - PostRecipeBaseView Delegate

extension PostRecipeViewController: PostRecipeBaseViewDelegate {
    func postRecipeBaseViewDidTapImageSlot(at index: Int) {
        FirebaseAnalyticsManager.sendTapEvent(.recipeImageButton)
        selectedImageSlotIndex = index
        openImagePicker()
    }

    func postRecipeBaseViewDidTapPostButton() {
        viewModel.state.alert = .confirmPost
    }

    func postRecipeBaseViewDidConfirmPost() {
        viewModel.state.isPosting = true
        viewModel.postRecipe()
    }

    func postRecipeBaseViewDidConfirmPostSuccess() {
        NotificationCenter.default.post(name: .updatedRecipes, object: nil)
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - PostRecipeViewModel Delegate

extension PostRecipeViewController: PostRecipeViewModelDelegate {
    func postRecipeViewModelDidSuccessPostRecipe(_ postRecipeViewModel: PostRecipeViewModel) {
        viewModel.postRecipeImages()
    }

    func postRecipeViewModelDidFailedPostRecipe(_ postRecipeViewModel: PostRecipeViewModel, with errorMessage: String) {
        DispatchQueue.main.async {
            self.viewModel.state.isPosting = false
            self.viewModel.state.alert = .postFailed(message: errorMessage)
        }
    }

    func postRecipeViewModelDidSuccessPostRecipeImages(_ postRecipeViewModel: PostRecipeViewModel) {
        DispatchQueue.main.async {
            self.viewModel.state.isPosting = false
            self.viewModel.state.alert = .postSucceeded
        }
    }

    func postRecipeViewModelDidFailedPostRecipeImages(_ postRecipeViewModel: PostRecipeViewModel, with errorMessage: String) {
        DispatchQueue.main.async {
            self.viewModel.state.isPosting = false
            self.viewModel.state.alert = .postFailed(message: errorMessage)
        }
    }
}

// MARK: - UIImagePickerController Delegate

extension PostRecipeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
