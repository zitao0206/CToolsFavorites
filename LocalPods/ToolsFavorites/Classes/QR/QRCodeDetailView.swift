//
//  QRCodeDetailView.swift
//  ToolsFavorites
//
//  Created by lizitao on 2024-02-24.
//

import SwiftUI
import Foundation

public struct QRCodeDetailView: View {
   
    @State private var selectedOption = 0
    
    let options = ["QR Code Generator", "QR Code Reader"]
    
    let text: String
    
    public init(text: String) {
        self.text = text
    }
    
    @Environment(\.presentationMode) var presentationMode

    public var body: some View {
        
        VStack {
            Picker("Select Option", selection: $selectedOption) {
                ForEach(0 ..< options.count) {
                    Text(self.options[$0])
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            if selectedOption == 0 {
                QRCodeGeneratorDetailView()
            } else {
                QRCodeReaderDetailView()
            }
        }

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
