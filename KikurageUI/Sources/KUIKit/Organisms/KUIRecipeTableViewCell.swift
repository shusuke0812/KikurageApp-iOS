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

public struct KUIRecipeCellProps {
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

public struct KUIRecipeCell: View {
    private let props: KUIRecipeCellProps
    @State private var imageURL: URL?

    public init(props: KUIRecipeCellProps) {
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
        KUIRecipeCell(props: KUIRecipeCellProps(
            imageStoragePath: "",
            dateString: "2024/01/01",
            title: "きくらげ炒め",
            description: "シンプルな塩炒めです。"
        ))
        .frame(height: 160)
    }
}
