//
//  OnlineProgramDetailView.swift
//  ToolsFavorites
//
//  Created by zitao0206 on 2024/2/15.
//

import SwiftUI
import WebKit

public struct OnlineProgramDetailView: View {

    let item: ToolItem
    
    public init(item: ToolItem) {
        self.item = item
    }
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var urlString: String = "https://www.onlinegdb.com/" // 初始加载的网页链接
    
    public var body: some View {
        VStack {
            WebView(urlString: $urlString)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        }
        .navigationBarTitle(item.title, displayMode: .inline)
        .font(.system(size: 10))
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading:
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "arrow.left")
                    .foregroundColor(.black)
            }
        )
        .onAppear {
        }
    }
}

struct WebView: UIViewRepresentable {
    @Binding var urlString: String

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        // Add a long-press gesture recognizer
        let longPressGesture = UILongPressGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handleLongPressGesture(_:)))
        webView.addGestureRecognizer(longPressGesture)
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            uiView.load(request)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        @objc func handleLongPressGesture(_ gestureRecognizer: UILongPressGestureRecognizer) {
            guard gestureRecognizer.state == .began else {
                return
            }
            
            // Check if clipboard contains text
            guard let pasteboardString = UIPasteboard.general.string else {
                return
            }
            
            // Perform paste operation
            let pasteScript = """
                document.execCommand('insertText', false, '\(pasteboardString)');
            """
            
            // Execute JavaScript code
            if let webView = gestureRecognizer.view as? WKWebView {
                webView.evaluateJavaScript(pasteScript) { result, error in
                    if let error = error {
                        print("JavaScript Error: \(error)")
                    } else {
                        print("Text pasted successfully")
                    }
                }
            }
        }
    }
}


 

