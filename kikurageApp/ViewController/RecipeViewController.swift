//
//  recipeViewController.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2019/03/02.
//  Copyright © 2019 shusuke. All rights reserved.
//

import UIKit

//Webアクセス
import SafariServices

class RecipeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

//====================================================
/***********  ボタンを押してCookpadへ遷移させる  ***********/
//====================================================
    
    @IBAction func cookPadButton(_ sender: Any) {
        guard let url = URL(string: "https://cookpad.com/search/%E3%81%8D%E3%81%8F%E3%82%89%E3%81%92") else { return }
        let safariController = SFSafariViewController(url: url)
        present(safariController, animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
