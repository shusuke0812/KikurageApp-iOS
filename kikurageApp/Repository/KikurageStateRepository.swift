//
//  KikurageStateRepository.swift
//  kikurageApp
//
//  Created by Shusuke Ota on 2020/10/15.
//  Copyright © 2020 shusuke. All rights reserved.
//

import Firebase
import FirebaseFirestore

/// ネットワークエラー
enum NetworkError: Error {
    case invalidUrl         // 不正なURL
    case invalidResponse    // 不正なレスポンス
    case unknown            // 想定外エラー
    func description() -> String {
        switch self {
            case .invalidUrl:       return "DEBUG： 不正なURLです"
            case .invalidResponse:  return "DEBUG： 不正なレスポンスです"
            case .unknown:          return "DEBUG： レスポンスに失敗しました"
        }
    }
}
/// クライアントエラー
enum ClientError: Error {
    case parseField // パースエラー
    case unknown    // 想定外エラー
}

protocol KikurageStateRepositoryProtocol {
    /// KikurageStateを読み込む（GET）
    /// - Parameters:
    ///   - uid: プロダクトID
    func readKikurageState(uid: String, completion: @escaping (Result<KikurageState, Error>) -> Void)
}

class KikurageStateRepository: KikurageStateRepositoryProtocol {
}

extension KikurageStateRepository {
    func readKikurageState(uid: String, completion: @escaping (Result<KikurageState, Error>) -> Void) {
        let db = Firestore.firestore()
        let docRef = db.collection("kikurageStates").document(uid)
        
        docRef.getDocument { (snapshot, error) in
            if let error = error {
                print(error)
                return
            }
            let kikurageState = snapshot?.data().map { document in
                print(document)
                return
            }
            print(kikurageState)
        }
    }
}
