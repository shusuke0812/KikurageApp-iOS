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
}

class DebugBaseView: UIView {
    private var forceRestartButton: UIButton!
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

        activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(forceRestartButton)
        addSubview(activityIndicatorView)

        NSLayoutConstraint.activate([
            forceRestartButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 30),
            forceRestartButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            forceRestartButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),

            activityIndicatorView.topAnchor.constraint(equalTo: forceRestartButton.bottomAnchor, constant: 50),
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
    }
}
