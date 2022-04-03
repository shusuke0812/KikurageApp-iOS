//
//  DictionaryTwitterViewModel.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2022/4/3.
//  Copyright © 2022 shusuke. All rights reserved.
//

import Foundation
import UIKit.UITableView

class DictionaryTwitterViewModel: NSObject {
}

// MARK: - UITableViewDataSource

extension DictionaryTwitterViewModel: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.tweetTableViewCell, for: indexPath) else {
            return UITableViewCell()
        }
        return cell
    }
}
