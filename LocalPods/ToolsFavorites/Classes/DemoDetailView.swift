//
//  QRCodeReaderDetailView.swift
//  ToolsFavorites
//
//  Created by zitao0206 on 2024/2/15.
//

import SwiftUI
import AVKit
import Photos

extension Notification.Name {
    public static let moveItemToFirstNotification = Notification.Name("MoveItemToFirstNotification")
}

public struct ToolItem {
    public let title: String
    public let imageType: String
    
    public init(title: String, imageType: String) {
        self.title = title
        self.imageType = imageType
    }
}


public struct DemoDetailView: View {

    let item: ToolItem
    
    public init(item: ToolItem) {
        self.item = item
    }
    
    @Environment(\.presentationMode) var presentationMode
    
    public var body: some View {
        VStack {
             
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
//            NotificationCenter.default.post(name: .moveItemToFirstNotification, object: self.index)
        }
    }
}




 

