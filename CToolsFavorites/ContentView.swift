//
//  ContentView.swift
//  CToolsFavorites
//
//  Created by lizitao on 2023/9/11.
//

import SwiftUI
import ToolsFavorites

/*
 ideas:
 
 1. 时间计算器，随便输入两个日期时间，可以计算时间差；设置一个时间，每天帮你计算倒计时；
 
 2. 安全二维码，扫描一下，翻译出二维码链接；
 
 3.
 
 */

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
            .navigationTitle("Tools Favorites")
            .background(Color.yellow)
        }
    }
    
}

struct DetailView: View {
    let text: String
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        Text("Detail Page for \(text)")
            .navigationBarTitle(text)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading:
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
            .foregroundColor(Color.indigo.opacity(0.3))
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
        .background(Color.yellow)
    }
}
