//
//  AmountRecordDetailView.swift
//  AmountRecord
//
//  Created by lizitao on 2024-03-02.
//

import SwiftUI

public struct AmountRecordDetailView: View {
    
    @State var selectedTab: Int = 0
    
    let item: ToolItem
    
    public init(item: ToolItem) {
        self.item = item
    }
     
    @State private var showingSettings = false
    
    public var body: some View {
        TabView(selection: $selectedTab) {
            AmountRecordAddView()
              .tag(0)
              .tabItem {
                  Label("Add", systemImage: "plus.circle.fill")
              }
            AmountRecordHistoryView()
              .tag(1)
              .tabItem {
                  Label("History", systemImage: "clock")
              }
        }
   
        NavigationLink(destination: AmountRecordSettingView(), isActive: $showingSettings) {
            EmptyView()
        }
        .navigationBarItems(trailing: Button(action: {
            showingSettings = true
        }) {
            Image(systemName: "gearshape")
                .font(.system(size: 16))
                .foregroundColor(DarkMode.isDarkMode ? .white : .black)
        })
        .commmonNavigationBar(title: item.title, displayMode: .inline)
    }
    
   

}

