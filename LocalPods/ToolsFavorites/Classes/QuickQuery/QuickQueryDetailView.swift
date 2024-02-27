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
    
    let gridItems = Array(repeating: GridItem(.flexible(), spacing: 10), count: 2) // 创建3列的网格
    @State private var items: [String] = [
        "iPhone Devices",
        "Power of 2 Table",
        "Date Calculation",
        "QR Code",
        "Color Picker",
        "Online Program",
        "Quick Query",
    ]
    
    public var body: some View {
        ScrollView {
            LazyVGrid(columns: gridItems, spacing: 15) { // 垂直间距
                ForEach(items.indices, id: \.self) { index in
                    NavigationLink(destination: contentViewForItem(items[index])) {
                        HStack {
                            Spacer()
                            Text(items[index])
                            Spacer()
                        }
                        .frame(height: 50) // 设置每个项目的高度为 50
                        .padding(.horizontal, 10) // 设置左右间距
                        .background(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 0)
                                .stroke(Color.blue, lineWidth: 1) // 右侧边框线
                        )
                        .alignmentGuide(.leading) { _ in 0 } // 将文本居中
                    }
                }
            }
        }
        .padding(.horizontal, 20) // 设置整个列表左右间距

        Spacer()
        .commmonNavigationBar(title: item.title, displayMode: .automatic)
        .onAppear {
            // Additional logic on appear if needed
        }
    }
}

private func contentViewForItem(_ title: String) -> some View {
      switch title {
      case "iPhone Devices":
          return AnyView(AlliPhoneDevicesInfoDetailView(title: title))

      case "Power of 2 Table":
          return AnyView(PowerOfTwoTableDetailView(title: title))
      default:
          return AnyView(AlliPhoneDevicesInfoDetailView(title: title))
      }
}

public struct AlliPhoneDevicesInfoDetailView: View {
    let title: String
    
    public init(title: String) {
        self.title = title
    }
    
    public var body: some View {
        ScrollView {
            VStack {
                if let image = ImageUtility.loadImage(named: "alliphonedevicesinfo") {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .contextMenu {
                            Button(action: {
                                if let image = ImageUtility.loadImage(named: "alliphonedevicesinfo") {
                                    ImageUtility.saveImageToAlbum(image)
                                }
                            }) {
                                Text("Save to Photos")
                                Image(systemName: "square.and.arrow.down")
                            }
                        }
                    
                } else {
                    Text("Failed to load image")
                }
                
            }
            .padding()
        }
        .commmonNavigationBar(title: title, displayMode: .automatic)
    }

}



 
public struct PowerOfTwoTableDetailView: View {

    let title: String
    
    public init(title: String) {
        self.title = title
    }
    
    public var body: some View {
        
        ScrollView {
            VStack {
                if let image = ImageUtility.loadImage(named: "poweroftwotable") {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .contextMenu {
                            Button(action: {
                                if let image = ImageUtility.loadImage(named: "poweroftwotable") {
                                    ImageUtility.saveImageToAlbum(image)
                                }
                            }) {
                                Text("Save to Photos")
                                Image(systemName: "square.and.arrow.down")
                            }
                        }
                } else {
                    Text("Failed to load image")
                }
            }
            .padding()
        }
        .commmonNavigationBar(title: title, displayMode: .automatic)
        
    }
}
