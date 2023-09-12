//
//  ContentView.swift
//  CToolsFavorites
//
//  Created by lizitao on 2023/9/11.
//

import SwiftUI
import ToolsFavorites

struct ContentView: View {
    let gridItems = Array(repeating: GridItem(.flexible(), spacing: 10), count: 2) // 创建3列的网格
    let titles = ["One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight"]
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: gridItems, spacing: 10) {
                    ForEach(0..<6, id: \.self) { index in
                        NavigationLink(destination: DetailView(text: titles[index])) {
                            GridItemView(title: titles[index])
                        }
                    }
                }
            }
            .padding()
            .padding()
            .navigationTitle("All Inboxes")
        }
    }
    
}

struct DetailView: View {
    let text: String
    @Environment(\.presentationMode) var presentationMode // 获取presentationMode
    var body: some View {
        Text("Detail Page for \(text)")
            .navigationBarTitle(text) // 设置详情页标题
            .navigationBarBackButtonHidden(true) //隐藏默认的返回按钮
            .navigationBarItems(leading: // 添加自定义返回按钮
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.blue)
                }
            )
    }
}

struct GridItemView: View {
    let title: String

    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .foregroundColor(Color.blue)
            .frame(height: 90)
            .overlay(
                Text(title)
                    .foregroundColor(.white)
                    .font(.title)
            )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
