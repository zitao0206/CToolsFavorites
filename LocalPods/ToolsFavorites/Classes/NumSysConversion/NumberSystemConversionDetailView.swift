//
//  NumberSystemConversionDetailView.swift
//  ToolsFavorites
//
//  Created by zitao0206 on 2024/2/15.
//

import SwiftUI

public struct NumberSystemConversionDetailView: View {
    
    let item: ToolItem
    
    public init(item: ToolItem) {
        self.item = item
    }
    
    @State private var formatEnabled = true // 添加一个开关状
    @State private var decimalValue: String = ""
    @State private var decimalFormatValue: String = ""
    @State private var binaryValue: String = ""
    @State private var hexadecimalValue: String = ""
    @State private var octalValue: String = ""
    
    @Environment(\.presentationMode) var presentationMode
    
    public var body: some View {
        VStack {
            Toggle("Enable Format", isOn: $formatEnabled) // 添加开关
                .font(.system(size: 15))
                .bold()
                .padding()
                .onChange(of: formatEnabled) { newValue in
                    updateFormattedValues()
                }
                .padding(.bottom, 20) // 减少底部间距
            
            HStack(alignment: .bottom, spacing: 10) {
                
                Spacer().frame(width: 10)
                Text("Decimal")
                    .foregroundColor(.black.opacity(0.3))
                    .font(.system(size: 14))
                    .padding(.top, 10) // 向下移动
                
                Spacer()
                
                Button {
                    if let clipboardValue = UIPasteboard.general.string {
                        decimalValue = clipboardValue
                    }
                } label: {
                    Text("Paste")
                        .foregroundColor(.black)
                }
                .buttonStyle(.bordered)
                
                Spacer().frame(width: 10)
                
                Button {
                    UIPasteboard.general.string = decimalValue
                } label: {
                    Text("Copy")
                        .foregroundColor(.black)
                }
                .buttonStyle(.bordered)
            
                Spacer().frame(width: 10)
            }
            .padding(.bottom, -10) // 减少底部间距

            TextField("Decimal", text: $decimalValue)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .onChange(of: decimalValue) { newValue in
                    decimalValue = formatDecimalValue(newValue)
                }

            
            HStack(alignment: .bottom, spacing: 10) {
                Spacer().frame(width: 10)
                
                Text("Binary")
                    .foregroundColor(.black.opacity(0.3))
                    .font(.system(size: 14))
                    .padding(.top, 10) // 向下移动
                
                Spacer()
                
                Button {
                    if let clipboardValue = UIPasteboard.general.string {
                        binaryValue = clipboardValue
                    }
                } label: {
                    Text("Paste")
                        .foregroundColor(.black)
                }
                .buttonStyle(.bordered)
                
                Spacer().frame(width: 10)
                
                Button {
                    UIPasteboard.general.string = binaryValue
                } label: {
                    Text("Copy")
                        .foregroundColor(.black)
                }
                .buttonStyle(.bordered)
                
                Spacer().frame(width: 10)
            }
            .padding(.bottom, -10) // 减少底部间距

            TextField("Binary", text: $binaryValue)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .onChange(of: binaryValue) { newValue in
                    binaryValue = formatBinaryValue(newValue)
                }
            
            HStack(alignment: .bottom, spacing: 10) {
                Spacer().frame(width: 10)
                
                Text("Hexadecimal")
                    .foregroundColor(.black.opacity(0.3))
                    .font(.system(size: 14))
                    .padding(.top, 10) // Move downwards
                
                Spacer()
                
                Button {
                    if let clipboardValue = UIPasteboard.general.string {
                        hexadecimalValue = clipboardValue
                    }
                } label: {
                    Text("Paste")
                        .foregroundColor(.black)
                }
                .buttonStyle(.bordered)
                
                Spacer().frame(width: 10)
                
                Button {
                    UIPasteboard.general.string = hexadecimalValue
                } label: {
                    Text("Copy")
                        .foregroundColor(.black)
                }
                .buttonStyle(.bordered)
                
                Spacer().frame(width: 10)
            }
            .padding(.bottom, -10) // Reduce bottom spacing
            
            TextField("Hexadecimal", text: $hexadecimalValue)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .onChange(of: hexadecimalValue) { newValue in
                 hexadecimalValue = formatHexadecimalValue(newValue)
                }
            
            HStack(alignment: .bottom, spacing: 10) {
                Spacer().frame(width: 10)
                
                Text("Octal")
                    .foregroundColor(.black.opacity(0.3))
                    .font(.system(size: 14))
                    .padding(.top, 10) // Move downwards
                
                Spacer()
                
                Button {
                    if let clipboardValue = UIPasteboard.general.string {
                        octalValue = clipboardValue
                    }
                } label: {
                    Text("Paste")
                        .foregroundColor(.black)
                }
                .buttonStyle(.bordered)
                
                Spacer().frame(width: 10)
                
                Button {
                    UIPasteboard.general.string = octalValue
                } label: {
                    Text("Copy")
                        .foregroundColor(.black)
                }
                .buttonStyle(.bordered)
                
                Spacer().frame(width: 10)
            }
            .padding(.bottom, -10) // Reduce bottom spacing
            
            TextField("Octal", text: $octalValue)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .onChange(of: octalValue) { newValue in
                  octalValue = formatOctalValue(newValue)
                }

        }
        .padding(.top, -140) // 减少顶部间距
        .commmonNavigationBar(title: item.title, displayMode: .automatic)
        .onAppear {
            updateFormattedValues()
//            NotificationCenter.default.post(name: .moveItemToFirstNotification, object: self.index)
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
            hexadecimalValue = formatHexadecimalValue(convertOctalToHexadecimal(newValue))
        }
        

    }
    
