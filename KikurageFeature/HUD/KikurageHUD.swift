//
//  KikurageHUD.swift
//  KikurageFeature
//
//  Created by Shusuke Ota on 2022/1/9.
//  Copyright © 2022 shusuke. All rights reserved.
//

import UIKit

public class KikurageHUD: UIView {
    
    // MARK: Property
    
    private var loadingImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ResorceManager.getImage(name: "hakase")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var loadingLabel: UILabel = {
        let label = UILabel()
        label.text = ResorceManager.getLocalizedString("loading_text")
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.textColor = .gray
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
    
    // Private
    
    private func initUI() {
        backgroundColor = .clear
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.contentMode = .scaleToFill
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.addArrangedSubview(loadingImageView)
        stackView.addArrangedSubview(loadingLabel)
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            loadingImageView.widthAnchor.constraint(equalToConstant: 60),
            loadingImageView.heightAnchor.constraint(equalToConstant: 60),
            
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    // Public（TODO: 色々なアニメーションを追加してみる）
    
    public func startFlashAnimation(duration: TimeInterval = 0.8, delay: TimeInterval = 0.0) {
        UIView.animate(withDuration: duration, delay: delay, options: .repeat, animations: { [weak self] in
            self?.alpha = 0.0
        }, completion: nil)
    }
    public func stopFlashAnimation() {
        layer.removeAllAnimations()
        alpha = 1.0
    }
}
