//
//  SideMenuBaseView.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2021/1/12.
//  Copyright © 2021 shusuke. All rights reserved.
//

import KSAppService
import KUIKit
import SwiftUI
import UIKit

protocol SideMenuBaseViewDelegate: AnyObject {
    func sideMenuBaseViewDidSelectItem(_ item: SideMenuViewModel.SectionRowType)
    func sideMenuBaseViewDidRequestClose()
}

struct SideMenuBaseView: View {
    let sections: [SideMenuViewModel.Section]
    weak var delegate: SideMenuBaseViewDelegate?

    @State private var isOpen = false

    private let panelWidth: CGFloat = 210
    private let animationDuration: Double = 0.3

    var body: some View {
        ZStack(alignment: .leading) {
            Color.white.opacity(isOpen ? 0.5 : 0)
                .ignoresSafeArea()
                .onTapGesture {
                    closeWithAnimation()
                }

            VStack(spacing: 0) {
                // ヘッダー（タイトル。背景のみステータスバーの裏まで伸ばす）
                Text(R.string.localizable.side_menu_title())
                    .font(.system(size: 18, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 15)
                    .padding(.bottom, 10)
                    .background(Color(uiColor: .systemBackground))//.ignoresSafeArea(edges: .top))

                // メニュー本体
                List {
                    ForEach(sections, id: \.self) { section in
                        Section {
                            ForEach(section.rows, id: \.self) { row in
                                KSideMenuItemRow(props: KSideMenuItemRowProps(
                                    title: row.title,
                                    iconImageName: row.iconImageName
                                ))
                                .onTapGesture {
                                    delegate?.sideMenuBaseViewDidSelectItem(row)
                                }
                                .listRowInsets(EdgeInsets())
                                .listRowBackground(Color(uiColor: .systemGroupedBackground))
                            }
                        }
                    }
                }
                .listStyle(.grouped)
                .scrollDisabled(false)
                .scrollContentBackground(.hidden)
                .background(Color(uiColor: .systemGroupedBackground))
            }
            .frame(width: panelWidth)
            .offset(x: isOpen ? 0 : -panelWidth)

            Spacer()
        }
        .onAppear {
            withAnimation(.easeOut(duration: animationDuration)) {
                isOpen = true
            }
        }
    }

    private func closeWithAnimation() {
        withAnimation(.easeIn(duration: animationDuration)) {
            isOpen = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) {
            delegate?.sideMenuBaseViewDidRequestClose()
        }
    }
}

#Preview {
    SideMenuBaseView(sections: [.history, .support], delegate: nil)
}
