//
//  KUIDeviceStatusImageView.swift
//  KikurageUI
//
//  Created by Shusuke Ota on 2024/7/2.
//  Copyright © 2024 shusuke. All rights reserved.
//

import UIKit

public struct KUIDeviceStatusImageViewProps {
    let state: String // TODO: KikurageStateに置き換える
    let dateString: String
    
    public init(state: String, dateString: String) {
        self.state = state
        self.dateString = dateString
    }
}

public class KUIDeviceStatusImageView: UIView {
    private var statusImageView: UIImageView!

    public init(props: KUIDeviceStatusImageViewProps) {
        super.init(frame: .zero)
        setupComponent(props: props)
    }
    
    public required init?(coder: NSCoder) {
        nil
    }
            
    private func setupComponent(props: KUIDeviceStatusImageViewProps) {
        let parentView = KUIRoundedView()
        parentView.translatesAutoresizingMaskIntoConstraints = false
        
        statusImageView = UIImageView() // TODO: imageの設定
        statusImageView.contentMode = .scaleAspectFill
        statusImageView.translatesAutoresizingMaskIntoConstraints = false
        
        parentView.addSubview(statusImageView)
        addSubview(parentView)
        
        NSLayoutConstraint.activate([
            statusImageView.topAnchor.constraint(equalTo: parentView.topAnchor),
            statusImageView.leadingAnchor.constraint(equalTo: parentView.leadingAnchor),
            statusImageView.trailingAnchor.constraint(equalTo: parentView.trailingAnchor),
            statusImageView.bottomAnchor.constraint(equalTo: parentView.bottomAnchor),
            
            parentView.topAnchor.constraint(equalTo: topAnchor),
            parentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            parentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            parentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
