//
//  DictionaryTriviaBaseView.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2022/4/2.
//  Copyright © 2022 shusuke. All rights reserved.
//

import SwiftUI
import WebKit

struct DictionaryTriviaBaseView: View {
    @State private var isLoading = true

    private let url = URL(string: "https://midorikoubou.jp/blog/2018/08/08/kikuragecultivation-faq")

    var body: some View {
        ZStack {
            if let url {
                WebViewRepresentable(url: url, isLoading: $isLoading)
            }

            if isLoading {
                ProgressView()
            }
        }
    }
}

private struct WebViewRepresentable: UIViewRepresentable {
    let url: URL
    @Binding var isLoading: Bool

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        webView.load(URLRequest(url: url))
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(isLoading: $isLoading)
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        @Binding var isLoading: Bool

        init(isLoading: Binding<Bool>) {
            _isLoading = isLoading
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            isLoading = false
        }
    }
}

#Preview {
    DictionaryTriviaBaseView()
}
