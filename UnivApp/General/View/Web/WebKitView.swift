//
//  WebKitView.swift
//  UnivApp
//
//  Created by 정성윤 on 9/10/24.
//

import SwiftUI
import WebKit

struct WebKitView: UIViewRepresentable {
    var url: String
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        if let url = URL(string: url) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
}

struct WebKitViewContainer: View {
    var url: String
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        WebKitView(url: url)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image("blackback")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                    }

                }
            }
    }
}

#Preview {
    WebKitView(url: "")
}
