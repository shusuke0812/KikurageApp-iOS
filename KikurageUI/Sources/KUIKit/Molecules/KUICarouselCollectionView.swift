//
//  KUICarouselCollectionView.swift
//  KikurageUI
//
//  Created by Shusuke Ota on 2024/12/14.
//  Copyright © 2024 shusuke. All rights reserved.
//

import SwiftUI

public struct KUICarouselViewProps {
    let imageStoragePaths: [String]
    let height: CGFloat

    public init(imageStoragePaths: [String], height: CGFloat = 320) {
        self.imageStoragePaths = imageStoragePaths
        self.height = height
    }
}

public struct KUICarouselView: View {
    private let props: KUICarouselViewProps
    @Binding private var currentPage: Int

    public init(props: KUICarouselViewProps, currentPage: Binding<Int>) {
        self.props = props
        _currentPage = currentPage
    }

    public var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $currentPage) {
                ForEach(Array(props.imageStoragePaths.enumerated()), id: \.offset) { index, path in
                    KUIZoomingImageView(props: KUIZoomingImageViewProps(imageStoragePath: path))
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: props.height)

            if props.imageStoragePaths.count > 1 {
                KCarouselPageIndicator(
                    numberOfPages: props.imageStoragePaths.count,
                    currentPage: currentPage
                )
                .padding(.vertical, 8)
            }
        }
    }
}

private struct KCarouselPageIndicator: View {
    let numberOfPages: Int
    let currentPage: Int

    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<numberOfPages, id: \.self) { index in
                Circle()
                    .fill(index == currentPage ? Color.gray : Color.white)
                    .frame(width: 7, height: 7)
            }
        }
    }
}

#Preview {
    KCarouselViewPreviewWrapper()
}

private struct KCarouselViewPreviewWrapper: View {
    @State private var currentPage = 0

    var body: some View {
        ZStack {
            Color(uiColor: .systemGroupedBackground)
                .ignoresSafeArea()
            KUICarouselView(
                props: KUICarouselViewProps(imageStoragePaths: ["", "", ""]),
                currentPage: $currentPage
            )
        }
    }
}
