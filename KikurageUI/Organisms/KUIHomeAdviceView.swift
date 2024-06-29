//
//  KUIHomeAdviceView.swift
//  KikurageUI
//
//  Created by Shusuke Ota on 2024/6/16.
//  Copyright © 2024 shusuke. All rights reserved.
//

import UIKit

public struct KUIHomeAdviceViewProps {
    let title: String
    let description: String
    let image: UIImage?

    public init(
        title: String,
        description: String,
        image: UIImage? = nil
    ) {
        self.title = title
        self.description = description
        self.image = image
    }
}

public class KUIHomeAdviceView: UIView {
    private var contentView: KUIRoundedView!
    private var headerView: KUILabelWithImage!
    private var descriptionLabel: UILabel!

    public init(props: KUIHomeAdviceViewProps) {
        super.init(frame: .zero)
        setupComponent(props: props)
    }

    public required init?(coder: NSCoder) {
        nil
    }

    public func updateDescription(_ text: String) {
        descriptionLabel.text = text
    }

    private func setupComponent(props: KUIHomeAdviceViewProps) {
        contentView = KUIRoundedView(props: KUIRoundedViewProps())
        contentView.translatesAutoresizingMaskIntoConstraints = false

        headerView = KUILabelWithImage(props: KUILabelWithImageProps(
            variant: .imagePositionRight,
            title: props.title,
            iamge: props.image
        ))
        headerView.translatesAutoresizingMaskIntoConstraints = false

        descriptionLabel.text = props.description
        descriptionLabel.font = .systemFont(ofSize: 15)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(headerView)
        contentView.addSubview(descriptionLabel)
        addSubview(contentView)

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),

            headerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            headerView.leftAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),

            descriptionLabel.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 5),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
        ])
    }
}
