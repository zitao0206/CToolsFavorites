//
//  NumberSystemConversionDetailView.swift
//  ToolsFavorites
//
//  Created by zitao0206 on 2024/2/15.
//

import SwiftUI

public struct NumberSystemConversionDetailView: View {
    
    @State private var formatEnabled = true // 添加一个开关状
    @State private var decimalValue: String = ""
    @State private var binaryValue: String = ""
    @State private var hexadecimalValue: String = ""
    @State private var octalValue: String = ""
    
    public init(text: String) {
        self.text = text
    }
    
    let text: String
    @Environment(\.presentationMode) var presentationMode
    
    public var body: some View {
        VStack {
            Toggle("Enable Format", isOn: $formatEnabled) // 添加开关
                          .padding()
            
            Text("Decimal")
            TextField("Decimal", text: $decimalValue)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .onChange(of: decimalValue) { newValue in
                   if formatEnabled {
                       decimalValue = formatDecimalValue(newValue)
                   }
                }
            
            Text("Binary")
            TextField("Binary", text: $binaryValue)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Text("Hexadecimal")
            TextField("Hexadecimal", text: $hexadecimalValue)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Text("Octal")
            TextField("Octal", text: $octalValue)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
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
        .onChange(of: decimalValue) { newValue in
            // Update other fields when decimalValue changes
            // You need to implement conversion functions here
            binaryValue = convertDecimalToBinary(newValue)
            hexadecimalValue = convertDecimalToHexadecimal(newValue)
            octalValue = convertDecimalToOctal(newValue)
        }
        
        // Add onChange for other fields if needed
    }
    
    private func formatDecimalValue(_ value: String) -> String {
        let cleanedValue = value.replacingOccurrences(of: ",", with: "") // 移除逗号
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "en_US")
        guard let intValue = Int(cleanedValue),
              let formattedValue = formatter.string(from: NSNumber(value: intValue)) else {
            return ""
        }
        return formattedValue
    }





    
    private func convertDecimalToBinary(_ value: String) -> String {
        guard let decimalValue = Int(value) else {
            // 输入的值无效，返回空字符串
            return ""
        }
        
        // 使用 Swift 的 String 格式化功能将整数转换为二进制字符串
        return String(decimalValue, radix: 2)
    }

    
    private func convertDecimalToHexadecimal(_ value: String) -> String {
        // 确保输入值是非负的整数
        guard let decimalValue = Int(value), decimalValue >= 0 else {
            // 输入的值无效，返回空字符串
            return ""
        }
        
        // 使用 Swift 的 String 格式化功能将整数转换为十六进制字符串
        return String(decimalValue, radix: 16).uppercased() // 将结果转换为大写
    }

    private func convertDecimalToOctal(_ value: String) -> String {
        // 确保输入值是非负的整数
        guard let decimalValue = Int(value), decimalValue >= 0 else {
            // 输入的值无效，返回空字符串
            return ""
        }
        
        // 使用 Swift 的 String 格式化功能将整数转换为八进制字符串
        return String(decimalValue, radix: 8)
    }

}

