//
//  KUICultivationDetailDescriptionView.swift
//  KikurageUI
//
//  Created by Shusuke Ota on 2024/12/14.
//  Copyright © 2024 shusuke. All rights reserved.
//

import UIKit

public struct KUICultivationDetailDescriptionViewProps {
    let image: UIImage
    let tittle: String
    let dateString: String
    let description: String
    
    public init(image: UIImage, tittle: String, dateString: String, description: String) {
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
    private var memoContentView: KUIRoundedView!
    private var memoLabel: UILabel!

    public init(props: KUICultivationDetailDescriptionViewProps) {
        super.init(frame: .zero)
        setupComponent(props: props)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupComponent(props: KUICultivationDetailDescriptionViewProps) {
        memoTitleLabel = UILabel()
        memoLabel.text = props.tittle
        memoLabel.font = .systemFont(ofSize: 17)
        
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
        
        memoContentView = KUIRoundedView(props: KUIRoundedViewProps())
        memoContentView.translatesAutoresizingMaskIntoConstraints = false
        
        memoLabel = UILabel()
        memoLabel.font = .systemFont(ofSize: 14)
        memoLabel.numberOfLines = 0
        memoLabel.translatesAutoresizingMaskIntoConstraints = false
        
        memoContentView.addSubview(memoLabel)
        
        NSLayoutConstraint.activate([
            iconImageView.widthAnchor.constraint(equalToConstant: 50),
            iconImageView.heightAnchor.constraint(equalToConstant: 50),
            
            memoLabel.topAnchor.constraint(equalTo: memoContentView.topAnchor, constant: 8),
            memoLabel.leadingAnchor.constraint(equalTo: memoContentView.leadingAnchor, constant: 8),
            memoLabel.trailingAnchor.constraint(equalTo: memoContentView.trailingAnchor, constant: -8),
            memoLabel.bottomAnchor.constraint(equalTo: memoContentView.bottomAnchor, constant: -8)
        ])
        
        NSLayoutConstraint.activate([
            parentStackView.topAnchor.constraint(equalTo: topAnchor),
            parentStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            parentStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            memoContentView.topAnchor.constraint(equalTo: parentStackView.bottomAnchor, constant: 25),
            memoContentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            memoContentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            memoContentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
