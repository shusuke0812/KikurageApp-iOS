//
//  KUIRecipeTableViewCell.swift
//  KikurageUI
//
//  Created by Shusuke Ota on 2024/10/31.
//  Copyright © 2024 shusuke. All rights reserved.
//

import UIKit

public struct KUIRecipeTableViewCellProps {
    let image: UIImage
    let dateString: String
    let title: String
    let description: String
    
    public init(image: UIImage, dateString: String, title: String, description: String) {
        self.image = image
        self.dateString = dateString
        self.title = title
        self.description = description
    }
}

public class KUIRecipeTableViewCell: UITableViewCell {
    private var recipeImageView: KUIImageView!
    private var dateLabel: UILabel!
    private var titleLabel: UILabel!
    private var descriptionLabel: UILabel!

    public init(props: KUIRecipeTableViewCellProps) {
        super.init(style: .default, reuseIdentifier: nil)
        setupComponent(props: props)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupComponent(props: KUIRecipeTableViewCellProps) {
        recipeImageView = KUIImageView(props: KUIImageViewProps(
            image: props.image
        ))
        recipeImageView.translatesAutoresizingMaskIntoConstraints = false
        
        dateLabel = UILabel()
        dateLabel.text = props.dateString
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel = UILabel()
        titleLabel.text = props.title
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        descriptionLabel = UILabel()
        descriptionLabel.text = props.description
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let stackView = UIStackView(arrangedSubviews: [
            dateLabel,
            titleLabel,
            descriptionLabel
        ])
        stackView.spacing = 10
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(recipeImageView)
        
        NSLayoutConstraint.activate([
            recipeImageView.widthAnchor.constraint(equalToConstant: 160),
            recipeImageView.heightAnchor.constraint(equalToConstant: 160),
            
            recipeImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            recipeImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            recipeImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: recipeImageView.trailingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
}
