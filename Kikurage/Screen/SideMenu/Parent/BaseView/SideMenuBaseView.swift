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
        ZStack(alignment: .topLeading) {
            Color.white.opacity(isOpen ? 0.5 : 0)
                .ignoresSafeArea()
                .onTapGesture {
                    closeWithAnimation()
                }

            VStack(spacing: 0) {
                Text(R.string.localizable.side_menu_title())
                    .font(.system(size: 18, weight: .bold))
                    .padding(.horizontal, 15)
                    .padding(.top, 20)
                    .padding(.bottom, 20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(uiColor: .systemBackground))

                // メニュー本体
                List {
                    ForEach(sections, id: \.self) { section in
                        Section {
                            ForEach(section.rows, id: \.self) { row in
                                KUISideMenuItemRow(props: KUISideMenuItemRowProps(
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
            .frame(maxHeight: .infinity, alignment: .top)
            .offset(x: isOpen ? 0 : -panelWidth)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
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
