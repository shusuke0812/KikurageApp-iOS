//
//  R.swift
//  KikurageDomain
//
//  Created by Shusuke Ota on 2025/1/11.
//

import Foundation

enum R {
    enum LocalizableString {
        static let errorFirebaseCreate = string(localized: "error_firebase_create")
        static let errorFirebaseRead = string(localized: "error_firebase_read")
        static let errorFirebaseDelete = string(localized: "error_firebase_delete")
        static let errorFirebaseUpdate = string(localized: "error_firebase_update")
        static let errorFirebaseDocumentID = string(localized: "error_firebase_document_id")
        static let errorFirebaseLoadUser = string(localized: "error_firebase_load_user")

        static let errorClientNetworkConnection = string(localized: "error_client_network_connection")
        static let errorClientParse = string(localized: "error_client_parse")
        static let errorClientResponseParse = string(localized: "error_client_response_parse")
        static let errorClientApi = string(localized: "error_client_api")
        static let errorClientUnknown = string(localized: "error_client_unknown")
        static let errorClientSaveUserDefaults = string(localized: "error_client_save_user_defaults")
    }

    private static func string(localized key: String.LocalizationValue) -> String {
        String(localized: key, bundle: .module)
    }
}
