//
//  KikurageTableViewHeaderView.swift
//  KikurageFeature
//
//  Created by Shusuke Ota on 2023/04/09.
//  Copyright © 2023 shusuke. All rights reserved.
//

import UIKit

public class KikurageTableViewHeaderView: UITableViewHeaderFooterView {
    private let titleLabel = UILabel()
    private let loadingIndicatorView = UIActivityIndicatorView()

    public var sectionNumber: Int = 0

    override public init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupComponents()
    }

    public required init?(coder: NSCoder) {
        nil
    }

    public static let indetifier: String = "KikurageTableViewHeaderView"

    public static func create(tableView: UITableView) -> KikurageTableViewHeaderView {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: Self.indetifier) as! KikurageTableViewHeaderView // swiftlint:disable:this force_cast
        return view
    }

    private func setupComponents() {
        titleLabel.font = .systemFont(ofSize: 14)
        titleLabel.textColor = .systemGray
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        loadingIndicatorView.isHidden = true
        loadingIndicatorView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(titleLabel)
        contentView.addSubview(loadingIndicatorView)

        let margin: CGFloat = 8

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: margin),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -margin),
            titleLabel.heightAnchor.constraint(equalToConstant: 30),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            loadingIndicatorView.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: margin),
            loadingIndicatorView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: margin),
            loadingIndicatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -margin),
            loadingIndicatorView.widthAnchor.constraint(equalToConstant: 14),
            loadingIndicatorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    public func startIndicatorAnimating() {
        loadingIndicatorView.isHidden = false
        loadingIndicatorView.startAnimating()
    }

    public func stopIndicatorAnimating() {
        loadingIndicatorView.isHidden = true
        loadingIndicatorView.stopAnimating()
    }

    public func setupTitleLabel(_ title: String) {
        titleLabel.text = title
    }
}
