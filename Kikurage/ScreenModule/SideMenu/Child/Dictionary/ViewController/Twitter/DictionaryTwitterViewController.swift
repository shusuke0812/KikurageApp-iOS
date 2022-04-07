//
//  DictionaryTwitterViewController.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2022/4/2.
//  Copyright © 2022 shusuke. All rights reserved.
//

import UIKit

class DictionaryTwitterViewController: UIViewController {
    private var baseView: DictionaryTwitterBaseView { self.view as! DictionaryTwitterBaseView } // swiftlint:disable:this force_cast
    private var viewModel: DictionaryTwitterViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = DictionaryTwitterViewModel(twitterSearchRepository: TwitterSearchRepository())
        viewModel.delegate = self
        baseView.configTableView(delegate: self, dataSource: viewModel)

        loadTweets()
    }
}

// MARK: - WebAPI

extension DictionaryTwitterViewController {
    private func loadTweets() {
        baseView.startLoadingIndicator()
        viewModel.loadTweets()
    }
}

// MARK: - UITableViewDelegate

extension DictionaryTwitterViewController: UITableViewDelegate {
}

// MARK: - DictionaryTwitterViewModelDelegate

extension DictionaryTwitterViewController: DictionaryTwitterViewModelDelegate {
    func dictionaryTwitterViewModelDidSuccessGetTweets(_ dictionaryTwitterViewModel: DictionaryTwitterViewModel) {
        DispatchQueue.main.async {
            self.baseView.stopLoadingIndicator()
            self.baseView.showTweetsEmptyView(isEmpty: dictionaryTwitterViewModel.tweets.isEmpty)
            self.baseView.tableView.reloadData()
        }
    }
    func dictionaryTwitterViewModelDidFailedGetTweets(_ dictionaryTwitterViewModel: DictionaryTwitterViewModel, with errorMessage: String) {
        DispatchQueue.main.async {
            self.baseView.stopLoadingIndicator()
            UIAlertController.showAlert(style: .alert, viewController: self, title: errorMessage, message: nil, okButtonTitle: R.string.localizable.common_alert_ok_btn_ok(), cancelButtonTitle: nil) { [weak self] in
                self?.baseView.showTweetsEmptyView(isEmpty: dictionaryTwitterViewModel.tweets.isEmpty)
            }
        }
    }
}
