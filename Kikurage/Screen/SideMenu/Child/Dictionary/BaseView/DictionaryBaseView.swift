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
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var segmentedControl: UISegmentedControl!

    weak var delegate: DictionaryBaseViewDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        initUI()
    }

    // MARK: - Action

    @IBAction private func changeViews(_ sender: Any) {
        delegate?.dictionaryBaseView(self, didChangeSegmentedAt: segmentedControl.selectedSegmentIndex)
    }
}

// MARK: - Initialized

extension DictionaryBaseView {
    private func initUI() {
        segmentedControl.setTitle(R.string.localizable.side_menu_dictionary_segment_title_trivia(), forSegmentAt: 0)
        segmentedControl.setTitle(R.string.localizable.side_menu_dictionary_segment_title_twitter(), forSegmentAt: 1)
        segmentedControl.selectedSegmentIndex = .zero
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
