//
//  KUIDeviceStatusListView.swift
//  KikurageUI
//
//  Created by Shusuke Ota on 2024/6/29.
//  Copyright © 2024 shusuke. All rights reserved.
//

import SwiftUI

public struct KUIDeviceStatusListViewProps {
    let temperature: Int
    let humidity: Int

    public init(temperature: Int, humidity: Int) {
        self.temperature = temperature
        self.humidity = humidity
    }
}

public struct KUIDeviceStatusListView: View {
    private let props: KUIDeviceStatusListViewProps

    public init(props: KUIDeviceStatusListViewProps) {
        self.props = props
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 0) {
                Color.clear
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("温度").font(.system(size: 15))
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("湿度").font(.system(size: 15))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            KUIDividerView()

            VStack(alignment: .leading, spacing: 15) {
                HStack(spacing: 0) {
                    Text("現在").font(.system(size: 15))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("\(props.temperature)").font(.system(size: 15, weight: .bold))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("\(props.humidity)").font(.system(size: 15, weight: .bold))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                HStack(spacing: 0) {
                    Text("理想").font(.system(size: 15))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("20-25°C").font(.system(size: 15))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("80%以上").font(.system(size: 15))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }

            KUIDividerView()
        }
        .padding(8)
    }
}

#Preview {
    ZStack {
        Color(uiColor: .systemGroupedBackground)
            .ignoresSafeArea()
        KUIDeviceStatusListView(props: KUIDeviceStatusListViewProps(
            temperature: 21,
            humidity: 83
        ))
        .frame(height: 100)
        .padding(.top, 15)
        .padding(.horizontal, 16)
    }
}
