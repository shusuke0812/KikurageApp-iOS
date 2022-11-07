//
//  KikurageImageViewController.swift
//  KikurageFeature
//
//  Created by Shusuke Ota on 2022/11/8.
//  Copyright © 2022 shusuke. All rights reserved.
//

import UIKit

public class KikurageImageViewController: UIViewController {
    private var baseView: KikurageImageView = KikurageImageView()
    
    private var image: UIImage
    
    public init(image: UIImage) {
        self.image = image
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    public override func loadView() {
        super.loadView()
        view = baseView
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        baseView.updateImageView(with: image)
    }
}
