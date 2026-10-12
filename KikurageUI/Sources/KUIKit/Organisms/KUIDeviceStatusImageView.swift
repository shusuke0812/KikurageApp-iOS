//
//  KUIDeviceStatusImageView.swift
//  KikurageUI
//
//  Created by Shusuke Ota on 2024/7/2.
//  Copyright © 2024 shusuke. All rights reserved.
//

import SwiftUI

public struct KUIDeviceStatusImageViewProps {
    let images: [UIImage]
    let isAnimating: Bool
    let hasError: Bool

    public init(
        images: [UIImage],
        isAnimating: Bool,
        hasError: Bool
    ) {
        self.images = images
        self.isAnimating = isAnimating
        self.hasError = hasError
    }
}

public struct KUIDeviceStatusImageView: View {
    private let props: KUIDeviceStatusImageViewProps

    public init(props: KUIDeviceStatusImageViewProps) {
        self.props = props
    }

    public var body: some View {
        if props.hasError {
            Color.white
                .overlay(
                    Text(R.string.localizable.common_read_error())
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(Color(uiColor: .lightGray))
                )
        } else {
            animatedImageView
        }
    }

    @ViewBuilder
    private var animatedImageView: some View {
        if props.images.isEmpty {
            Color.white
        } else if props.isAnimating {
            TimelineView(.periodic(from: .now, by: frameDuration)) { context in
                image(at: frameIndex(for: context.date))
            }
        } else {
            image(at: 0)
        }
    }

    private var frameDuration: TimeInterval {
        1.0 / Double(props.images.count)
    }

    private func frameIndex(for date: Date) -> Int {
        let elapsed = date.timeIntervalSinceReferenceDate
        return Int(elapsed / frameDuration) % props.images.count
    }

    private func image(at index: Int) -> some View {
        GeometryReader { geometry in
            Image(uiImage: props.images[index])
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: geometry.size.width, height: geometry.size.height)
                .clipped()
        }
    }
}

#Preview("通常時") {
    GeometryReader { geometry in
        ZStack {
            Color(uiColor: .systemGroupedBackground)
                .ignoresSafeArea()
            KUIDeviceStatusImageView(props: KUIDeviceStatusImageViewProps(
                images: [UIImage(systemName: "face.smiling") ?? UIImage()],
                isAnimating: false,
                hasError: false
            ))
            .clipShape(RoundedRectangle(cornerRadius: .viewCornerRadius))
            .frame(
                width: geometry.size.width - 32,
                height: (geometry.size.width - 32) * 9.0 / 16.0
            )
            .padding(.top, 15)
            .padding(.horizontal, 16)
        }
    }
}

#Preview("エラー時") {
    GeometryReader { geometry in
        ZStack {
            Color(uiColor: .systemGroupedBackground)
                .ignoresSafeArea()
            KUIDeviceStatusImageView(props: KUIDeviceStatusImageViewProps(
                images: [],
                isAnimating: false,
                hasError: true
            ))
            .clipShape(RoundedRectangle(cornerRadius: .viewCornerRadius))
            .frame(
                width: geometry.size.width - 32,
                height: (geometry.size.width - 32) * 9.0 / 16.0
            )
            .padding(.top, 15)
            .padding(.horizontal, 16)
        }
    }
}
