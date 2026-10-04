//
//  KUICultivationDetailDescriptionView.swift
//  KikurageUI
//
//  Created by Shusuke Ota on 2024/12/14.
//  Copyright © 2024 shusuke. All rights reserved.
//

import SwiftUI
import UIKit

public struct KUICultivationDetailDescriptionViewProps {
    let image: UIImage?
    let tittle: String
    let dateString: String
    let description: String

    public init(image: UIImage?, tittle: String, dateString: String, description: String) {
        self.image = image
        self.tittle = tittle
        self.dateString = dateString
        self.description = description
    }
}

@available(*, deprecated, renamed: "KCultivationDetailDescriptionView", message: "Need to change to SwiftUI")
public class KUICultivationDetailDescriptionView: UIView {
    private var iconImageView: KUICircleImageView!
    private var memoTitleLabel: UILabel!
    private var memoDateLabel: UILabel!
    private var memoDescriptionTextView: KUIRoundedTextView!

    private let iconImageWidth: CGFloat = 50

    public init(props: KUICultivationDetailDescriptionViewProps) {
        super.init(frame: .zero)
        setupComponent(props: props)
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func updateMemoDateLabel(dateString: String) {
        memoDateLabel.text = dateString
    }

    public func updateMemoDescription(text: String) {
        memoDescriptionTextView.updateDescription(text: text)
    }

    private func setupComponent(props: KUICultivationDetailDescriptionViewProps) {
        memoTitleLabel = UILabel()
        memoTitleLabel.text = props.tittle
        memoTitleLabel.font = .systemFont(ofSize: 17)

        memoDateLabel = UILabel()
        memoDateLabel.text = props.dateString
        memoDateLabel.font = .systemFont(ofSize: 14)
        memoDateLabel.textColor = .lightGray

        let childStackView = UIStackView()
        childStackView.axis = .vertical
        childStackView.spacing = 7
        childStackView.alignment = .fill
        childStackView.distribution = .fill
        childStackView.addArrangedSubview(memoTitleLabel)
        childStackView.addArrangedSubview(memoDateLabel)

        iconImageView = KUICircleImageView(props: KUICircleImageViewProps(
            image: props.image,
            width: iconImageWidth
        ))
        iconImageView.translatesAutoresizingMaskIntoConstraints = false

        let parentStackView = UIStackView()
        parentStackView.axis = .horizontal
        parentStackView.spacing = 15
        parentStackView.alignment = .fill
        parentStackView.distribution = .fill
        parentStackView.translatesAutoresizingMaskIntoConstraints = false

        parentStackView.addArrangedSubview(iconImageView)
        parentStackView.addArrangedSubview(childStackView)

        memoDescriptionTextView = KUIRoundedTextView(props: KUIRoundedTextViewProps(description: "-"))
        memoDescriptionTextView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(parentStackView)
        addSubview(memoDescriptionTextView)

        NSLayoutConstraint.activate([
            iconImageView.widthAnchor.constraint(equalToConstant: iconImageWidth),
            iconImageView.heightAnchor.constraint(equalToConstant: iconImageWidth)
        ])

        NSLayoutConstraint.activate([
            parentStackView.topAnchor.constraint(equalTo: topAnchor),
            parentStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            parentStackView.trailingAnchor.constraint(equalTo: trailingAnchor),

            memoDescriptionTextView.topAnchor.constraint(equalTo: parentStackView.bottomAnchor, constant: 25),
            memoDescriptionTextView.leadingAnchor.constraint(equalTo: leadingAnchor),
            memoDescriptionTextView.trailingAnchor.constraint(equalTo: trailingAnchor),
            memoDescriptionTextView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

public struct KCultivationDetailDescriptionViewProps {
    let image: UIImage?
    let title: String
    let dateString: String
    let description: String

    public init(
        image: UIImage?,
        title: String,
        dateString: String,
        description: String
    ) {
        self.image = image
        self.title = title
        self.dateString = dateString
        self.description = description
    }
}

public struct KCultivationDetailDescriptionView: View {
    private let props: KCultivationDetailDescriptionViewProps
    private let iconImageWidth: CGFloat = 50

    public init(props: KCultivationDetailDescriptionViewProps) {
        self.props = props
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 25) {
            HStack(spacing: 15) {
                KCircleImageView(props: KCircleImageViewProps(image: props.image, width: iconImageWidth))

                VStack(alignment: .leading, spacing: 7) {
                    Text(props.title)
                        .font(.system(size: 17))
                    Text(props.dateString)
                        .font(.system(size: 14))
                        .foregroundColor(Color(uiColor: .lightGray))
                }
            }

            KRoundedView {
                Text(props.description)
                    .font(.system(size: 17))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(15)
            }
            .frame(maxHeight: .infinity, alignment: .top)
        }
    }
}

#Preview {
    ZStack {
        Color(uiColor: .systemGroupedBackground)
            .ignoresSafeArea()
        KCultivationDetailDescriptionView(props: KCultivationDetailDescriptionViewProps(
            image: UIImage(systemName: "face.smiling"),
            title: "栽培メモ",
            dateString: "2024/01/01",
            description: "今日はきのこがよく育っていました。"
        ))
        .padding(.top, 25)
        .padding(.horizontal, 15)
    }
}
