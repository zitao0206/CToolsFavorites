//
//  ContentView.swift
//  CToolsFavorites
//
//  Created by lizitao on 2023/9/11.
//

import SwiftUI
import ToolsFavorites
import AKOCommonToolsKit

/*
 ideas:
 
 1. 进制的转换，二进制是多少等等
 
 2.日期转换器：
 
 时间计算器，随便输入两个日期时间，可以计算时间差；设置一个时间，每天帮你计算倒计时；
 
 3. 安全二维码，扫描一下，翻译出二维码链接；
 
 */

struct ContentView: View {
    
    let gridItems = Array(repeating: GridItem(.flexible(), spacing: 10), count: 2) // 创建3列的网格
    @State private var titles = ["Number System Conversion", "Date Conversion", "QR Code Reader", "QR Code Generator", "Num Sys Conversion", "Num Sys Conversion", "Num Sys Conversion", "Num Sys Conversion"]
    @State private var imageTypes = ["number.square.fill", "calendar.badge.plus", "qrcode.viewfinder", "qrcode", "calendar", "calendar", "calendar", "calendar"]
    
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor.black, // 设置导航标题颜色为白色
            .font: UIFont.systemFont(ofSize: 24, weight: .bold) // 设置导航字体大小和粗细
        ]
        UINavigationBar.appearance().standardAppearance = appearance
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: gridItems, spacing: 15) { //垂直间距
                    ForEach(0..<6, id: \.self) { index in
                        NavigationLink(destination: destinationView(for: index, title: titles[index])) {
                           GridItemView(imageType: imageTypes[index], title: titles[index])
                               .padding(.horizontal, 20)
                        }
                    }
                }
            }
            .padding()
            .padding()
            .navigationBarTitle("Dev Tools Favorites", displayMode: .automatic)
        }
    }
    
}

struct GridItemView: View {
    let imageType: String
    let title: String
    

    var body: some View {
        VStack {
            Image(systemName: imageType) // 这里使用了一个示例图标，你可以替换为你想要的图标名称
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
            Text(title)
                .foregroundColor(.black)
                .font(.system(size: 12))
        }
        .padding()
        .frame(width: (UIDevice.ako.screenWidth - 80)/2.0, height: 120) // 调整整体高度以适应图标和文本
        .background(Color.black.opacity(0.1))
        .cornerRadius(10)
    }
}


private func destinationView(for index: Int, title: String) -> some View {
    switch index {
    case 0:
        return AnyView(NumberSystemConversionDetailView(text: title))
    case 2:
        return AnyView(QRCodeReaderDetailView(text: title))
    case 3:
        return AnyView(QRCodeGeneratorDetailView(text: title))
    default:
        return AnyView(DetailView(text: title))
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
                        .foregroundColor(.black)
                }
            )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        .background(Color.yellow)
    }
}
