//
//  DebugBaseView.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2022/6/6.
//  Copyright © 2022 shusuke. All rights reserved.
//

import SwiftUI

protocol DebugBaseViewDelegate: AnyObject {
    func debugBaseViewDidTapForceRestart()
}

struct DebugBaseView: View {
    weak var delegate: DebugBaseViewDelegate?

    var body: some View {
        VStack(spacing: 0) {
            Button(action: {
                delegate?.debugBaseViewDidTapForceRestart()
            }) {
                Text("Force logout and restart app after 2min")
                    .foregroundColor(.blue)
                    .frame(maxWidth: .infinity)
            }
            .padding(.top, 30)
            .padding(.horizontal, 15)

            ProgressView()
                .padding(.top, 50)
                .padding(.horizontal, 30)
                .frame(maxWidth: .infinity)

            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color.white)
    }
}

#Preview {
    DebugBaseView(delegate: nil)
}
