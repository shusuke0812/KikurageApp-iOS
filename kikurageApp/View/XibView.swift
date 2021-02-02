//
//  XibView.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2020/10/9.
//  Copyright © 2020 shusuke. All rights reserved.
//

import UIKit

class XibView: UIView {
    // Viewを作成するときに呼ばれる
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.loadView()
    }
    // StoryboardやXibから作成されたときに呼ばれる
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.loadView()
    }
    private func loadView() {
        let className = String(describing: type(of: self))
        let view = Bundle.main.loadNibNamed(className, owner: self, options: nil)?.first as! UIView // swiftlint:disable:this force_cast
        view.backgroundColor = .clear
        view.frame = self.bounds
        self.addSubview(view)
    }
}
