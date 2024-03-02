//
//  BabyRecordDetailView.swift
//  BabyRecord
//
//  Created by lizitao on 2024-03-02.
//

import SwiftUI

public struct BabyRecordDetailView: View {
    
    @State var selectedTab: Int = 0
    
    let item: ToolItem
    
    public init(item: ToolItem) {
        self.item = item
    }
     
    public var body: some View {
        BabyRecordAddView()
        .commmonNavigationBar(title: item.title, displayMode: .automatic)
  
    }
    
   

}

