//
//  ContentView.swift
//  CToolsFavorites
//
//  Created by lizitao on 2023/9/11.
//

import SwiftUI
import ToolsFavorites
import AKOCommonToolsKit

struct ContentView: View {
  
    let gridItems: [GridItem] = {
        if GeneralDevice.isPad {
            // 1 Columns
            return Array(repeating: GridItem(.flexible(), spacing: 10), count: 1)
        } else {
            // 2 Colums
            return Array(repeating: GridItem(.flexible(), spacing: 10), count: 2)
        }
    }()
    
    @State private var toolItems: [ToolItem] = [
        
        ToolItem(title: "Base Conversion", imageType: "number.square.fill"),
        ToolItem(title: "Date Calculation", imageType: "calendar.badge.plus"),
        
        ToolItem(title: "QR Code", imageType: "qrcode"),
        ToolItem(title: "Color Picker", imageType: "sun.min"),
    
  
//        ToolItem(title: "Online Program", imageType: "keyboard.badge.eye"),
        ToolItem(title: "Quick Query", imageType: "q.circle"),
        ToolItem(title: "Daily Amount Record", imageType: "pencil.tip.crop.circle.badge.plus"),
      
    ]

    private func contentViewForToolItem(_ toolItem: ToolItem) -> some View {

          switch toolItem.title {
          case "Base Conversion":
              return AnyView(NumberSystemConversionDetailView(item: toolItem))
          case "Date Calculation":
              return AnyView(DateCalculationDetailView(item: toolItem))
          case "QR Code":
              return AnyView(QRCodeDetailView(item: toolItem))
          case "Color Picker":
              return AnyView(ColorPickerDetailView(item: toolItem))
//          case "Online Program":
//              return AnyView(OnlineProgramDetailView(item: toolItem))
          case "Quick Query":
              return AnyView(QuickQueryDetailView(item: toolItem))
          case "Daily Amount Record":
              return AnyView(AmountRecordDetailView(item: toolItem))
          default:
              return AnyView(DemoDetailView(item: toolItem))
          }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: gridItems, spacing: 15) {
                    ForEach(toolItems.indices, id: \.self) { index in
                        let toolItem = toolItems[index]
                        NavigationLink(destination: contentViewForToolItem(toolItem)) {
                            GridItemView(imageType: toolItem.imageType, title: toolItem.title)
                                .padding(.horizontal, 20)
                        }.id(toolItem.title)
                    }
                }
            }
            .padding()
            .navigationBarTitle("Favorite Tools", displayMode: .automatic)
            .onReceive(NotificationCenter.default.publisher(for: .moveItemToFirstNotification)) { notification in
                if let intValue = notification.object as? Int {
                    self.moveItemToFirst(intValue)
                }
            }
        }
    }
    
    private func moveItemToFirst(_ index: Int) {
        
    }
}



struct GridItemView: View {
  
    let imageType: String
    let title: String
    
    var body: some View {
        VStack {
            Image(systemName: imageType)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
            Text(title)
                .foregroundColor(DarkMode.isDarkMode ? .white : .black)
                .font(.system(size: 12))
        }
        .padding()
        .frame(width: (UIDevice.ako.screenWidth - 80)/2.0, height: 120)
        .background(Color.black.opacity(0.1))
        .background(DarkMode.isDarkMode ? Color.white.opacity(0.1) : Color.black.opacity(0.1))
        .cornerRadius(10)
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
