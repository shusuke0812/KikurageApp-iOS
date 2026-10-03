//
//  HomeBaseView.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2020/10/21.
//  Copyright © 2020 shusuke. All rights reserved.
//

import KSHomeService
import KUIKit
import SwiftUI
import UIKit

protocol HomeBaseViewDelegate: AnyObject {
    func homeBaseViewDidTapCultivationButton()
    func homeBaseViewDidTapRecipeButton()
    func homeBaseViewDidTapCommunicationButton()
}

struct HomeBaseView: View {
    @StateObject var state: HomeState

    weak var delegate: HomeBaseViewDelegate?

    init(delegate: HomeBaseViewDelegate?, state: HomeState) {
        self.delegate = delegate
        _state = StateObject(wrappedValue: state)
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color(uiColor: .systemGroupedBackground)
                    .ignoresSafeArea()
                VStack(spacing: 0) {
                    HomeHeaderView(
                        kikurageName: state.kikurageName,
                        statusMessage: state.statusMessage
                    )
                    .padding(.top, 16)
                    .padding(.horizontal, 16)

                    ZStack(alignment: .bottomTrailing) {
                        KDeviceStatusImageView(props: KDeviceStatusImageViewProps(
                            images: state.stateImages,
                            isAnimating: state.isAnimating,
                            hasError: state.hasStateError
                        ))
                        #if !PRODUCTION
                        Text(state.nowTimeString)
                            .font(.system(size: 11))
                            .padding(8)
                        #endif
                    }
                    .clipShape(RoundedRectangle(cornerRadius: .viewCornerRadius))
                    .frame(
                        width: geometry.size.width - 32,
                        height: (geometry.size.width - 32) * 9.0 / 16.0
                    )
                    .padding(.top, 15)
                    .padding(.horizontal, 16)

                    KDeviceStatusListView(props: KDeviceStatusListViewProps(
                        temperature: state.temperature,
                        humidity: state.humidity
                    ))
                    .frame(height: 100)
                    .padding(.top, 15)
                    .padding(.horizontal, 16)

                    KHomeAdviceView(props: KHomeAdviceViewProps(
                        title: R.string.localizable.screen_home_advice_title(),
                        description: state.advice,
                        image: R.image.hakase()
                    ))
                    .frame(maxHeight: .infinity)
                    .padding(.top, 15)
                    .padding(.horizontal, 16)

                    KFooterButtonView(
                        onCultivation: { delegate?.homeBaseViewDidTapCultivationButton() },
                        onRecipe: { delegate?.homeBaseViewDidTapRecipeButton() },
                        onCommunication: { delegate?.homeBaseViewDidTapCommunicationButton() }
                    )
                    .frame(height: 50)
                    .padding(.top, 15)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 20)
                }
            }
        }
    }
}

// MARK: - HomeHeaderView

private struct HomeHeaderView: View {
    let kikurageName: String
    let statusMessage: String

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(kikurageName)
                .font(.system(size: 26, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(statusMessage)
                .font(.system(size: 20))
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    HomeBaseView(delegate: nil, state: HomeState())
}
