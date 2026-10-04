//
//  KProgressHUDView.swift
//  KikurageUI
//
//  Created by Shusuke Ota on 2026/10/4.
//  Copyright © 2026 shusuke. All rights reserved.
//

import SwiftUI

public struct KProgressHUDView: View {
    public init() {}

    public var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()

            RoundedRectangle(cornerRadius: 12)
                .fill(Color(uiColor: .systemBackground))
                .frame(width: 80, height: 80)
                .overlay(
                    ProgressView()
                        .progressViewStyle(.circular)
                        .scaleEffect(1.2)
                )
                .shadow(radius: 8)
        }
    }
}

#Preview {
    KProgressHUDView()
}
