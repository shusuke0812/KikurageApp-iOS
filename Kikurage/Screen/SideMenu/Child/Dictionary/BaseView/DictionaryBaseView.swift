//
//  DictionaryBaseView.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2022/3/30.
//  Copyright © 2022 shusuke. All rights reserved.
//

import UIKit
import WebKit

protocol DictionaryBaseViewDelegate: AnyObject {
    func dictionaryBaseView(_ dictionaryBaseView: DictionaryBaseView, didChangeSegmentedAt index: Int)
}

class DictionaryBaseView: UIView {
    private var segmentedControl: UISegmentedControl!
    private var containerView: UIView!

    weak var delegate: DictionaryBaseViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupComponent()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupComponent() {
        backgroundColor = .white

        segmentedControl = UISegmentedControl(items: [
            R.string.localizable.side_menu_dictionary_segment_title_trivia(),
            R.string.localizable.side_menu_dictionary_segment_title_twitter()
        ])
        segmentedControl.selectedSegmentIndex = .zero
        segmentedControl.addTarget(self, action: #selector(changeViews(_:)), for: .valueChanged)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false

        containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(segmentedControl)
        addSubview(containerView)

        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 8),
            segmentedControl.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            segmentedControl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),

            containerView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    @objc private func changeViews(_ sender: Any) {
        delegate?.dictionaryBaseView(self, didChangeSegmentedAt: segmentedControl.selectedSegmentIndex)
    }
}

// MARK: - Config

extension DictionaryBaseView {
    func addContainerView(_ view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false

        containerView.addSubview(view)

        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: containerView.topAnchor),
            view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }
}
