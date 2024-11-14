//
//  KUISelectImageCollectionViewCell.swift
//  KikurageUI
//
//  Created by Shusuke Ota on 2024/11/7.
//  Copyright © 2024 shusuke. All rights reserved.
//

import UIKit
import FirebaseStorageUI

public class KUISelectImageCollectionViewCell: UICollectionViewCell {
    public var onCancel: (() -> Void)?
    
    private var selectImageView: UIImageView!
    private var cancelButton: UIButton!

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupComponent()
        setupAction()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func updateSelectedImage(imageStoragePath: String) {
        let storageReference = Storage.storage().reference(withPath: imageStoragePath)
        selectImageView.sd_setImage(with: storageReference)
    }
    
    private func setupComponent() {
        selectImageView = UIImageView(image: UIImage(named: "camera"))
        selectImageView.contentMode = .scaleAspectFill
        selectImageView.translatesAutoresizingMaskIntoConstraints = false
        
        cancelButton = UIButton()
        cancelButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(selectImageView)
        contentView.addSubview(cancelButton)
        
        NSLayoutConstraint.activate([
            selectImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            selectImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            selectImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            selectImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            cancelButton.widthAnchor.constraint(equalToConstant: 20),
            cancelButton.heightAnchor.constraint(equalToConstant: 20),
            cancelButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cancelButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    private func setupAction() {
        cancelButton.addAction(.init { [weak self] _ in
            guard let self else {
                return
            }
            self.onCancel?()
        }, for: .touchUpInside)
    }
}
