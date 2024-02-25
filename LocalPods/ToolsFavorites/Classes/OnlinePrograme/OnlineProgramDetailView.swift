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
            WebView(urlString: $urlString) // 将WebView嵌入到VStack中
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity) // 让WebView充满整个空间
        }
        .navigationBarTitle(item.title, displayMode: .automatic)
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

// WebView组件
struct WebView: UIViewRepresentable {
    @Binding var urlString: String

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            uiView.load(request)
            // JavaScript code to set the default language to "Swift"
            let defaultLanguageScript = """
              var selectElement = document.getElementById('lang-select');
              if (selectElement) {
                 selectElement.selectedIndex = 3;
              }
            """
            // Execute JavaScript code
            uiView.evaluateJavaScript(defaultLanguageScript) { result, error in
                
              if let error = error {
                  print("JavaScript Error: \(error)")
              }
            }

        }
    }
}



 

