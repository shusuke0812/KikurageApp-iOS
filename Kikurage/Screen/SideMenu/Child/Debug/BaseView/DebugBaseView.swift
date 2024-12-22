//
//  DebugBaseView.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2022/6/6.
//  Copyright © 2022 shusuke. All rights reserved.
//

import UIKit

protocol DebugBaseViewDelegate: AnyObject {
    func debugBaseViewDidTappedForceRestrart(_ debugBaseView: DebugBaseView)
    func debugBaseViewDidTappedKonashiFind(_ debugBaseView: DebugBaseView)
}

class DebugBaseView: UIView {
    private var forceRestartButton: UIButton!
    private var konashiFindButton: UIButton!
    private var konashiRSSILabel: UILabel!
    private var konashiPIOLabel: UILabel!
    private(set) var activityIndicatorView: UIActivityIndicatorView!

    weak var delegate: DebugBaseViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupComponent()
        setupAction()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupComponent() {
        backgroundColor = .white

        forceRestartButton = UIButton()
        forceRestartButton.setTitleColor(.systemBlue, for: .normal)
        forceRestartButton.setTitle("Force logout and restart app after 2min", for: .normal)
        forceRestartButton.translatesAutoresizingMaskIntoConstraints = false

        konashiFindButton = UIButton()
        konashiFindButton.setTitle("Find Konashi", for: .normal)
        konashiFindButton.layer.masksToBounds = true
        konashiFindButton.layer.cornerRadius = .buttonCornerRadius
        konashiFindButton.tintColor = .white
        konashiFindButton.backgroundColor = .systemBlue
        konashiFindButton.translatesAutoresizingMaskIntoConstraints = false

        konashiRSSILabel = UILabel()
        konashiRSSILabel.text = "RSSI: -"
        konashiRSSILabel.textAlignment = .center
        konashiRSSILabel.translatesAutoresizingMaskIntoConstraints = false

        konashiPIOLabel = UILabel()
        konashiPIOLabel.text = "- no PIO signal -"
        konashiPIOLabel.textAlignment = .center
        konashiPIOLabel.translatesAutoresizingMaskIntoConstraints = false

        activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(forceRestartButton)
        addSubview(konashiFindButton)
        addSubview(konashiRSSILabel)
        addSubview(konashiPIOLabel)
        addSubview(activityIndicatorView)

        NSLayoutConstraint.activate([
            forceRestartButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 30),
            forceRestartButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            forceRestartButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),

            konashiFindButton.heightAnchor.constraint(equalToConstant: 40),
            konashiFindButton.topAnchor.constraint(equalTo: forceRestartButton.bottomAnchor, constant: 40),
            konashiFindButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            konashiFindButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),

            konashiRSSILabel.heightAnchor.constraint(equalToConstant: 40),
            konashiRSSILabel.topAnchor.constraint(equalTo: konashiFindButton.bottomAnchor, constant: 30),
            konashiRSSILabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            konashiRSSILabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),

            konashiPIOLabel.topAnchor.constraint(equalTo: konashiRSSILabel.bottomAnchor, constant: 20),
            konashiPIOLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            konashiPIOLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),

            activityIndicatorView.topAnchor.constraint(equalTo: konashiPIOLabel.bottomAnchor, constant: 50),
            activityIndicatorView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            activityIndicatorView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30)
        ])
    }

    private func setupAction() {
        forceRestartButton.addAction(.init { [weak self] _ in
            guard let self else {
                return
            }
            self.delegate?.debugBaseViewDidTappedForceRestrart(self)
        }, for: .touchUpInside)

        konashiFindButton.addAction(.init { [weak self] _ in
            guard let self else {
                return
            }
            self.delegate?.debugBaseViewDidTappedKonashiFind(self)
        }, for: .touchUpInside)
    }
}

// MARK: - Cofig

extension DebugBaseView {
    func setRSSILabel(_ text: String) {
        konashiRSSILabel.text = "RSSI: " + "\(text)"
    }

    func setPIOLabel(_ text: String) {
        konashiPIOLabel.text = text
    }
}
