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

public struct KUICultivationCellProps {
    let imageStoragePath: String?
    let viewDate: String

    public init(imageStoragePath: String?, viewDate: String) {
        self.imageStoragePath = imageStoragePath
        self.viewDate = viewDate
    }
}

public struct KUICultivationCell: View {
    private let props: KUICultivationCellProps
    @State private var imageURL: URL?

    public init(props: KUICultivationCellProps) {
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
            KUICultivationCell(props: KUICultivationCellProps(
                imageStoragePath: nil,
                viewDate: "2024/01/01"
            ))
            .frame(width: cellWidth, height: cellWidth)
            .padding(.cellSpacing)
        }
    }
}
