//
//  CultivationDetailBaseView.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2020/12/19.
//  Copyright © 2020 shusuke. All rights reserved.
//

import KDEntity
import KUIKit
import SwiftUI
import UIKit

struct CultivationDetailBaseView: View {
    let cultivation: KikurageCultivation

    @State private var currentPage: Int = 0

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            KCarouselView(
                props: KCarouselViewProps(imageStoragePaths: cultivation.imageStoragePaths),
                currentPage: $currentPage
            )

            KCultivationDetailDescriptionView(props: KCultivationDetailDescriptionViewProps(
                image: R.image.hakase(),
                title: R.string.localizable.screen_cultivation_detail_memo_title(),
                dateString: cultivation.viewDate,
                description: cultivation.memo
            ))
            .frame(maxHeight: .infinity, alignment: .top)
            .padding(.top, 25)
            .padding(.horizontal, 15)
            .padding(.bottom, 15)
        }
        .background(Color(uiColor: .systemGroupedBackground))
    }
}

#Preview {
    var cultivation = KikurageCultivation()
    cultivation.imageStoragePaths = ["wet_01", "wet_02"]
    cultivation.viewDate = "2024/01/01"
    cultivation.memo = "今日はきのこがよく育っていました。"
    return CultivationDetailBaseView(cultivation: cultivation)
}
