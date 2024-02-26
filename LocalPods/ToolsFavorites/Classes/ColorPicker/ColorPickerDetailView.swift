//
//  ColorPickerDetailView.swift
//  ToolsFavorites
//
//  Created by zitao0206 on 2024/2/22.
//

import SwiftUI
import UIKit

public struct ColorPickerDetailView: View {
   
    let item: ToolItem
    
    public init(item: ToolItem) {
        self.item = item
    }
    
    @Environment(\.presentationMode) var presentationMode
    
    
    @State private var selectedColor: UIColor = .white
    
    public var body: some View {
        VStack {
            ColorPickerContentViewControllerWrapper()
        }
        .commmonNavigationBar(title: item.title, displayMode: .automatic)
        .onAppear {
            
        }
    }
    
}
 

class ColorPickerContentViewController: UIViewController, EFColorSelectionViewControllerDelegate {
    
    let colorSelectionController = EFColorSelectionViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addChild(colorSelectionController)
        
        self.preferredContentSize = colorSelectionController.view.systemLayoutSizeFitting(
            UIView.layoutFittingCompressedSize
        )

        colorSelectionController.isColorTextFieldHidden = false
        colorSelectionController.delegate = self
        colorSelectionController.color = UIColor.white
        
 
        self.view.addSubview(colorSelectionController.view)
        
    }
    
    
    // MARK:- EFColorSelectionViewControllerDelegate
    func colorViewController(_ colorViewCntroller: EFColorSelectionViewController, didChangeColor color: UIColor) {


        print("New color: " + color.debugDescription)
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
//            // 在10秒后执行的代码块
//            print("10秒后执行的操作")
//            self.colorSelectionController.color = UIColor.white
//        }

    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        colorSelectionController.view.frame = CGRect(x: CGFloat(0.0), y: CGFloat(0.0), width: view.bounds.width, height: view.bounds.height)
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
