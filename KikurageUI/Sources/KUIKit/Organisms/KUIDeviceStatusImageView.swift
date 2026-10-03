//
//  KUIDeviceStatusImageView.swift
//  KikurageUI
//
//  Created by Shusuke Ota on 2024/7/2.
//  Copyright © 2024 shusuke. All rights reserved.
//

import SwiftUI
import UIKit

@available(*, deprecated, renamed: "KDeviceStatusImageView", message: "Need to change to SwiftUI")
public class KUIDeviceStatusImageView: UIView {
    private var statusImageView: UIImageView!

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupComponent()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupComponent()
    }

    public func runAnimation(images: [UIImage]) {
        statusImageView.animationImages = images
        statusImageView.animationDuration = 1
        statusImageView.animationRepeatCount = 0
        statusImageView.startAnimating()
    }

    public func startAnimating() {
        statusImageView.startAnimating()
    }

    public func stopAnimating() {
        statusImageView.stopAnimating()
    }

    private func setupComponent() {
        let parentView = KUIRoundedView()
        parentView.translatesAutoresizingMaskIntoConstraints = false

        statusImageView = UIImageView()
        statusImageView.contentMode = .scaleAspectFill
        statusImageView.translatesAutoresizingMaskIntoConstraints = false

        parentView.addSubview(statusImageView)
        addSubview(parentView)

        NSLayoutConstraint.activate([
            statusImageView.topAnchor.constraint(equalTo: parentView.topAnchor),
            statusImageView.leadingAnchor.constraint(equalTo: parentView.leadingAnchor),
            statusImageView.trailingAnchor.constraint(equalTo: parentView.trailingAnchor),
            statusImageView.bottomAnchor.constraint(equalTo: parentView.bottomAnchor),

            parentView.topAnchor.constraint(equalTo: topAnchor),
            parentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            parentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            parentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

public struct KDeviceStatusImageViewProps {
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

public struct KDeviceStatusImageView: View {
    private let props: KDeviceStatusImageViewProps

    public init(props: KDeviceStatusImageViewProps) {
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
            KDeviceStatusImageView(props: KDeviceStatusImageViewProps(
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
            KDeviceStatusImageView(props: KDeviceStatusImageViewProps(
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
