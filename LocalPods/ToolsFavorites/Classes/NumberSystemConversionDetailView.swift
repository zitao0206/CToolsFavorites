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
    @State private var decimalFormatValue: String = ""
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
                .onChange(of: formatEnabled) { newValue in
                    updateFormattedValues()
                }
            
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
                .onChange(of: binaryValue) { newValue in
                    if formatEnabled {
                        binaryValue = formatBinaryValue(newValue)
                    }
                }
            
            Text("Hexadecimal")
            TextField("Hexadecimal", text: $hexadecimalValue)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .onChange(of: hexadecimalValue) { newValue in
                    if formatEnabled {
                        hexadecimalValue = formatHexadecimalValue(newValue)
                    }
                }
            
            Text("Octal")
            TextField("Octal", text: $octalValue)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .onChange(of: octalValue) { newValue in
                    if formatEnabled {
                        octalValue = formatOctalValue(newValue)
                    }
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
            updateFormattedValues()
        }
        .onChange(of: decimalValue) { newValue in
            binaryValue = formatBinaryValue(convertDecimalToBinary(newValue))
            hexadecimalValue = formatHexadecimalValue(convertDecimalToHexadecimal(newValue))
            octalValue = formatOctalValue(convertDecimalToOctal(newValue))
        }
        .onChange(of: binaryValue) { newValue in
            decimalValue = formatDecimalValue(convertBinaryToDecimal(newValue))
            hexadecimalValue = formatHexadecimalValue(convertBinaryToHexadecimal(newValue))
            octalValue = formatOctalValue(convertBinaryToOctal(newValue))
        }
        .onChange(of: hexadecimalValue) { newValue in
            decimalValue = formatDecimalValue(convertHexadecimalToDecimal(newValue))
            binaryValue = formatBinaryValue(convertHexadecimalToBinary(newValue))
            octalValue = formatOctalValue(convertHexadecimalToOctal(newValue))
        }
        .onChange(of: octalValue) { newValue in
            decimalValue = formatDecimalValue(convertOctalToDecimal(newValue))
            binaryValue = formatBinaryValue(convertOctalToBinary(newValue))
            hexadecimalValue = formatOctalValue(convertOctalToHexadecimal(newValue))
        }

    }
    
    private func updateFormattedValues() {
        decimalValue = formatBinaryValue(decimalValue)
        binaryValue = formatBinaryValue(binaryValue)
        hexadecimalValue = formatBinaryValue(hexadecimalValue)
        octalValue = formatBinaryValue(octalValue)
    }

}


// number format
extension NumberSystemConversionDetailView {
    
    private func formatDecimalValue(_ value: String) -> String {
        let cleanedValue = value.replacingOccurrences(of: ",", with: "") // 移除逗号
        
        if !formatEnabled {
            return cleanedValue
        }

        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "en_US")
        guard let intValue = Int(cleanedValue),
              let formattedValue = formatter.string(from: NSNumber(value: intValue)) else {
            return ""
        }
        return formattedValue
    }
    
    private func formatBinaryValue(_ value: String) -> String {
        let cleanedValue = value.replacingOccurrences(of: " ", with: "") // 移除空格
        
        if !formatEnabled {
            return cleanedValue
        }
        
        var formattedValue = ""
        var counter = 0
        for char in cleanedValue.reversed() {
            if counter != 0 && counter % 4 == 0 {
                formattedValue.insert(" ", at: formattedValue.startIndex)
            }
            formattedValue.insert(char, at: formattedValue.startIndex)
            counter += 1
        }
        return formattedValue
    }

    private func formatHexadecimalValue(_ value: String) -> String {
        let cleanedValue = value.replacingOccurrences(of: " ", with: "") // 移除空格
        
        if !formatEnabled {
            return cleanedValue
        }
        
        var formattedValue = ""
        var counter = 0
        for char in cleanedValue.reversed() {
            if counter != 0 && counter % 4 == 0 {
                formattedValue.insert(" ", at: formattedValue.startIndex)
            }
            formattedValue.insert(char, at: formattedValue.startIndex)
            counter += 1
        }
        return formattedValue
    }
    
    private func formatOctalValue(_ value: String) -> String {
        
        let cleanedValue = value.replacingOccurrences(of: " ", with: "") // 移除空格
        
        if !formatEnabled {
            return cleanedValue
        }
        
        var formattedValue = ""
        var counter = 0
        for char in cleanedValue.reversed() {
            if counter != 0 && counter % 3 == 0 {
                formattedValue.insert(" ", at: formattedValue.startIndex)
            }
            formattedValue.insert(char, at: formattedValue.startIndex)
            counter += 1
        }
        
        return formattedValue
    }
}


// number convertion
extension NumberSystemConversionDetailView {
    
