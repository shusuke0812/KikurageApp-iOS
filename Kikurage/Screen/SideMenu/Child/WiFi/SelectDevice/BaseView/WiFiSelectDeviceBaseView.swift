//
//  WiFiSelectDeviceBaseView.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2023/3/5.
//  Copyright © 2023 shusuke. All rights reserved.
//

import KDBluetoothManager
import KSWiFiService
import KUIKit
import SwiftUI

protocol WiFiSelectDeviceBaseViewDelegate: AnyObject {
    func wifiSelectDeviceBaseViewDidSelectDevice(index: Int)
}

struct WiFiSelectDeviceBaseView: View {
    @StateObject var state: WiFiSelectDeviceState
    weak var delegate: WiFiSelectDeviceBaseViewDelegate?

    init(state: WiFiSelectDeviceState, delegate: WiFiSelectDeviceBaseViewDelegate?) {
        _state = StateObject(wrappedValue: state)
        self.delegate = delegate
    }

    var body: some View {
        ZStack {
            List {
                Section {
                    ForEach(state.devices) { device in
                        WiFiDeviceRow(info: device)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                delegate?.wifiSelectDeviceBaseViewDidSelectDevice(index: device.id)
                            }
                    }
                } header: {
                    HStack(spacing: 8) {
                        Text(state.sectionTitle)
                        if state.isScanning {
                            ProgressView()
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)

            if state.isConnecting {
                KProgressHUDView()
            }
        }
    }
}

private struct WiFiDeviceRow: View {
    let info: WiFiDeviceInfo

    private let imageSize: CGFloat = 24

    var body: some View {
        HStack(spacing: 16) {
            VStack(spacing: 4) {
                if let signalImage = info.signalImage {
                    Image(uiImage: signalImage)
                        .resizable()
                        .frame(width: imageSize, height: imageSize)
                } else {
                    Color.clear
                        .frame(width: imageSize, height: imageSize)
                }
                Text(info.rssiString)
                    .font(.system(size: 12))
            }
            .frame(width: imageSize * 1.5)

            VStack(alignment: .leading, spacing: 0) {
                Text(info.deviceName)
                    .font(.system(size: 20))
                Text(info.serviceCountString)
                    .font(.system(size: 17))
                    .foregroundColor(.gray)
            }

            Spacer(minLength: 0)

            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(Color(uiColor: .systemGray3))
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    let state = WiFiSelectDeviceState()
    state.sectionTitle = "周辺デバイス"
    state.isScanning = true
    return WiFiSelectDeviceBaseView(state: state, delegate: nil)
}

#Preview {
    WiFiDeviceRow(info: WiFiDeviceInfo(
        id: 0,
        signalImage: BluetoothSignal.good.image,
        rssiString: "-50",
        deviceName: "Kikurage-Device-01",
        serviceCountString: "3 services"
    ))
    .padding()
}
