//
//  QRCodeReaderDetailView.swift
//  ToolsFavorites
//
//  Created by zitao0206 on 2024/2/15.
//

import SwiftUI

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


struct NavigationBarModifier: ViewModifier {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    let title: String
    let displayMode: NavigationBarItem.TitleDisplayMode
    
    func body(content: Content) -> some View {
        content
            .navigationBarTitle(title, displayMode: displayMode)
            .font(.system(size: 10))
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading:
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.black)
                }
            )
    }
}

extension View {
    func commmonNavigationBar(title: String, displayMode: NavigationBarItem.TitleDisplayMode) -> some View {
        self.modifier(NavigationBarModifier(title: title, displayMode: displayMode))
    }
}






 

