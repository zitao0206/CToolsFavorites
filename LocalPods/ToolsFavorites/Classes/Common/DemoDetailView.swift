//
//  QRCodeReaderDetailView.swift
//  ToolsFavorites
//
//  Created by zitao0206 on 2024/2/15.
//

import SwiftUI
import AVKit
import Photos



public struct DemoDetailView: View {

    let item: ToolItem
    
    public init(item: ToolItem) {
        self.item = item
    }
    
    @Environment(\.presentationMode) var presentationMode
    
    public var body: some View {
        VStack {
             
        }
        .commmonNavigationBar(title: item.title, displayMode: .automatic)
        .onAppear {

        }
    }
}



/*Markdown Editor View*/

//
//import MarkdownKit
//
//struct MarkdownEditorView: View {
//    @State private var markdownText: String = """
//    # OSCHINA.NET社区
//    ### Header 3
//    ## This is an H2 in a blockquote
//    """
//
//    var body: some View {
//        VStack {
//            TextEditor(text: $markdownText)
//                .padding()
//
//            MarkdownView(markdownText: markdownText)
//                .padding()
//        }
//    }
//}
//
//struct MarkdownView: View {
//    let markdownText: String
//
//    var body: some View {
//        ScrollView {
//            VStack(alignment: .leading, spacing: 10) {
//                MarkdownTextView(markdownText: markdownText)
//                    .font(.body)
//                    .padding()
//            }
//        }
//    }
//}
//
//struct MarkdownTextView: UIViewRepresentable {
//    let markdownText: String
//
//    func makeUIView(context: Context) -> UILabel {
//        let label = UILabel()
//     
//        return label
//    }
//
//    func updateUIView(_ label: UILabel, context: Context) {
//        let markdownParser = MarkdownParser()
//        do {
//            let attributedString = try markdownParser.parse(markdownText)
//            label.attributedText = attributedString
//        } catch {
//            print("Error rendering Markdown: \(error)")
//            label.text = markdownText
//        }
//    }
//}







 

