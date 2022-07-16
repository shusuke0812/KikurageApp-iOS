//
//  KikurageQRCodeReaderViewModel.swift
//  KikurageFeature
//
//  Created by Shusuke Ota on 2022/7/15.
//  Copyright © 2022 shusuke. All rights reserved.
//

import Foundation

protocol KikurageQRCodeReaderViewModelDelegate: AnyObject {
    func qrCodeReaderViewModelDidConfiguredSession(_ qrCodeReaderViewModel: KikurageQRCodeReaderViewModelDelegate, )
}

public class QRCodeReaderViewModel: NSObject {
    private var captureSessionQueue = DispatchQueue(label: Bundle.main.bundleIdentifier! + "_capture.session")
    
    weak var delegate: KikurageQRCodeReaderViewModelDelegate?
    
    override init() {
        let qrCodeReaderSession = QRCodeReaderSession()
        
        captureSessionQueue.async {
            qrCodeReaderSession.configureSession(onSuccess: {
                print("success")
            }, onError: { error in
                print("faile:\(error?.localizedDescription)")
            })
        }
    }
}
