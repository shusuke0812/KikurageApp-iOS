//
//  KUICultivationDetailDescriptionView.swift
//  KikurageUI
//
//  Created by Shusuke Ota on 2024/12/14.
//  Copyright © 2024 shusuke. All rights reserved.
//

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

public class KUICultivationDetailDescriptionView: UIView {
    private var iconImageView: KUICircleImageView!
    private var memoTitleLabel: UILabel!
    private var memoDateLabel: UILabel!
    private var memoDescriptionView: KUIRoundedTextView!

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
        memoDescriptionView.updateDescription(text: text)
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
        
        iconImageView = KUICircleImageView(props: KUICircleImageViewProps(image: props.image))
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let parentStackView = UIStackView()
        parentStackView.axis = .horizontal
        parentStackView.spacing = 15
        parentStackView.alignment = .fill
        parentStackView.distribution = .fill
        parentStackView.translatesAutoresizingMaskIntoConstraints = false
        
        parentStackView.addArrangedSubview(iconImageView)
        parentStackView.addArrangedSubview(childStackView)
        
        memoDescriptionView = KUIRoundedTextView(props: KUIRoundedTextViewProps(description: "-"))
        memoDescriptionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            iconImageView.widthAnchor.constraint(equalToConstant: 50),
            iconImageView.heightAnchor.constraint(equalToConstant: 50),
        ])
        
        NSLayoutConstraint.activate([
            parentStackView.topAnchor.constraint(equalTo: topAnchor),
            parentStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            parentStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            memoDescriptionView.topAnchor.constraint(equalTo: parentStackView.bottomAnchor, constant: 25),
            memoDescriptionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            memoDescriptionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            memoDescriptionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
