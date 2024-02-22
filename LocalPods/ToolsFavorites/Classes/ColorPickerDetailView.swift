//
//  ColorPickerDetailView.swift
//  ToolsFavorites
//
//  Created by zitao0206 on 2024/2/22.
//

import SwiftUI
import UIKit

public struct ColorPickerDetailView: View {
   
    public init(text: String) {
        self.text = text
    }
    
    let text: String
    @Environment(\.presentationMode) var presentationMode
    
    
    @State private var selectedColor: UIColor = .white
    
    public var body: some View {
        VStack {
            ColorPickerContentViewControllerWrapper()
        }
          .padding()

        .navigationBarTitle(text, displayMode: .automatic)
        .font(.system(size: 10))
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading:
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "arrow.left")
                    .foregroundColor(.black)
            }
        )
        .onAppear {
            // Any additional setup logic
        }
    }
    
}
 

class ColorPickerContentViewController: UIViewController, ColorPickerViewDelegate {
    
    lazy var colorPickerView: ColorPickerView = {
        let colorPicker = ColorPickerView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        colorPicker.delegate = self // 设置委托对象
        return colorPicker
    }()
      
    override func viewDidLoad() {
        super.viewDidLoad()
        
        colorPickerView.delegate = self
            
        view.backgroundColor = .green
        self.view.addSubview(colorPickerView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
      
        let centerX = view.bounds.width / 2
        let centerY = view.bounds.height / 2
        let colorPickerWidth: CGFloat = 200
        let colorPickerHeight: CGFloat = 200
        let colorPickerX = centerX - colorPickerWidth / 2
        let colorPickerY = 0//centerY - colorPickerHeight / 2
        colorPickerView.frame = CGRect(x: colorPickerX, y: CGFloat(colorPickerY), width: colorPickerWidth, height: colorPickerHeight)
    }

    
    // -- ColorPickerViewDelegate
     
    func colorPickerWillBeginDragging(_ colorPicker: ColorPickerView) {
        
    }
    
    func colorPickerDidEndDagging(_ colorPicker: ColorPickerView) {
        
    }
    
    func colorPickerDidSelectColor(_ colorPicker: ColorPickerView) {
         // Can get the selected color from the color picker
         let color = colorPicker.selectedColor
    }
}

struct ColorPickerContentViewControllerWrapper: UIViewControllerRepresentable {
 
    func makeUIViewController(context: Context) -> ColorPickerContentViewController {
        return ColorPickerContentViewController()
    }
    
    // 当 MyViewControllerWrapper 视图更新时，可以执行一些操作
    func updateUIViewController(_ uiViewController: ColorPickerContentViewController, context: Context) {
        // 在此方法中，您可以更新 MyViewController 的任何属性或执行其他操作
    }
}
