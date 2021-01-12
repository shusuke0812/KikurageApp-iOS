//
//  SideMenuBaseView.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2021/1/12.
//  Copyright © 2021 shusuke. All rights reserved.
//

import UIKit

protocol SideMenuBaseViewDelegate: class {
    /// 問い合わせをタップした時の処理
    func didTapContactCell()
}

class SideMenuBaseView: UIView {
    
    @IBOutlet weak var calendarView: SideMenuContentView!
    @IBOutlet weak var graphView: SideMenuContentView!
    @IBOutlet weak var contactView: SideMenuContentView!
    @IBOutlet weak var settingView: SideMenuContentView!
    @IBOutlet weak var searchRecipeView: SideMenuContentView!
    @IBOutlet weak var kikurageDictionaryView: SideMenuContentView!
    @IBOutlet weak var licenseView: SideMenuContentView!
    /// デリゲート
    internal weak var delegate: SideMenuBaseViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    // MARK: - Action Method
    @IBAction func didTapContactCell(_ sender: Any) {
        self.delegate?.didTapContactCell()
    }
}
// MARK: - Initialized Method
extension SideMenuBaseView {
    
}
