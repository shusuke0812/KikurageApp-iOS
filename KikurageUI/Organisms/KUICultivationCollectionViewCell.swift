//
//  KUICultivationCollectionViewCell.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2024/12/8.
//  Copyright © 2024 shusuke. All rights reserved.
//

import FirebaseStorageUI
import UIKit

public class KUICultivationCollectionViewCell: UICollectionViewCell {
    public static let identifier = "CultivationCollectionViewCell"

    private var loadingThumbnailView: KUILoadingThumbnailView!
    private var imageView: KUIImageView!
    private var viewDateLabel: UILabel!

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupComponent()
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func setImage(imageStoragePath: String?) {
        if let imageStoragePath = imageStoragePath, !imageStoragePath.isEmpty {
            let storageReference = Storage.storage().reference(withPath: imageStoragePath)
            imageView.sd_setImage(with: storageReference, placeholderImage: nil) { _, error, _, _ in
                if let error = error {
                    return
                }
            }
        }
    }

    public func setViewDate(dateString: String) {
        viewDateLabel.text = dateString
    }

    private func setupComponent() {
        clipsToBounds = true
        layer.cornerRadius = .viewCornerRadius

        loadingThumbnailView = KUILoadingThumbnailView(props: KUILoadingThumbnailViewProps(
            thumbnailText: "読み込み中..." // TODO: localize
        ))
        loadingThumbnailView.translatesAutoresizingMaskIntoConstraints = false

        imageView = KUIImageView(props: KUIImageViewProps(image: nil))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false

        viewDateLabel = UILabel()
        viewDateLabel.text = "-"
        viewDateLabel.font = .systemFont(ofSize: 18, weight: .bold)
        viewDateLabel.textAlignment = .center
        viewDateLabel.textColor = .white
        viewDateLabel.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(loadingThumbnailView)
        contentView.addSubview(imageView)
        contentView.addSubview(viewDateLabel)

        NSLayoutConstraint.activate([
            loadingThumbnailView.topAnchor.constraint(equalTo: contentView.topAnchor),
            loadingThumbnailView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            loadingThumbnailView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            loadingThumbnailView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            viewDateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            viewDateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            viewDateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
}
