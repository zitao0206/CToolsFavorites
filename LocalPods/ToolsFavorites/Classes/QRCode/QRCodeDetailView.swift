//
//  QRCodeDetailView.swift
//  ToolsFavorites
//
//  Created by lizitao on 2024-02-24.
//

import SwiftUI
import Foundation

public struct QRCodeDetailView: View {
    
    let item: ToolItem
    
    public init(item: ToolItem) {
        self.item = item
    }
   
    @State private var selectedOption = 0
    
    let options = ["QR Code Generator", "QR Code Reader"]
    
    @Environment(\.presentationMode) var presentationMode

    public var body: some View {
        ScrollView {
            VStack {
                Picker("Select Option", selection: $selectedOption) {
                    ForEach(0 ..< options.count) {
                        Text(self.options[$0])
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                if selectedOption == 0 {
                    QRCodeGeneratorDetailView()
                } else {
                    QRCodeReaderDetailView()
                }
            }
            .commmonNavigationBar(title: item.title, displayMode: .automatic)
        }
    }
    
}
