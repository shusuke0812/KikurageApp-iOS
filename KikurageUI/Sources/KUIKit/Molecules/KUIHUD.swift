//
//  KUIHUD.swift
//  KikurageUI
//
//  Created by Shusuke Ota on 2022/1/9.
//  Copyright © 2022 shusuke. All rights reserved.
//

import SwiftUI

public struct KUIHUD: View {
    @State private var rotationAngle: Double = 0

    private let imageWidth: CGFloat = 60

    public init() {}

    public var body: some View {
        VStack(spacing: 0) {
            Image(uiImage: R.image.hakase() ?? UIImage())
                .resizable()
                .scaledToFit()
                .frame(width: imageWidth, height: imageWidth)
                .clipShape(Circle())
                .overlay(
                    Circle().stroke(Color.gray, lineWidth: 0.5)
                )
                .rotation3DEffect(
                    .degrees(rotationAngle),
                    axis: (x: 0, y: 1, z: 0),
                    anchor: .center,
                    perspective: 0
                )
                .onAppear {
                    withAnimation(.linear(duration: 1.0).repeatForever(autoreverses: false)) {
                        rotationAngle = 360
                    }
                }

            Text(R.string.localizable.loading_text())
                .font(.system(size: 17, weight: .bold))
                .foregroundColor(.gray)
        }
    }
}

#Preview {
    KUIHUD()
}
