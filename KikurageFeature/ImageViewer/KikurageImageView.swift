//
//  KikurageImageView.swift
//  KikurageFeature
//
//  Created by Shusuke Ota on 2022/11/8.
//  Copyright © 2022 shusuke. All rights reserved.
//

import UIKit

class KikurageImageView: UIView {
    private var scrollView: UIScrollView!
    private var imageView: UIImageView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func initialize() {
        imageView = UIImageView()
        
        scrollView = UIScrollView()
        
        scrollView.addSubview(imageView)
        addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.frameLayoutGuide.topAnchor.constraint(equalTo: topAnchor),
            scrollView.frameLayoutGuide.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.frameLayoutGuide.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.frameLayoutGuide.bottomAnchor.constraint(equalTo: bottomAnchor),
            scrollView.contentLayoutGuide.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.frameLayoutGuide.heightAnchor),
            
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}

extension KikurageImageView {
    public func updateImageView(with image: UIImage) {
        imageView.image = image
    }
}
