//
//  DictionaryBaseView.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2022/3/30.
//  Copyright © 2022 shusuke. All rights reserved.
//

import KAAnalytics
import SwiftUI

struct DictionaryBaseView: View {
    @State private var selectedSegment = 0

    let triviaViewController: UIViewController
    let twitterViewController: UIViewController

    var body: some View {
        VStack(spacing: 0) {
            Picker("", selection: $selectedSegment) {
                Text(R.string.localizable.side_menu_dictionary_segment_title_trivia()).tag(0)
                Text(R.string.localizable.side_menu_dictionary_segment_title_twitter()).tag(1)
            }
            .pickerStyle(.segmented)
            .padding(8)

            if selectedSegment == 0 {
                ViewControllerContainer(viewController: triviaViewController)
            } else {
                ViewControllerContainer(viewController: twitterViewController)
            }
        }
        .background(Color.white)
        .onChange(of: selectedSegment) { newValue in
            if newValue == 0 {
                FirebaseAnalyticsManager.sendScreenViewEvent(.dictionaryTrivia)
            } else {
                FirebaseAnalyticsManager.sendScreenViewEvent(.dictionaryTwitter)
            }
        }
    }
}

private struct ViewControllerContainer: UIViewControllerRepresentable {
    let viewController: UIViewController

    func makeUIViewController(context: Context) -> UIViewController {
        viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
