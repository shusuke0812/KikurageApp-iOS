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

    private var statusImageParentView: UIView!
    private var statusImageView: KUIDeviceStatusImageView!
    private var statusEmptyView: UIView!
    private var nowTimeLabel: UILabel!

    private var statusListView: KUIDeviceStatusListView!
    private var homeAdviceView: KUIHomeAdviceView!

    private(set) var footerButtonView: KUIFooterButtonView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupComponent()
        setupErrorComponent()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Initialized

extension HomeBaseView {
    private func setupComponent() {
        backgroundColor = .systemGroupedBackground

        // Header
        nameLabel = UILabel()
        nameLabel.text = "-"
        nameLabel.font = .systemFont(ofSize: 26, weight: .bold)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        statusLabel = UILabel()
        statusLabel.text = "-"
        statusLabel.font = .systemFont(ofSize: 20)
        statusLabel.translatesAutoresizingMaskIntoConstraints = false

        // Status image
        statusImageParentView = UIView()
        statusImageParentView.clipsToBounds = true
        statusImageParentView.layer.cornerRadius = .viewCornerRadius
        statusImageParentView.translatesAutoresizingMaskIntoConstraints = false

        statusImageView = KUIDeviceStatusImageView()
        statusImageView.translatesAutoresizingMaskIntoConstraints = false

        nowTimeLabel = UILabel()
        nowTimeLabel.text = DateHelper.now()
        nowTimeLabel.font = .systemFont(ofSize: 11)
        nowTimeLabel.translatesAutoresizingMaskIntoConstraints = false

        // Status list
        statusListView = KUIDeviceStatusListView(props: KUIDeviceStatusListViewProps(
            temperature: 0, humidity: 0
        ))
        statusListView.translatesAutoresizingMaskIntoConstraints = false

        // Advice
        homeAdviceView = KUIHomeAdviceView(props: KUIHomeAdviceViewProps(title: "-", description: "-"))
        homeAdviceView.translatesAutoresizingMaskIntoConstraints = false

        // Footer
        footerButtonView = KUIFooterButtonView()
        footerButtonView.translatesAutoresizingMaskIntoConstraints = false

        statusImageParentView.addSubview(statusImageView)
        statusImageParentView.addSubview(nowTimeLabel)

        addSubview(nameLabel)
        addSubview(statusLabel)
        addSubview(statusImageParentView)
        addSubview(statusListView)
        addSubview(homeAdviceView)
        addSubview(footerButtonView)

        NSLayoutConstraint.activate([
            statusImageView.topAnchor.constraint(equalTo: statusImageParentView.topAnchor),
            statusImageView.leadingAnchor.constraint(equalTo: statusImageParentView.leadingAnchor),
            statusImageView.trailingAnchor.constraint(equalTo: statusImageParentView.trailingAnchor),
            statusImageView.bottomAnchor.constraint(equalTo: statusImageParentView.bottomAnchor)
        ])

        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            statusLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            statusLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            statusLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 16),

            statusImageParentView.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 15),
            statusImageParentView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            statusImageParentView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            statusImageParentView.heightAnchor.constraint(equalTo: statusImageParentView.widthAnchor, multiplier: 9.0 / 16.0),

            statusListView.heightAnchor.constraint(equalToConstant: 100),
            statusListView.topAnchor.constraint(equalTo: statusImageParentView.bottomAnchor, constant: 15),
            statusListView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            statusListView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            homeAdviceView.topAnchor.constraint(equalTo: statusListView.bottomAnchor, constant: 15),
            homeAdviceView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            homeAdviceView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            footerButtonView.heightAnchor.constraint(equalToConstant: 50),
            footerButtonView.topAnchor.constraint(equalTo: homeAdviceView.bottomAnchor, constant: 15),
            footerButtonView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            footerButtonView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            footerButtonView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }

    private func setupErrorComponent() {
        statusEmptyView = UIView()
        statusEmptyView.backgroundColor = .white
        statusEmptyView.translatesAutoresizingMaskIntoConstraints = false

        let label = UILabel()
        label.text = R.string.localizable.common_read_error()
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false

        statusEmptyView.addSubview(label)

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: statusEmptyView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: statusEmptyView.centerYAnchor)
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
        statusEmptyView.removeFromSuperview()
        // 2つの画像を交互に表示する処理（アニメーションのSTOPはViewWillDisapperへ記載）
        statusImageView.runAnimation(images: KikurageStateHelper.setStateImage(type: type))
    }

    private func displayFailedKikurageStateImage() {
        statusImageView.addSubview(statusEmptyView)

        NSLayoutConstraint.activate([
            statusEmptyView.topAnchor.constraint(equalTo: statusImageView.topAnchor),
            statusEmptyView.leadingAnchor.constraint(equalTo: statusImageView.leadingAnchor),
            statusEmptyView.trailingAnchor.constraint(equalTo: statusImageView.trailingAnchor),
            statusEmptyView.bottomAnchor.constraint(equalTo: statusImageView.bottomAnchor)
        ])
    }
}

// MARK: - Animation

extension HomeBaseView {
    func kikurageStatusViewAnimation(_ animation: Bool) {
        (animation == true) ? statusImageView.startAnimating() : statusImageView.stopAnimating()
    }
}
