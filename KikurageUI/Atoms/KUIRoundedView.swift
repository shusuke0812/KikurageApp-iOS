//
//  KUIRoundedView.swift
//  KikurageUI
//
//  Created by Shusuke Ota on 2024/6/16.
//  Copyright © 2024 shusuke. All rights reserved.
//

import UIKit

public struct KUIRoundedViewProps {
    let backgroundColor: UIColor?
    
    public init(
        backgroundColor: UIColor? = .white
    ) {
        self.backgroundColor = backgroundColor
    }
}

public class KUIRoundedView: UIView {
    public init(props: KUIRoundedViewProps) {
        super.init(frame: .zero)
        setupComponent(props: props)
    }
    
    public required init?(coder: NSCoder) {
        nil
    }
    
    private func setupComponent(props: KUIRoundedViewProps) {
        backgroundColor = props.backgroundColor
        clipsToBounds = true
        layer.cornerRadius = .viewCornerRadius
        translatesAutoresizingMaskIntoConstraints = false
    }
}
