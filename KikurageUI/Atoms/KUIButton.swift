//
//  KUIButton.swift
//  KikurageUI
//
//  Created by Shusuke Ota on 2024/6/5.
//  Copyright © 2024 shusuke. All rights reserved.
//

import UIKit

public protocol KUIButtonProps {
    var title: String { get set }
    var titleColor: UIColor { get set }
    var backgroundColor: UIColor { get set }
    var fontSize: CGFloat { get set }
    var fontWeight: UIFont.Weight { get set }
    var onTap: () -> Void { get set }
    var accessibilityIdentifier: String? { get set }
}

public class KUIButton: UIButton {
    init(props: KUIButtonProps) {
        super.init(frame: .zero)
        setup(props: props)
        setupButtonAction(props: props)
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    private func setup(props: KUIButtonProps) {
        layer.masksToBounds = true
        layer.cornerRadius = 5
        setTitle(props.title, for: .normal)
        setTitleColor(props.titleColor, for: .normal)
        titleLabel?.font = .systemFont(ofSize: props.fontSize, weight: props.fontWeight)
        backgroundColor = props.backgroundColor
        accessibilityIdentifier = props.accessibilityIdentifier
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupButtonAction(props: KUIButtonProps) {
        addAction(.init { _ in
            props.onTap()
        }, for: .touchUpInside)
    }
}
