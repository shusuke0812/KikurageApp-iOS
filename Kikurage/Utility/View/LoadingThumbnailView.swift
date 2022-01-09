//
//  LoadingThumbnailView.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2022/1/8.
//  Copyright © 2022 shusuke. All rights reserved.
//

import UIKit

class LoadingThumbnailView: UIView {
    private let thumbnailLabel: UILabel = {
        let label = UILabel()
        label.text = R.string.localizable.loading_thumbnail_view()
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        initUI()
    }
}

// MARK: - Initialized

extension LoadingThumbnailView {
    func initUI() {
        backgroundColor = .systemGray4
        translatesAutoresizingMaskIntoConstraints = false

        addSubview(thumbnailLabel)

        NSLayoutConstraint.activate([
            thumbnailLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            thumbnailLabel.centerYAnchor.constraint(equalTo: centerYAnchor),

            thumbnailLabel.topAnchor.constraint(equalTo: topAnchor),
            thumbnailLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            thumbnailLabel.rightAnchor.constraint(equalTo: rightAnchor),
            thumbnailLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
