//
//  CultivationBaseView.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2020/11/18.
//  Copyright © 2020 shusuke. All rights reserved.
//

import KSCultivationService
import KUIKit
import SwiftUI
import UIKit

protocol CultivationBaseViewDelegate: AnyObject {
    func cultivationBaseViewDidTapAddButton()
    func cultivationBaseViewDidSelectCultivation(_ cultivation: KikurageCultivationTuple)
    func cultivationBaseViewDidPullToRefresh()
}

struct CultivationBaseView: View {
    @StateObject var state: CultivationState

    weak var delegate: CultivationBaseViewDelegate?

    private let columns = [
        GridItem(.flexible(), spacing: .cellSpacing),
        GridItem(.flexible(), spacing: .cellSpacing)
    ]

    init(delegate: CultivationBaseViewDelegate?, state: CultivationState) {
        self.delegate = delegate
        _state = StateObject(wrappedValue: state)
    }

    var body: some View {
        ZStack {
            Color(uiColor: .systemGroupedBackground)
                .ignoresSafeArea()

            GeometryReader { geometry in
                ScrollView {
                    if state.isLoading && state.cultivations.isEmpty {
                        ProgressView()
                            .frame(height: geometry.size.height)
                    } else if state.cultivations.isEmpty {
                        KUIEmptyView(type: .notFoundCultivation)
                            .frame(height: geometry.size.height)
                    } else {
                        LazyVGrid(columns: columns, spacing: .cellSpacing * 2) {
                            ForEach(Array(state.cultivations.enumerated()), id: \.offset) { _, cultivation in
                                KCultivationCell(props: KCultivationCellProps(
                                    imageStoragePath: cultivation.data.imageStoragePaths.first,
                                    viewDate: cultivation.data.viewDate
                                ))
                                .aspectRatio(1, contentMode: .fit)
                                .onTapGesture {
                                    delegate?.cultivationBaseViewDidSelectCultivation(cultivation)
                                }
                            }
                        }
                        .padding(.cellSpacing)
                    }
                }
                .refreshable {
                    delegate?.cultivationBaseViewDidPullToRefresh()
                }
            }

            KCircleButton(props: KCircleButtonProps(
                variant: .primary,
                image: R.image.addMemoButton(),
                width: 60
            ), onTap: {
                delegate?.cultivationBaseViewDidTapAddButton()
            })
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
            .padding(20)
        }
        .alert("error", isPresented: $state.hasError) {
            Button(R.string.localizable.common_alert_ok_btn_ok(), role: .cancel) {}
        }
    }
}

#Preview {
    CultivationBaseView(delegate: nil, state: CultivationState())
}
