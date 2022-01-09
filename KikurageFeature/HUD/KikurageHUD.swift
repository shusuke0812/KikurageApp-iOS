//
//  KikurageHUD.swift
//  KikurageFeature
//
//  Created by Shusuke Ota on 2022/1/9.
//  Copyright © 2022 shusuke. All rights reserved.
//

import UIKit

class KikurageHUD: UIView {
    
    // MARK: Property
    
    private var loadingImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "kikurage_son")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var loadingLabel: UILabel = {
        let label = UILabel()
        label.text = "読み込み中"
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.textColor = .systemGray4
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: Initialized

    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }
    
    required init?(coder: NSCoder) {
        nil
    }
}

// MARK: - Config

extension KikurageHUD {
    private func initUI() {
        backgroundColor = .clear
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.addArrangedSubview(loadingImageView)
        stackView.addArrangedSubview(loadingLabel)
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
