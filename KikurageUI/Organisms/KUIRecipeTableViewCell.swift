//
//  KUIRecipeTableViewCell.swift
//  KikurageUI
//
//  Created by Shusuke Ota on 2024/10/31.
//  Copyright © 2024 shusuke. All rights reserved.
//

import FirebaseStorageUI
import UIKit

public struct KUIRecipeTableViewCellProps {
    let imageStoragePath: String
    let dateString: String
    let title: String
    let description: String

    public init(imageStoragePath: String, dateString: String, title: String, description: String) {
        self.imageStoragePath = imageStoragePath
        self.dateString = dateString
        self.title = title
        self.description = description
    }
}

public class KUIRecipeTableViewCell: UITableViewCell {
    private var recipeImageView: KUIImageView!
    private var dateLabel: UILabel!
    private var titleLabel: UILabel!
    private var descriptionLabel: UILabel!

    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupComponent()
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func updateItem(props: KUIRecipeTableViewCellProps) {
        dateLabel.text = props.dateString
        titleLabel.text = props.title
        descriptionLabel.text = props.description

        let storageReference = Storage.storage().reference(withPath: props.imageStoragePath)
        recipeImageView.sd_setImage(with: storageReference, placeholderImage: nil)
    }

    private func setupComponent() {
        recipeImageView = KUIImageView(props: KUIImageViewProps(
            image: nil
        ))
        recipeImageView.translatesAutoresizingMaskIntoConstraints = false

        dateLabel = UILabel()
        dateLabel.text = "-"
        dateLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false

        titleLabel = UILabel()
        titleLabel.text = "-"
        titleLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        descriptionLabel = UILabel()
        descriptionLabel.text = "-"
        descriptionLabel.numberOfLines = 0
        descriptionLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

        let stackView = UIStackView(arrangedSubviews: [
            dateLabel,
            titleLabel,
            descriptionLabel
        ])
        stackView.spacing = 10
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(recipeImageView)
        contentView.addSubview(stackView)

        NSLayoutConstraint.activate([
            recipeImageView.widthAnchor.constraint(equalToConstant: 160),
            recipeImageView.heightAnchor.constraint(equalToConstant: 160),

            recipeImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            recipeImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            recipeImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),

            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: recipeImageView.trailingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
}
