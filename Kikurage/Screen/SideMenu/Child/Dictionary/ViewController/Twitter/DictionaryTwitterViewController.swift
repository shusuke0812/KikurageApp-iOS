//
//  DictionaryTwitterViewController.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2022/4/2.
//  Copyright © 2022 shusuke. All rights reserved.
//

import UIKit

class DictionaryTwitterViewController: UIViewController, UIViewControllerNavigatable {
    private var viewModel: DictionaryTwitterViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = DictionaryTwitterViewModel()
        viewModel.delegate = self

        let baseView = DictionaryTwitterBaseView(state: viewModel.state)
        let _ = addBaseView(baseView: baseView)

        loadTweets()
    }
}

// MARK: - WebAPI

extension DictionaryTwitterViewController {
    private func loadTweets() {
        viewModel.state.isLoading = true
        viewModel.loadTweets()
    }
}

// MARK: - DictionaryTwitterViewModelDelegate

extension DictionaryTwitterViewController: DictionaryTwitterViewModelDelegate {
    func dictionaryTwitterViewModelDidSuccessGetTweets(_ dictionaryTwitterViewModel: DictionaryTwitterViewModel) {
        DispatchQueue.main.async { [weak self] in
            self?.viewModel.state.isLoading = false
        }
    }

    func dictionaryTwitterViewModelDidFailedGetTweets(_ dictionaryTwitterViewModel: DictionaryTwitterViewModel, with errorMessage: String) {
        DispatchQueue.main.async { [weak self] in
            self?.viewModel.state.isLoading = false
            self?.viewModel.state.errorMessage = errorMessage
            self?.viewModel.state.hasError = true
        }
    }
}
