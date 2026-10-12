//
//  KUISelectImageCollectionViewCell.swift
//  KikurageUI
//
//  Created by Shusuke Ota on 2024/11/7.
//  Copyright © 2024 shusuke. All rights reserved.
//

import SwiftUI

public struct KUISelectImageCellProps {
    let image: UIImage?

    public init(image: UIImage?) {
        self.image = image
    }
}

public struct KUISelectImageCell: View {
    private let props: KUISelectImageCellProps

    public init(props: KUISelectImageCellProps) {
        self.props = props
    }

    public var body: some View {
        GeometryReader { geometry in
            if let image = props.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()
            } else {
                Image(uiImage: UIImage(named: "camera") ?? UIImage())
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: geometry.size.width, height: geometry.size.height)
            }
        }
    }
}

public struct KUISelectImageGridViewProps {
    let cellSize: CGFloat
    let spacing: CGFloat

    public init(cellSize: CGFloat = 80, spacing: CGFloat = 10) {
        self.cellSize = cellSize
        self.spacing = spacing
    }
}

public struct KUISelectImageGridView: View {
    private let props: KUISelectImageGridViewProps
    @Binding private var selectedImages: [UIImage?]
    private let onTapSlot: (Int) -> Void

    public init(
        props: KUISelectImageGridViewProps = KUISelectImageGridViewProps(),
        selectedImages: Binding<[UIImage?]>,
        onTapSlot: @escaping (Int) -> Void
    ) {
        self.props = props
        _selectedImages = selectedImages
        self.onTapSlot = onTapSlot
    }

    public var body: some View {
        LazyVGrid(
            columns: [GridItem(.adaptive(minimum: props.cellSize, maximum: props.cellSize), spacing: props.spacing)],
            spacing: props.spacing
        ) {
            ForEach(selectedImages.indices, id: \.self) { index in
                KUISelectImageCell(props: KUISelectImageCellProps(image: selectedImages[index]))
                    .frame(width: props.cellSize, height: props.cellSize)
                    .onTapGesture {
                        if selectedImages[index] == nil {
                            onTapSlot(index)
                        }
                    }
                    .overlay(alignment: .bottomTrailing) {
                        Button(action: { selectedImages[index] = nil }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(Color(uiColor: .darkGray))
                        }
                        .frame(width: 20, height: 20)
                    }
            }
        }
    }
}

#Preview {
    KSelectImageGridViewPreviewWrapper()
}

private struct KSelectImageGridViewPreviewWrapper: View {
    @State private var selectedImages: [UIImage?] = Array(repeating: nil, count: 6)

    var body: some View {
        ZStack {
            Color(uiColor: .systemGroupedBackground)
                .ignoresSafeArea()
            KUISelectImageGridView(
                selectedImages: $selectedImages,
                onTapSlot: { _ in }
            )
            .padding()
        }
    }
}
