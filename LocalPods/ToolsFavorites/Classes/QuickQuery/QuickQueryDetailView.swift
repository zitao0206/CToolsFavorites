//
//  QRCodeReaderDetailView.swift
//  ToolsFavorites
//
//  Created by zitao0206 on 2024/2/15.
//

import SwiftUI
import AVKit
import Photos

public struct QuickQueryDetailView: View {

    let item: ToolItem
    
    public init(item: ToolItem) {
        self.item = item
    }
    
    @Environment(\.presentationMode) var presentationMode
    
    public var body: some View {
        VStack {
            // Your view content here
        }
        .commmonNavigationBar(title: item.title, displayMode: .automatic)
        .onAppear {
            // Additional logic on appear if needed
        }
    }
}





 

