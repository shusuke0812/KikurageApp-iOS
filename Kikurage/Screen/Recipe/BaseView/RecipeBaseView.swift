//
//  RecipeBaseView.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2020/12/27.
//  Copyright © 2020 shusuke. All rights reserved.
//

import KikurageUI
import UIKit

class RecipeBaseView: UIView {
    var onRefresh: (() -> Void)?

    private(set) var tableView: UITableView!
    private(set) var postPageButton: KUICircleButton!

    private let tableViewCellIdentifier = "recipe_cell"

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupComponent()
        setupRefreshControl()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupTableViewDelegate(delegate: UITableViewDelegate) {
        tableView.delegate = delegate
    }

    private func setupComponent() {
        backgroundColor = .systemGroupedBackground

        tableView = UITableView()
        tableView.backgroundColor = .systemGroupedBackground
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.register(KUIRecipeTableViewCell.self, forCellReuseIdentifier: tableViewCellIdentifier)
        tableView.tableFooterView = UIView()
        tableView.translatesAutoresizingMaskIntoConstraints = false

        postPageButton = KUICircleButton(props: KUICircleButtonProps(
            variant: .primary,
            image: R.image.addMemoButton(),
            width: 60
        ))
        postPageButton.translatesAutoresizingMaskIntoConstraints = false

        addSubview(tableView)
        addSubview(postPageButton)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),

            postPageButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            postPageButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }

    private func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addAction(.init { [weak self] _ in
            self?.onRefresh?()
        }, for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
}
