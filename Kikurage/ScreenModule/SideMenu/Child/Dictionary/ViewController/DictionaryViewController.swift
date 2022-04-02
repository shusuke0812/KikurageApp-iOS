//
//  DictionaryViewController.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2022/3/30.
//  Copyright © 2022 shusuke. All rights reserved.
//

import UIKit

class DictionaryViewController: UIViewController {
    private var baseView: DictionaryBaseView { self.view as! DictionaryBaseView } // swiftlint:disable:this force_cast

    private lazy var dictionaryTriviaVC: DictionaryTriviaViewController = {
        let vc = R.storyboard.dictionaryTriviaViewController().instantiateInitialViewController() as! DictionaryTriviaViewController // swiftlint:disable:this force_cast
        return vc
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
