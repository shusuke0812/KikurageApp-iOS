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
    private var ndefSession: NFCNDEFReaderSession?
    private var tagSession: NFCTagReaderSession?

    public weak var delegate: KikurageNFCManagerDelegate?

    override public init() {
        super.init()
        initialize()
    }

    private func initialize() {
        ndefSession = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: false)
        ndefSession?.alertMessage = ResorceManager.getLocalizedString("nfc_begin_scan_alert_message")

        tagSession = NFCTagReaderSession(pollingOption: .iso14443, delegate: self, queue: nil)
        tagSession?.alertMessage = ResorceManager.getLocalizedString("nfc_begin_scan_alert_message")
    }

    public func startNFCScan() {
        guard NFCNDEFReaderSession.readingAvailable else {
            delegate?.kikurageNFCManager(self, errorMessage: KikurageNFCError.notAvailable.description)
            return
        }
        ndefSession?.begin()
    }

    public func startNFCTagScan() {
        guard NFCTagReaderSession.readingAvailable else {
            delegate?.kikurageNFCManager(self, errorMessage: KikurageNFCError.notAvailable.description)
            return
        }
        tagSession?.begin()
    }
}

// MARK: - NFCNDEFReaderSessionDelegate

extension KikurageNFCManager: NFCNDEFReaderSessionDelegate {
    public func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        KLogManager.debug("\(error.localizedDescription)")
    }

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
            session.alertMessage = ResorceManager.getLocalizedString("nfc_end_write_alert_message")
            session.invalidate()

            // fail
            // session.invalidate(errorMessage: ResorceManager.getLocalizedString("nfc_end_alert_error_message"))
        }
    }
}

// MARK: - NFCTagReaderSessionDelegate

extension KikurageNFCManager: NFCTagReaderSessionDelegate {
    public func tagReaderSessionDidBecomeActive(_ session: NFCTagReaderSession) {
        KLogManager.debug()
    }

    public func tagReaderSession(_ session: NFCTagReaderSession, didInvalidateWithError error: Error) {
        delegate?.kikurageNFCManager(self, errorMessage: error.localizedDescription)
    }

    public func tagReaderSession(_ session: NFCTagReaderSession, didDetect tags: [NFCTag]) {
        Task {
            guard let tag = tags.first else {
                delegate?.kikurageNFCManager(self, errorMessage: KikurageNFCError.messageGetFail.description)
                return
            }
            try await tagSession?.connect(to: tag)
            KLogManager.debug("tag=\(dump(tag))")

            switch tag {
            case .miFare(let miFareTag):
                delegate?.kikurageNFCManager(self, didDetectNDEFs: "")
            default:
                break
            }
            session.alertMessage = ResorceManager.getLocalizedString("nfc_end_read_alert_message")
            session.invalidate()
        }
    }
}
