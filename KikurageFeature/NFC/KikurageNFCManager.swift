//
//  KikurageNFCManager.swift
//  KikurageFeature
//
//  Created by Shusuke Ota on 2023/4/27.
//  Copyright © 2023 shusuke. All rights reserved.
//

import CoreNFC
import Foundation

// Note
// - If you would to use no NDEF format, you have to use NFCTagReaderSession.
// - Session timeout is 60 seconds. So, you had better to use print() in debug. Should not use breakpoints.

public protocol KikurageNFCManagerDelegate: AnyObject {
    func kikurageNFCManager(_ kikurageNFCManager: KikurageNFCManager, didDetectNDEFs message: String)
    func kikurageNFCManager(_ kikurageNFCManager: KikurageNFCManager, errorMessage: String)
}

public class KikurageNFCManager: NSObject {
    public var session: NFCNDEFReaderSession?
    public weak var delegate: KikurageNFCManagerDelegate?

    override init() {
        super.init()
        session = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: true)
    }

    public func startNFCScan() {
        guard NFCNDEFReaderSession.readingAvailable else {
            delegate?.kikurageNFCManager(self, errorMessage: KikurageNFCError.notAvailable.description)
            return
        }
        session?.alertMessage = ResorceManager.getLocalizedString("nfc_begin_alert_message")
        session?.begin()
    }
}

extension KikurageNFCManager: NFCNDEFReaderSessionDelegate {
    public func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {}

    public func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        guard let message = messages.first else {
            delegate?.kikurageNFCManager(self, errorMessage: KikurageNFCError.messageGetFail.description)
            return
        }
        delegate?.kikurageNFCManager(self, didDetectNDEFs: message.description)
    }

    public func readerSession(_ session: NFCNDEFReaderSession, didDetect tags: [NFCNDEFTag]) {
        Task {
            guard let tag = tags.first else {
                delegate?.kikurageNFCManager(self, errorMessage: KikurageNFCError.messageGetFail.description)
                return
            }
            try await session.connect(to: tag)

            // read
            let message = try await tag.readNDEF()
            KLogManager.debug("\(message)")

            // write
            // let ndefMessage: NFCNDEFMessage =
            // try await tag.writeNDEF(ndefMessage)

            // success
            session.alertMessage = ResorceManager.getLocalizedString("nfc_end_alert_message")
            session.invalidate()

            // fail
            // session.invalidate(errorMessage: ResorceManager.getLocalizedString("nfc_end_alert_error_message"))
        }
    }
}
