//
//  KUICircleImageView.swift
//  KikurageUI
//
//  Created by Shusuke Ota on 2024/12/14.
//  Copyright © 2024 shusuke. All rights reserved.
//

import UIKit

public struct KUICircleImageViewProps {
    let image: UIImage
    
    public init(image: UIImage) {
        self.image = image
    }
}

public class KUICircleImageView: UIImageView {
    public init(props: KUICircleImageViewProps) {
        super.init(frame: .zero)
        setupComponent(props: props)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupComponent(props: KUICircleImageViewProps) {
        contentMode = .scaleAspectFit
        clipsToBounds = true
        layer.cornerRadius = frame.width / 2
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.gray.cgColor
        image = props.image
    }
}
