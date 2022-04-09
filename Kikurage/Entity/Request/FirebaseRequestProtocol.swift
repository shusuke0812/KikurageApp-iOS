//
//  FirebaseRequestProtocol.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2022/4/9.
//  Copyright © 2022 shusuke. All rights reserved.
//

import Foundation
import Firebase

protocol FirebaseRequestProtocol {
    associatedtype Response: Decodable
    
    var documentReference: DocumentReference { get }
}
