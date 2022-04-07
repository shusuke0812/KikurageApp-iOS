//
//  DictionaryTwitterBaseView.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2022/4/2.
//  Copyright © 2022 shusuke. All rights reserved.
//

import UIKit

class DictionaryTwitterBaseView: UIView {
    @IBOutlet private(set) weak var tableView: UITableView!
    @IBOutlet private weak var loadingIndicatorView: UIActivityIndicatorView!

    private let noTweetsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = .darkGray
        label.textAlignment = .center
        label.text = R.string.localizable.side_menu_dictionary_twitter_no_tweets()
        return label
    }()

    override func awakeFromNib() {
        super.awakeFromNib()

        tableView.register(R.nib.tweetTableViewCell)

        loadingIndicatorView.isHidden = true
    }
}

// MARK: - Config

extension DictionaryTwitterBaseView {
    func configTableView(delegate: UITableViewDelegate, dataSource: UITableViewDataSource) {
        tableView.delegate = delegate
        tableView.dataSource = dataSource
    }
    func startLoadingIndicator() {
        loadingIndicatorView.isHidden = false
        loadingIndicatorView.startAnimating()
    }
    func stopLoadingIndicator() {
        loadingIndicatorView.isHidden = true
        loadingIndicatorView.stopAnimating()
    }
    func showTweetsEmptyView(isEmpty: Bool) {
        if isEmpty {
            tableView.backgroundView = noTweetsLabel
        } else {
            tableView.backgroundView = nil
        }
    }
}
