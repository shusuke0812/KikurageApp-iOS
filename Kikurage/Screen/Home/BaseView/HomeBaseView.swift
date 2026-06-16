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

                HomeStatusImageView(
                    stateImages: state.stateImages,
                    isAnimating: state.isAnimating,
                    nowTimeString: state.nowTimeString,
                    hasStateError: state.hasStateError
                )
                .clipShape(RoundedRectangle(cornerRadius: .viewCornerRadius))
                .aspectRatio(16.0 / 9.0, contentMode: .fit)
                .padding(.top, 15)
                .padding(.horizontal, 16)

                HomeStatusListView(
                    temperature: state.temperature,
                    humidity: state.humidity
                )
                .frame(height: 100)
                .padding(.top, 15)
                .padding(.horizontal, 16)

                HomeAdviceView(advice: state.advice)
                    .padding(.top, 15)
                    .padding(.horizontal, 16)

                HomeFooterButtonView(
                    onCultivation: { delegate?.homeBaseViewDidTapCultivationButton() },
                    onRecipe: { delegate?.homeBaseViewDidTapRecipeButton() },
                    onCommunication: { delegate?.homeBaseViewDidTapCommunicationButton() }
                )
                .frame(height: 50)
                .padding(.top, 15)
                .padding(.horizontal, 16)
                .padding(.bottom, 20)

                Spacer(minLength: 0)
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

// MARK: - HomeStatusImageView

private struct HomeStatusImageView: View {
    let stateImages: [UIImage]
    let isAnimating: Bool
    let nowTimeString: String
    let hasStateError: Bool

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            if hasStateError {
                Color.white
                    .overlay(
                        Text(R.string.localizable.common_read_error())
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(Color(uiColor: .lightGray))
                    )
            } else {
                KUIDeviceStatusImageViewRepresentable(
                    images: stateImages,
                    isAnimating: isAnimating
                )
            }
            #if !PRODUCTION
            Text(nowTimeString)
                .font(.system(size: 11))
                .padding(8)
            #endif
        }
    }
}

// MARK: - KUIDeviceStatusImageView UIViewRepresentable

private struct KUIDeviceStatusImageViewRepresentable: UIViewRepresentable {
    let images: [UIImage]
    let isAnimating: Bool

    func makeUIView(context: Context) -> KUIDeviceStatusImageView {
        KUIDeviceStatusImageView()
    }

    func updateUIView(_ uiView: KUIDeviceStatusImageView, context: Context) {
        if !images.isEmpty {
            uiView.runAnimation(images: images)
        }
        if isAnimating {
            uiView.startAnimating()
        } else {
            uiView.stopAnimating()
        }
    }
}

// MARK: - HomeStatusListView

private struct HomeStatusListView: View {
    let temperature: Int
    let humidity: Int

    var body: some View {
        RoundedRectangle(cornerRadius: .viewCornerRadius)
            .fill(Color(uiColor: .systemBackground))
            .overlay(
                HStack(spacing: 0) {
                    VStack(alignment: .leading, spacing: 15) {
                        Text("現在").font(.system(size: 15))
                        Text("理想").font(.system(size: 15))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    VStack(alignment: .center, spacing: 4) {
                        Text("温度").font(.system(size: 15))
                        Text("\(temperature)").font(.system(size: 15, weight: .bold))
                        Text("20-25°C").font(.system(size: 15))
                    }
                    .frame(maxWidth: .infinity)

                    VStack(alignment: .center, spacing: 4) {
                        Text("湿度").font(.system(size: 15))
                        Text("\(humidity)").font(.system(size: 15, weight: .bold))
                        Text("80%以上").font(.system(size: 15))
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(8)
            )
    }
}

// MARK: - HomeAdviceView

private struct HomeAdviceView: View {
    let advice: String

    var body: some View {
        RoundedRectangle(cornerRadius: .viewCornerRadius)
            .fill(Color(uiColor: .systemBackground))
            .overlay(
                VStack(alignment: .leading, spacing: 5) {
                    HStack {
                        Text(R.string.localizable.screen_home_advice_title())
                            .font(.system(size: 15, weight: .bold))
                        Spacer()
                        if let hakaseImage = R.image.hakase() {
                            Image(uiImage: hakaseImage)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 30)
                        }
                    }
                    Text(advice)
                        .font(.system(size: 15))
                }
                .padding(5)
            )
    }
}

// MARK: - HomeFooterButtonView

private struct HomeFooterButtonView: View {
    let onCultivation: () -> Void
    let onRecipe: () -> Void
    let onCommunication: () -> Void

    var body: some View {
        RoundedRectangle(cornerRadius: .viewCornerRadius)
            .fill(Color.white)
            .overlay(
                HStack(spacing: 5) {
                    Button(action: onCultivation) {
                        Image(systemName: "leaf.fill")
                            .font(.system(size: 30))
                            .foregroundColor(.blue)
                            .frame(maxWidth: .infinity)
                    }
                    Button(action: onRecipe) {
                        Image(systemName: "fork.knife")
                            .font(.system(size: 30))
                            .foregroundColor(.orange)
                            .frame(maxWidth: .infinity)
                    }
                    Button(action: onCommunication) {
                        Image(systemName: "person.2.fill")
                            .font(.system(size: 30))
                            .foregroundColor(.green)
                            .frame(maxWidth: .infinity)
                    }
                }
                .padding(5)
            )
    }
}

#Preview {
    HomeBaseView(delegate: nil, state: HomeState())
}
