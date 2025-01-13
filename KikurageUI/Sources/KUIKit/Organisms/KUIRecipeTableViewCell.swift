//
//  KUIRecipeTableViewCell.swift
//  KikurageUI
//
//  Created by Shusuke Ota on 2024/10/31.
//  Copyright © 2024 shusuke. All rights reserved.
//

import FirebaseStorage
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
    private var loadingThumbnailView: KUILoadingThumbnailView!
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
        storageReference.downloadURL { [weak self] completion in
            switch completion {
            case .success(let url):
                self?.recipeImageView.kf.setImage(with: url, placeholder: nil)
            case .failure:
                break
            }
        }
    }

    private func setupComponent() {
        loadingThumbnailView = KUILoadingThumbnailView(props: KUILoadingThumbnailViewProps(
            thumbnailText: R.string.localizable.loading_text()
        ))
        loadingThumbnailView.clipsToBounds = true
        loadingThumbnailView.layer.cornerRadius = .viewCornerRadius
        loadingThumbnailView.translatesAutoresizingMaskIntoConstraints = false

        recipeImageView = KUIImageView(props: KUIImageViewProps(
            image: nil
        ))
        recipeImageView.translatesAutoresizingMaskIntoConstraints = false

        dateLabel = UILabel()
        dateLabel.font = .systemFont(ofSize: 16)
        dateLabel.text = "-"
        dateLabel.translatesAutoresizingMaskIntoConstraints = false

        titleLabel = UILabel()
        titleLabel.text = "-"
        titleLabel.font = .systemFont(ofSize: 16)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        descriptionLabel = UILabel()
        descriptionLabel.text = "-"
        descriptionLabel.font = .systemFont(ofSize: 16)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

        loadingThumbnailView.addSubview(recipeImageView)
        contentView.addSubview(loadingThumbnailView)
        contentView.addSubview(dateLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)

        NSLayoutConstraint.activate([
            loadingThumbnailView.widthAnchor.constraint(equalToConstant: 160),
            loadingThumbnailView.heightAnchor.constraint(equalToConstant: 160),

            loadingThumbnailView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            loadingThumbnailView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            loadingThumbnailView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),

            recipeImageView.topAnchor.constraint(equalTo: loadingThumbnailView.topAnchor),
            recipeImageView.leadingAnchor.constraint(equalTo: loadingThumbnailView.leadingAnchor),
            recipeImageView.trailingAnchor.constraint(equalTo: loadingThumbnailView.trailingAnchor),
            recipeImageView.bottomAnchor.constraint(equalTo: loadingThumbnailView.bottomAnchor),

            dateLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            dateLabel.leadingAnchor.constraint(equalTo: loadingThumbnailView.trailingAnchor, constant: 10),
            dateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),

            titleLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: loadingThumbnailView.trailingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),

            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: loadingThumbnailView.trailingAnchor, constant: 10),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            descriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
}
