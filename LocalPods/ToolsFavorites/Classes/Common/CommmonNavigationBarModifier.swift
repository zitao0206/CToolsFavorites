//
//  CommmonNavigationBarModifier.swift
//  ToolsFavorites
//
//  Created by lizitao on 2024-02-27.
//

import SwiftUI

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
