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
    

    let gridItems = Array(repeating: GridItem(.flexible(), spacing: 10), count: 2) // 创建3列的网格
    
    @State private var toolItems: [ToolItem] = [
        
        ToolItem(title: "Base Conversion", imageType: "number.square.fill"),
        ToolItem(title: "Date Calculation", imageType: "calendar.badge.plus"),
        
        ToolItem(title: "QR Code", imageType: "qrcode"),
        ToolItem(title: "Color Picker", imageType: "sun.min"),
    
  
//        ToolItem(title: "Online Program", imageType: "keyboard.badge.eye"),
        ToolItem(title: "Amount Record", imageType: "pencil.tip.crop.circle.badge.plus"),
        ToolItem(title: "Quick Query", imageType: "q.circle"),
      
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
          case "Amount Record":
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
                        NavigationLink(destination: contentViewForToolItem(toolItems[index])) {
                            GridItemView(imageType: toolItems[index].imageType, title: toolItems[index].title)
                                .padding(.horizontal, 20)
                        }
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
        guard index != 0 && index < toolItems.count else { return }
//        devTools.insert(devTools.remove(at: index), at: 0)
//        // Update UserDefaults
//        let titles = devTools.map { $0.title }
//        let imageTypes = devTools.map { $0.imageType }
//        UserDefaults.standard.set(titles, forKey: "cachedTitles")
//        UserDefaults.standard.set(imageTypes, forKey: "cachedImageTypes")
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


//private func destinationView(for index: Int, title: String) -> some View {
//    
//    switch index {
//    case 0:
//        return AnyView(NumberSystemConversionDetailView(text: title, index: index))
//    case 1:
//        return AnyView(DateCalculationDetailView(text: title, index: index))
//    case 2:
//        return AnyView(QRCodeDetailView(text: title, index: index))
//    case 3:
//        return AnyView(ColorPickerDetailView(text: title, index: index))
//    default:
//        return AnyView(DemoDetailView(text: title, index: index))
//    }
//}

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
