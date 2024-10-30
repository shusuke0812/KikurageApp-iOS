//
//  CommunicationBaseView.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2021/1/7.
//  Copyright © 2021 shusuke. All rights reserved.
//

import KikurageUI
import UIKit

protocol CommunicationBaseViewDelegate: AnyObject {
    func communicationBaseViewDidTapFacebookButton(_ communicationBaseView: CommunicationBaseView)
}

class CommunicationBaseView: UIView {
    private var imageView: UIImageView!
    private var informationView: KUIRoundedView!
    private var informationLabel: UILabel!
    private var facebookButton: UIButton!

    weak var delegate: CommunicationBaseViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupComponent()
        setupButtonAction()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Initialized

extension CommunicationBaseView {
    private func setupComponent() {
        backgroundColor = .systemGroupedBackground

        imageView = UIImageView(image: R.image.communication())
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false

        informationView = KUIRoundedView(props: KUIRoundedViewProps())
        informationView.translatesAutoresizingMaskIntoConstraints = false

        informationLabel = UILabel()
        informationLabel.textAlignment = .natural
        informationLabel.numberOfLines = 0
        informationLabel.text = R.string.localizable.screen_communication_information()
        informationLabel.translatesAutoresizingMaskIntoConstraints = false

        facebookButton = UIButton()
        facebookButton.setImage(R.image.facebookButton(), for: .normal)
        facebookButton.translatesAutoresizingMaskIntoConstraints = false

        informationView.addSubview(informationLabel)
        addSubview(imageView)
        addSubview(informationView)
        addSubview(facebookButton)

        NSLayoutConstraint.activate([
            informationLabel.topAnchor.constraint(equalTo: informationView.topAnchor, constant: 10),
            informationLabel.leadingAnchor.constraint(equalTo: informationView.leadingAnchor, constant: 15),
            informationLabel.trailingAnchor.constraint(equalTo: informationView.trailingAnchor, constant: -15),
            informationLabel.bottomAnchor.constraint(equalTo: informationView.bottomAnchor, constant: -10)
        ])

        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1),
            imageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 30),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50),

            informationView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            informationView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            informationView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            facebookButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            facebookButton.topAnchor.constraint(equalTo: informationView.bottomAnchor, constant: 30),
            facebookButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }

    private func setupButtonAction() {
        facebookButton.addAction(.init { [weak self] _ in
            guard let self else {
                return
            }
            self.delegate?.communicationBaseViewDidTapFacebookButton(self)
        }, for: .touchUpInside)
    }
}
