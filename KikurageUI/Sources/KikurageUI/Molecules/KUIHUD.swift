//
//  KUIHUD.swift
//  KikurageFeature
//
//  Created by Shusuke Ota on 2022/1/9.
//  Copyright © 2022 shusuke. All rights reserved.
//

import UIKit

public class KUIHUD: UIView {
    private var loadingImageView: UIImageView!
    private var loadingLabel: UILabel!

    private let loadingImageWidth: CGFloat = 60

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupComponent()
    }

    required init?(coder: NSCoder) {
        nil
    }
}

// MARK: - Config

extension KUIHUD {
    // Private

    private func setupComponent() {
        backgroundColor = .clear

        loadingImageView = UIImageView()
        loadingImageView.image = R.image.hakase()
        loadingImageView.contentMode = .scaleAspectFit
        loadingImageView.tintColor = .gray
        loadingImageView.translatesAutoresizingMaskIntoConstraints = false

        loadingLabel = UILabel()
        loadingLabel.text = R.string.localizable.loading_text()
        loadingLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        loadingLabel.textColor = .gray
        loadingLabel.textAlignment = .center
        loadingLabel.translatesAutoresizingMaskIntoConstraints = false

        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.contentMode = .scaleToFill
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false

        stackView.addArrangedSubview(loadingImageView)
        stackView.addArrangedSubview(loadingLabel)

        addSubview(stackView)

        NSLayoutConstraint.activate([
            loadingImageView.widthAnchor.constraint(equalToConstant: loadingImageWidth),
            loadingImageView.heightAnchor.constraint(equalToConstant: loadingImageWidth),

            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func makeCircleBorderToImageView() {
        loadingImageView.clipsToBounds = true
        loadingImageView.layer.cornerRadius = loadingImageWidth / 2
        loadingImageView.layer.borderWidth = 0.5
        loadingImageView.layer.borderColor = UIColor.gray.cgColor
    }

    // Public（MEMO: 色々なアニメーションを追加してみる）

    public func startFlashAnimation(duration: TimeInterval = 0.8, delay: TimeInterval = 0.0) {
        UIView.animate(withDuration: duration, delay: delay, options: .repeat, animations: { [weak self] in
            self?.alpha = 0.0
        }, completion: nil)
    }

    public func stopFlashAnimation() {
        layer.removeAllAnimations()
        alpha = 1.0
    }

    public enum RotateAxis: String {
        case x = "transform.rotation.x"
        case y = "transform.rotation.y"
        case z = "transform.rotation.z"
    }

    public func startRotateAnimation(duration: TimeInterval, rotateAxis: RotateAxis) {
        makeCircleBorderToImageView()

        let rotationAnimation = CABasicAnimation(keyPath: rotateAxis.rawValue)
        rotationAnimation.toValue = CGFloat(Double.pi / 180 * 360)
        rotationAnimation.duration = duration
        rotationAnimation.repeatCount = .infinity

        loadingImageView.layer.add(rotationAnimation, forKey: "rotationAnimation")
    }

    public func stopRotateAnimation() {
        layer.removeAllAnimations()
        removeFromSuperview()
    }
}
