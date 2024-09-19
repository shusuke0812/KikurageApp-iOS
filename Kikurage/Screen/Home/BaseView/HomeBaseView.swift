//
//  HomeBaseView.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2020/10/21.
//  Copyright © 2020 shusuke. All rights reserved.
//

import KikurageUI
import UIKit

class HomeBaseView: UIView {
    private var nameLabel: UILabel!
    private var statusLabel: UILabel!

    private var statusParentView: UIView!
    private var statusImageView: KUIDeviceStatusImageView!
    private var nowTimeLabel: UILabel!

    private var statusListView: KUIDeviceStatusListView!
    private var homeAdviceView: KUIHomeAdviceView!
    private(set) var footerButtonView: KUIFooterButtonView!

    private var stateEmptyView: UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
        initFailedUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Initialized

extension HomeBaseView {
    private func initUI() {
        backgroundColor = .systemGroupedBackground

        nowTimeLabel = UILabel()
        nowTimeLabel.text = DateHelper.now()

        nameLabel = UILabel()
        nameLabel.text = ""

        statusLabel = UILabel()
        statusLabel.text = ""

        statusParentView = UIView()
        statusParentView.clipsToBounds = true
        statusParentView.layer.cornerRadius = .viewCornerRadius

        statusListView = KUIDeviceStatusListView(props: KUIDeviceStatusListViewProps(temperature: 0, humidity: 0))
        statusListView.translatesAutoresizingMaskIntoConstraints = false
    }

    private func initFailedUI() {
        stateEmptyView = UIView()
        stateEmptyView.backgroundColor = .white
        stateEmptyView.translatesAutoresizingMaskIntoConstraints = false

        let label = UILabel()
        label.text = R.string.localizable.common_read_error()
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false

        stateEmptyView.addSubview(label)

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: stateEmptyView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: stateEmptyView.centerYAnchor)
        ])
    }
}

// MARK: - Setting UI

extension HomeBaseView {
    func setKikurageStateUI(kikurageState: KikurageState?) {
        if let message = kikurageState?.message {
            statusLabel.text = message
        }
        if let type: KikurageStateType = kikurageState?.type {
            displayKikurageStateImage(type: type)
        } else {
            displayFailedKikurageStateImage()
        }
        if let temparature = kikurageState?.temperature, let humidity = kikurageState?.humidity {
            statusListView.updateStatus(temperature: temparature, humidity: humidity)
        }
        if let advice = kikurageState?.advice {
            homeAdviceView.updateDescription(advice)
        }
        #if PRODUCTION
            nowTimeLabel.isHidden = true
        #endif
    }

    func setKikurageNameUI(kikurageUser: KikurageUser?) {
        if let name = kikurageUser?.kikurageName {
            nameLabel.text = R.string.localizable.screen_home_kikurage_name(name)
        }
    }

    func updateTimeLabel() {
        nowTimeLabel.text = DateHelper.now()
    }

    private func displayKikurageStateImage(type: KikurageStateType) {
        stateEmptyView.removeFromSuperview()
        // 2つの画像を交互に表示する処理（アニメーションのSTOPはViewWillDisapperへ記載）
        statusImageView.runAnimation(images: KikurageStateHelper.setStateImage(type: type))
    }

    private func displayFailedKikurageStateImage() {
        statusImageView.addSubview(stateEmptyView)

        NSLayoutConstraint.activate([
            stateEmptyView.topAnchor.constraint(equalTo: statusImageView.topAnchor),
            stateEmptyView.leadingAnchor.constraint(equalTo: statusImageView.leadingAnchor),
            stateEmptyView.trailingAnchor.constraint(equalTo: statusImageView.trailingAnchor),
            stateEmptyView.bottomAnchor.constraint(equalTo: statusImageView.bottomAnchor)
        ])
    }
}

// MARK: - Animation

extension HomeBaseView {
    func kikurageStatusViewAnimation(_ animation: Bool) {
        (animation == true) ? statusImageView.startAnimating() : statusImageView.stopAnimating()
    }
}
