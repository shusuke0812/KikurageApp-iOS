//
//  HomeAdviceView.swift
//  KikurageUI
//
//  Created by Shusuke Ota on 2024/6/16.
//  Copyright © 2024 shusuke. All rights reserved.
//

import UIKit

public struct KUIHomeAdviceViewProps {
    let title: String
    let description: String
    let image: UIImage?
    
    public init(
        title: String,
        description: String,
        image: UIImage? = nil
    ) {
        self.title = title
        self.description = description
        self.image = image
    }
}

public class KUIHomeAdviceView: UIView {
    private var headerView: KUILabelWithImage!
    private var descriptionLabel: UILabel!

    public init(props: KUIHomeAdviceViewProps) {
        super.init(frame: .zero)
        setupComponent(props: props)
    }
    
    public required init?(coder: NSCoder) {
        nil
    }
    
    private func setupComponent(props: KUIHomeAdviceViewProps) {
        headerView = KUILabelWithImage(props: KUILabelWithImageProps(
            variant: .imagePositionRight,
            title: props.title,
            iamge: props.image
        ))
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        descriptionLabel.text = props.description
        descriptionLabel.font = .systemFont(ofSize: 15)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(headerView)
        addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            headerView.leftAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            headerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            
            descriptionLabel.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 5),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            descriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)
        ])
    }
}
