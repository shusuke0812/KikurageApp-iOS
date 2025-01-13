//
//  KUIDeviceStatusImageView.swift
//  KikurageUI
//
//  Created by Shusuke Ota on 2024/7/2.
//  Copyright © 2024 shusuke. All rights reserved.
//

import UIKit

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
