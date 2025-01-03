//
//  KUILoadingThumbnailView.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2024/12/14.
//  Copyright © 2024 shusuke. All rights reserved.
//

import UIKit

public struct KUILoadingThumbnailViewProps {
    let thumbnailText: String

    public init(thumbnailText: String) {
        self.thumbnailText = thumbnailText
    }
}

public class KUILoadingThumbnailView: UIView {
    private var thumbnailLabel: UILabel!

    public init(props: KUILoadingThumbnailViewProps) {
        super.init(frame: .zero)
        setupComponent(props: props)
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupComponent(props: KUILoadingThumbnailViewProps) {
        backgroundColor = .systemGray4
        translatesAutoresizingMaskIntoConstraints = false

        thumbnailLabel = UILabel()
        thumbnailLabel.text = props.thumbnailText
        thumbnailLabel.textColor = .white
        thumbnailLabel.textAlignment = .center
        thumbnailLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        thumbnailLabel.translatesAutoresizingMaskIntoConstraints = false

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
