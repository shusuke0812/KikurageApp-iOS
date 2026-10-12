//
//  DictionaryTriviaViewController.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2022/4/2.
//  Copyright © 2022 shusuke. All rights reserved.
//

import UIKit

class DictionaryTriviaViewController: UIViewController, UIViewControllerNavigatable {
    override func viewDidLoad() {
        super.viewDidLoad()

        let baseView = DictionaryTriviaBaseView()
        let _ = addBaseView(baseView: baseView)
    }
}
