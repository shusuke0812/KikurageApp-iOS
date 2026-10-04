//
//  CommunicationBaseView.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2021/1/7.
//  Copyright © 2021 shusuke. All rights reserved.
//

import KUIKit
import SwiftUI
import UIKit

protocol CommunicationBaseViewDelegate: AnyObject {
    func communicationBaseViewDidTapFacebookButton()
}

struct CommunicationBaseView: View {
    weak var delegate: CommunicationBaseViewDelegate?

    var body: some View {
        ZStack {
            Color(uiColor: .systemGroupedBackground)
                .ignoresSafeArea()

            VStack(alignment: .center, spacing: 0) {
                Image(uiImage: R.image.communication() ?? UIImage())
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.top, 30)
                    .padding(.bottom, 30)

                KRoundedView {
                    Text(R.string.localizable.screen_communication_information())
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 15)
                }
                .padding(.top, 10)
                .padding(.horizontal, 16)

                Button(action: {
                    delegate?.communicationBaseViewDidTapFacebookButton()
                }) {
                    Image(uiImage: R.image.facebookButton() ?? UIImage())
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 30)

                Spacer(minLength: 0)
            }
        }
    }
}

#Preview {
    CommunicationBaseView(delegate: nil)
}
