//
//  KUIImageView.swift
//  KikurageUI
//
//  Created by Shusuke Ota on 2024/6/8.
//  Copyright © 2024 shusuke. All rights reserved.
//

import UIKit

public struct KUIImageViewProps {
    let image: UIImage?
    
    public init(image: UIImage?) {
        self.image = image
    }
}

public class KUIImageView: UIImageView {
    
    public init(props: KUIImageViewProps) {
        super.init(frame: .zero)
    }
    
    public required init?(coder: NSCoder) {
        nil
    }
    
    private func setup(props: KUIImageViewProps) {
        image = props.image
        clipsToBounds = true
        layer.cornerRadius = .viewCornerRadius
        contentMode = .scaleAspectFill
        translatesAutoresizingMaskIntoConstraints = false
    }
}
