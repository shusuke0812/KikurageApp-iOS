//
//  KUIRecipeTableViewCell.swift
//  KikurageUI
//
//  Created by Shusuke Ota on 2024/10/31.
//  Copyright © 2024 shusuke. All rights reserved.
//

import FirebaseStorage
import Kingfisher
import SwiftUI
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

@available(*, deprecated, renamed: "KRecipeCell", message: "Need to change to SwiftUI")
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

public struct KRecipeCellProps {
    let imageStoragePath: String
    let dateString: String
    let title: String
    let description: String

    public init(
        imageStoragePath: String,
        dateString: String,
        title: String,
        description: String
    ) {
        self.imageStoragePath = imageStoragePath
        self.dateString = dateString
        self.title = title
        self.description = description
    }
}

public struct KRecipeCell: View {
    private let props: KRecipeCellProps
    @State private var imageURL: URL?

    public init(props: KRecipeCellProps) {
        self.props = props
    }

    public var body: some View {
        HStack(alignment: .top, spacing: 10) {
            thumbnail
                .frame(width: 140, height: 140)
                .clipShape(RoundedRectangle(cornerRadius: .viewCornerRadius))

            VStack(alignment: .leading, spacing: 10) {
                Text(props.dateString)
                    .font(.system(size: 16))
                Text(props.title)
                    .font(.system(size: 16))
                Text(props.description)
                    .font(.system(size: 16))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(10)
        .onAppear {
            loadImageURL()
        }
    }

    @ViewBuilder
    private var thumbnail: some View {
        if let imageURL {
            GeometryReader { geometry in
                KFImage(imageURL)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()
            }
        } else {
            Color(uiColor: .systemGray4)
                .overlay(
                    Text(R.string.localizable.loading_text())
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                )
        }
    }

    private func loadImageURL() {
        guard !props.imageStoragePath.isEmpty else {
            return
        }
        let storageReference = Storage.storage().reference(withPath: props.imageStoragePath)
        storageReference.downloadURL { result in
            switch result {
            case .success(let url):
                imageURL = url
            case .failure:
                break
            }
        }
    }
}

#Preview {
    ZStack {
        Color(uiColor: .systemGroupedBackground)
            .ignoresSafeArea()
        KRecipeCell(props: KRecipeCellProps(
            imageStoragePath: "",
            dateString: "2024/01/01",
            title: "きくらげ炒め",
            description: "シンプルな塩炒めです。"
        ))
        .frame(height: 160)
    }
}
