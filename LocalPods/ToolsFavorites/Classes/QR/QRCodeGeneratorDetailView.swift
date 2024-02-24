//
//  QRCodeGeneratorDetailView.swift
//  ToolsFavorites
//
//  Created by zitao0206 on 2024/2/15.
//

import SwiftUI
import AKOCommonToolsKit
import CoreImage
import CoreImage.CIFilterBuiltins
import Photos

public struct QRCodeGeneratorDetailView: View {
    
    @State private var qrCodeImage: UIImage?
    @State private var userInput: String = ""
    @State var showAlert: Bool = false
    @State var saveErrorInfo: String = ""
     

    public var body: some View {
 
        VStack {
            
            HStack {
                Spacer() // 将 Paste 按钮和输入框推到右侧
                Button {
                  if let clipboardValue = UIPasteboard.general.string {
                      userInput = clipboardValue
                  }
                } label: {
                  Text("Paste")
                      .foregroundColor(.black)
                }
                .buttonStyle(.bordered)
                
                Button {
                    UIPasteboard.general.string = userInput
                } label: {
                    Text("Copy")
                        .foregroundColor(.black)
                }
                .buttonStyle(.bordered)
            
                Spacer().frame(width: 10)
            }
                
            TextField("Enter text...", text: $userInput)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: UIDevice.ako.screenWidth - 20)
                .onChange(of: userInput) { newValue in
                    userInput = newValue
                }
            
            Spacer().frame(height: 20)
            
            Button("Generate QR Code") {
                if let data = generateQRCode(from: userInput) {
                    if let codeImage = UIImage(data: data) {
                        qrCodeImage = codeImage
                    }
                }
            }
            .buttonStyle(.bordered)
            .disabled(userInput.isEmpty)
            
            ZStack {
                if let qrCodeImage = qrCodeImage {
                    Image(uiImage: qrCodeImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200, height: 200) // Adjust size as needed
                } else {
                    PlaceholderEmptyView()
                }
            }
 
            Button("Save to Photo Library") {
                if let qrCodeImage = qrCodeImage {
                    saveImageToAlbum(qrCodeImage)
                }
            }
            .buttonStyle(.bordered)
            .disabled(qrCodeImage == nil) // Disable button if qrCodeImage is nil
            .alert(isPresented: $showAlert, content: {
                if saveErrorInfo.isEmpty {
                    return Alert(
                        title: Text("Successfully"),
                        message: Text("The picture has been saved to the album."),
                        dismissButton: .default(Text("OK"))
                    )
                } else {
                    return Alert(
                        title: Text("Error"),
                        message: Text(saveErrorInfo),
                        dismissButton: .default(Text("Confirm"))
                    )
                }
            })

        }
        Spacer()
    }
    
    private func generateQRCode(from string: String) -> Data? {
        
        let filter = CIFilter(name: "CIQRCodeGenerator")
        let data = string.data(using: .ascii, allowLossyConversion: false)
        filter?.setValue(data, forKey: "inputMessage")
        let transform = CGAffineTransform(scaleX: 5, y: 5)


        if let image = filter?.outputImage?.transformed(by: transform) {
            let uiImage = UIImage(ciImage: image)
            return uiImage.pngData()
        }

        return nil
    }
     
    func saveImageToAlbum(_ image: UIImage) {
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: image)
        }) { (success, error) in
            if success {
                print("The image has been saved to the album.")
                saveErrorInfo = ""
                showAlert.toggle()
            } else {
                print("Save failed：\(error?.localizedDescription ?? "")")
                saveErrorInfo = "Save failed：\(error?.localizedDescription ?? "")"
                showAlert.toggle()
            }
        }
    }
    
    

}

struct PlaceholderEmptyView: View {
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.3)
            VStack {
                Image(systemName: "photo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .padding()
                Text("qr image will be here.")
                    .foregroundColor(.black)
            }
        }
        .frame(width: 200, height: 200)
        .cornerRadius(10)
        .padding()
    }
}