    private func updateFormattedValues() {
        decimalValue = formatDecimalValue(decimalValue)
        binaryValue = formatBinaryValue(binaryValue)
        hexadecimalValue = formatHexadecimalValue(hexadecimalValue)
        octalValue = formatOctalValue(octalValue)
    }

}


// number format
extension NumberSystemConversionDetailView {
    
    func isAllZeroString(_ binaryString: String) -> Bool {
        // 使用正则表达式检查字符串是否只包含 0 和 1
        let regex = #"^[0]+$"#
        let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
        let res = predicate.evaluate(with: binaryString)
        
        return res
    }
    
    func isValidDecimalString(_ octalString: String) -> Bool {
        // 使用正则表达式检查字符串是否只包含十进制字符
        let regex = #"^[0-9]+$"#
        let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
        return predicate.evaluate(with: octalString)
    }
    
    private func formatDecimalValue(_ value: String) -> String {
        
        let cleanedValue = value.replacingOccurrences(of: ",", with: "") // 移除逗号
        
        if cleanedValue.count <= 0 {
            return cleanedValue
        }
        
        if cleanedValue.count > 0 && (!isValidDecimalString(cleanedValue) || isAllZeroString(cleanedValue)){
            return "0"
        }
        
        if !formatEnabled {
            return cleanedValue
        }

        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "en_US")
        guard let intValue = Int(cleanedValue), let formattedValue = formatter.string(from: NSNumber(value: intValue)) else {
            return "0"
        }
        return formattedValue
    }

    
    func isValidBinaryString(_ binaryString: String) -> Bool {
        // 使用正则表达式检查字符串是否只包含 0 和 1
        let regex = #"^[01]+$"#
        let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
        let res = predicate.evaluate(with: binaryString)
        
        return res
    }
    
    private func formatBinaryValue(_ value: String) -> String {
       
        let cleanedValue = value.replacingOccurrences(of: " ", with: "") // 移除空格
        
        if cleanedValue.count <= 0 {
            return cleanedValue
        }

        if cleanedValue.count > 0 && (!isValidBinaryString(cleanedValue) || isAllZeroString(cleanedValue)){
            return "0"
        }
        
        
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

    func isValidHexString(_ hexString: String) -> Bool {
        // 使用正则表达式检查字符串是否只包含十六进制字符
        let regex = #"^[0-9A-Fa-f]+$"#
        let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
        return predicate.evaluate(with: hexString)
    }
    
    private func formatHexadecimalValue(_ value: String) -> String {
        let cleanedValue = value.replacingOccurrences(of: " ", with: "") // 移除空格
        
        if cleanedValue.count <= 0 {
            return cleanedValue
        }
        
        if cleanedValue.count > 0 && (!isValidHexString(cleanedValue) || isAllZeroString(cleanedValue)){
            return "0"
        }
        
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
    
    
    func isValidOctalString(_ octalString: String) -> Bool {
        // 使用正则表达式检查字符串是否只包含八进制字符
        let regex = #"^[0-7]+$"#
        let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
        return predicate.evaluate(with: octalString)
    }

    
    private func formatOctalValue(_ value: String) -> String {
        
        let cleanedValue = value.replacingOccurrences(of: " ", with: "") // 移除空格
        
        if cleanedValue.count <= 0 {
            return cleanedValue
        }
        
        if cleanedValue.count > 0 && (!isValidOctalString(cleanedValue) || isAllZeroString(cleanedValue)) {
            return "0"
        }
        
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
            return ""
        }
        
        // 使用 Swift 的 String 格式化功能将整数转换为二进制字符串
        return String(decimalValue, radix: 2)
    }
    
    
    private func convertDecimalToHexadecimal(_ value: String) -> String {
        let cleanedValue = value.replacingOccurrences(of: "[, ]", with: "", options: .regularExpression)
        guard let decimalValue = Int(cleanedValue), decimalValue >= 0 else {
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
            return "0"
        }
        // Convert decimal value back to string
        return String(decimalValue)
    }
    
    private func convertBinaryToHexadecimal(_ value: String) -> String {
        let cleanedValue = value.replacingOccurrences(of: "[, ]", with: "", options: .regularExpression)
        // Convert binary string to decimal
        guard let decimalValue = Int(cleanedValue, radix: 2) else {
            // Invalid input, return empty string
            return "0"
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
            return "0"
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