    private func convertDecimalToBinary(_ value: String) -> String {
        
        let cleanedValue = value.replacingOccurrences(of: "[, ]", with: "", options: .regularExpression)

        guard let decimalValue = Int(cleanedValue) else {
            // 输入的值无效，返回空字符串
            return ""
        }
        
        // 使用 Swift 的 String 格式化功能将整数转换为二进制字符串
        return String(decimalValue, radix: 2)
    }
    
    
    private func convertDecimalToHexadecimal(_ value: String) -> String {
        let cleanedValue = value.replacingOccurrences(of: "[, ]", with: "", options: .regularExpression)
        // 确保输入值是非负的整数
        guard let decimalValue = Int(cleanedValue), decimalValue >= 0 else {
            // 输入的值无效，返回空字符串
            return ""
        }
        
        // 使用 Swift 的 String 格式化功能将整数转换为十六进制字符串
        return String(decimalValue, radix: 16).uppercased() // 将结果转换为大写
    }
    
   

    private func convertDecimalToOctal(_ value: String) -> String {
        let cleanedValue = value.replacingOccurrences(of: "[, ]", with: "", options: .regularExpression)
        // 确保输入值是非负的整数
        guard let decimalValue = Int(cleanedValue), decimalValue >= 0 else {
            // 输入的值无效，返回空字符串
            return ""
        }
        
        // 使用 Swift 的 String 格式化功能将整数转换为八进制字符串
        return String(decimalValue, radix: 8)
    }
    
    private func convertBinaryToDecimal(_ value: String) -> String {
        let cleanedValue = value.replacingOccurrences(of: "[, ]", with: "", options: .regularExpression)
        // Convert binary string to decimal
        guard let decimalValue = Int(cleanedValue, radix: 2) else {
            // Invalid input, return empty string
            return ""
        }
        // Convert decimal value back to string
        return String(decimalValue)
    }
    
    private func convertBinaryToHexadecimal(_ value: String) -> String {
        let cleanedValue = value.replacingOccurrences(of: "[, ]", with: "", options: .regularExpression)
        // Convert binary string to decimal
        guard let decimalValue = Int(cleanedValue, radix: 2) else {
            // Invalid input, return empty string
            return ""
        }
        // Convert decimal value to hexadecimal string
        let hexadecimalValue = String(decimalValue, radix: 16)
        return hexadecimalValue.uppercased()
    }

    private func convertBinaryToOctal(_ value: String) -> String {
        let cleanedValue = value.replacingOccurrences(of: "[, ]", with: "", options: .regularExpression)
        // Convert binary string to decimal
        guard let decimalValue = Int(cleanedValue, radix: 2) else {
            // Invalid input, return empty string
            return ""
        }
        // Convert decimal value to octal string
        let octalValue = String(decimalValue, radix: 8)
        return octalValue
    }


    private func convertHexadecimalToDecimal(_ value: String) -> String {
        let cleanedValue = value.replacingOccurrences(of: "[, ]", with: "", options: .regularExpression)
        // Convert hexadecimal string to decimal
        guard let decimalValue = Int(cleanedValue, radix: 16) else {
            // Invalid input, return empty string
            return ""
        }
        // Convert decimal value back to string
        return String(decimalValue)
    }
    
    private func convertHexadecimalToBinary(_ value: String) -> String {
        let cleanedValue = value.replacingOccurrences(of: "[, ]", with: "", options: .regularExpression)
        // Convert hexadecimal string to decimal
        guard let decimalValue = Int(cleanedValue, radix: 16) else {
            // Invalid input, return empty string
            return ""
        }
        // Convert decimal value to binary string
        let binaryValue = String(decimalValue, radix: 2)
        return binaryValue
    }

    private func convertHexadecimalToOctal(_ value: String) -> String {
        let cleanedValue = value.replacingOccurrences(of: "[, ]", with: "", options: .regularExpression)
        // Convert hexadecimal string to decimal
        guard let decimalValue = Int(cleanedValue, radix: 16) else {
            // Invalid input, return empty string
            return ""
        }
        // Convert decimal value to octal string
        let octalValue = String(decimalValue, radix: 8)
        return octalValue
    }


    private func convertOctalToDecimal(_ value: String) -> String {
        let cleanedValue = value.replacingOccurrences(of: "[, ]", with: "", options: .regularExpression)
        // Convert octal string to decimal
        guard let decimalValue = Int(cleanedValue, radix: 8) else {
            // Invalid input, return empty string
            return ""
        }
        // Convert decimal value back to string
        return String(decimalValue)
    }
    
    private func convertOctalToBinary(_ value: String) -> String {
        let cleanedValue = value.replacingOccurrences(of: "[, ]", with: "", options: .regularExpression)
        // Convert octal string to decimal
        guard let decimalValue = Int(cleanedValue, radix: 8) else {
            // Invalid input, return empty string
            return ""
        }
        // Convert decimal value to binary string
        let binaryValue = String(decimalValue, radix: 2)
        return binaryValue
    }

    private func convertOctalToHexadecimal(_ value: String) -> String {
        let cleanedValue = value.replacingOccurrences(of: "[, ]", with: "", options: .regularExpression)
        // Convert octal string to decimal
        guard let decimalValue = Int(cleanedValue, radix: 8) else {
            // Invalid input, return empty string
            return ""
        }
        // Convert decimal value to hexadecimal string
        let hexadecimalValue = String(decimalValue, radix: 16)
        
        return hexadecimalValue.uppercased()
    }
}

