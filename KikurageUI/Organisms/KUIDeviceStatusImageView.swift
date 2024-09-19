//
//  KUIDeviceStatusImageView.swift
//  KikurageUI
//
//  Created by Shusuke Ota on 2024/7/2.
//  Copyright © 2024 shusuke. All rights reserved.
//

import KikurageDomain
import UIKit

public struct KUIDeviceStatusImageViewProps {
    let state: KikurageState
    let dateString: String

    public init(state: KikurageState, dateString: String) {
        self.state = state
        self.dateString = dateString
    }
    
    func setStateImages() -> [UIImage] {
        guard let type = state.type else {
            return []
        }
        var kikurageStateImages: [UIImage] = []
        let beforeImage = UIImage(named: "\(type.rawValue)_01")! // swiftlint:disable:this force_unwrapping
        let afterImage = UIImage(named: "\(type.rawValue)_02")! // swiftlint:disable:this force_unwrapping

        kikurageStateImages.append(beforeImage)
        kikurageStateImages.append(afterImage)

        return kikurageStateImages
    }
}

public class KUIDeviceStatusImageView: UIView {
    private var statusImageView: UIImageView!

    public init(props: KUIDeviceStatusImageViewProps) {
        super.init(frame: .zero)
        setupComponent(props: props)
    }

    public required init?(coder: NSCoder) {
        nil
    }

    public func runAnimation(props: KUIDeviceStatusImageViewProps) {
        statusImageView.animationImages = props.setStateImages()
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

    private func setupComponent(props: KUIDeviceStatusImageViewProps) {
        let parentView = KUIRoundedView()
        parentView.translatesAutoresizingMaskIntoConstraints = false

        statusImageView = UIImageView() // TODO: imageの設定
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
