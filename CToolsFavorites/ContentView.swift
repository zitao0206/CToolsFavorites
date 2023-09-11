//
//  ContentView.swift
//  CToolsFavorites
//
//  Created by lizitao on 2023/9/11.
//

import SwiftUI
import Favorites

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
            SimpleAlertView()
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
