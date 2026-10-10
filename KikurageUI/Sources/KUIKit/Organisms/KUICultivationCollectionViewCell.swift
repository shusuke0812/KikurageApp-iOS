//
//  KUICultivationCollectionViewCell.swift
//  KikurageUI
//
//  Created by Shusuke Ota on 2024/12/8.
//  Copyright © 2024 shusuke. All rights reserved.
//

import FirebaseStorage
import Kingfisher
import SwiftUI
import UIKit

@available(*, deprecated, renamed: "KCultivationCell", message: "Need to change to SwiftUI")
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
            storageReference.downloadURL { [weak self] completion in
                switch completion {
                case .success(let url):
                    self?.imageView.kf.setImage(with: url, placeholder: nil)
                case .failure:
                    break
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
            thumbnailText: R.string.localizable.loading_text()
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

public struct KCultivationCellProps {
    let imageStoragePath: String?
    let viewDate: String

    public init(imageStoragePath: String?, viewDate: String) {
        self.imageStoragePath = imageStoragePath
        self.viewDate = viewDate
    }
}

public struct KCultivationCell: View {
    private let props: KCultivationCellProps
    @State private var imageURL: URL?

    public init(props: KCultivationCellProps) {
        self.props = props
    }

    public var body: some View {
        ZStack(alignment: .bottom) {
            if let imageURL {
                KFImage(imageURL)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                Color(uiColor: .systemGray4)
                    .overlay(
                        Text(R.string.localizable.loading_text())
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                    )
            }

            Text(props.viewDate)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)
                .padding(.horizontal, 8)
                .padding(.bottom, 8)
        }
        .clipShape(RoundedRectangle(cornerRadius: .viewCornerRadius))
        .onAppear {
            loadImageURL()
        }
    }

    private func loadImageURL() {
        guard let imageStoragePath = props.imageStoragePath, !imageStoragePath.isEmpty else {
            return
        }
        let storageReference = Storage.storage().reference(withPath: imageStoragePath)
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
    GeometryReader { geometry in
        let cellWidth = geometry.size.width / 2 - .cellSpacing * 2
        ZStack {
            Color(uiColor: .systemGroupedBackground)
                .ignoresSafeArea()
            KCultivationCell(props: KCultivationCellProps(
                imageStoragePath: nil,
                viewDate: "2024/01/01"
            ))
            .frame(width: cellWidth, height: cellWidth)
            .padding(.cellSpacing)
        }
    }
}
