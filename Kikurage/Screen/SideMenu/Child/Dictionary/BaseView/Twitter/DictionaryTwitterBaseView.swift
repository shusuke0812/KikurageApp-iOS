//
//  DictionaryTwitterBaseView.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2022/4/2.
//  Copyright © 2022 shusuke. All rights reserved.
//

import KikurageUI
import UIKit

class DictionaryTwitterBaseView: UIView {
    private(set) var tableView: UITableView!
    private var loadingIndicatorView: UIActivityIndicatorView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupComponent()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupComponent() {
        tableView = UITableView()
        tableView.register(KUITweetTableViewCell.self, forCellReuseIdentifier: KUITweetTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false

        loadingIndicatorView = UIActivityIndicatorView()
        loadingIndicatorView.isHidden = true
        loadingIndicatorView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(tableView)
        addSubview(loadingIndicatorView)

        NSLayoutConstraint.activate([
            loadingIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor),

            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
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
}
