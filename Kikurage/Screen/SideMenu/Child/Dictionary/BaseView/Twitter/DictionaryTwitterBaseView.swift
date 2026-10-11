//
//  DictionaryTwitterBaseView.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2022/4/2.
//  Copyright © 2022 shusuke. All rights reserved.
//

import KSDictionaryService
import KSSDateHelper
import KUIKit
import SwiftUI

struct DictionaryTwitterBaseView: View {
    @StateObject var state: DictionaryTwitterState

    init(state: DictionaryTwitterState) {
        _state = StateObject(wrappedValue: state)
    }

    var body: some View {
        ZStack {
            if state.isLoading {
                ProgressView()
            } else if state.tweets.isEmpty {
                KUIEmptyView(type: .notFoundTweets)
            } else {
                List(state.tweets, id: \.id) { tweet in
                    KTweetRow(props: KTweetRowProps(
                        userName: tweet.user.name,
                        createdAtString: DateHelper.formatToString(date: tweet.createdAt),
                        tweet: tweet.text,
                        iconImageURL: URL(string: tweet.user.profileImageURL)
                    ))
                    .listRowInsets(EdgeInsets())
                }
                .listStyle(.plain)
            }
        }
        .alert(state.errorMessage, isPresented: $state.hasError) {
            Button(R.string.localizable.common_alert_ok_btn_ok(), role: .cancel) {}
        }
    }
}

#Preview {
    let state = DictionaryTwitterState()
    return DictionaryTwitterBaseView(state: state)
}
