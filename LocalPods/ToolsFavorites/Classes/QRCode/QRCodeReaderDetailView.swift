//
//  QRCodeReaderDetailView.swift
//  ToolsFavorites
//
//  Created by zitao0206 on 2024/2/15.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

public struct QRCodeReaderDetailView: View {
    @State private var isShowingImagePicker = false
    @State private var selectedImage: UIImage?
    @State private var translatedResult: String?
    
   
    public var body: some View {
        VStack {
            Button {
                selectedImage = nil
                translatedResult = nil
            } label: {
                Text("Clear")
                    .foregroundColor(.black)
                    .font(.system(size: 15))
                    .bold()
            }
            .buttonStyle(.bordered)
            
            ZStack {
                if let image = selectedImage {
                  Image(uiImage: image)
                      .resizable()
                      .aspectRatio(contentMode: .fit)
                      .frame(width: 200, height: 200) // Adjust size as needed
                      .padding()
                } else {
                    PlaceholderView(isShowingImagePicker: $isShowingImagePicker)
                        .sheet(isPresented: $isShowingImagePicker) {
                            ImagePicker(selectedImage: $selectedImage) { image in
                                // Image selection callback
                                self.scanQRCode(from: image)
                            }
                        }
                        
                }
            }
            .padding(.bottom, -100) // Reduce bottom spacing
            
            VStack {
                Text("Output")
                    .font(.headline)

                if let translatedResult = translatedResult {
                    
                    VStack(alignment: .center, spacing: 10) {
                        Text(translatedResult)
                          .padding()
                          .background(Color.black.opacity(0.1))
                          .cornerRadius(8)

                        Button {
                            UIPasteboard.general.string = translatedResult
                        } label: {
                            Text("Copy")
                                .foregroundColor(.black)
                                .font(.system(size: 14))
                        }
                        .buttonStyle(.bordered)
                    }
                } else {
                    Text("QR Code translation will appear here")
                        .padding()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.bottom, 100) 
 
        }
    }
    
    private func scanQRCode(from image: UIImage) {
          guard let ciImage = CIImage(image: image) else { return }
          
          let context = CIContext()
          let options = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
          guard let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: context, options: options) else { return }
          
          let features = detector.features(in: ciImage)
          for feature in features as! [CIQRCodeFeature] {
              self.translatedResult = feature.messageString ?? ""
          }
      }
}

struct PlaceholderView: View {
    @Binding var isShowingImagePicker: Bool
    
    var body: some View {
        Button(action: {
            isShowingImagePicker.toggle()
        }) {
            ZStack {
                Color.gray.opacity(0.3)
                VStack {
                    Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .padding()
                    Text("Select image here.")
                        .foregroundColor(.black)
                }
            }
            .frame(width: 200, height: 200)
            .cornerRadius(10)
            .padding()
        }
    }
}


struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) var presentationMode
    let completionHandler: (UIImage) -> Void // 将 completionHandler 添加到 ImagePicker 中

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: ImagePicker
        var completionHandler: (UIImage) -> Void // 添加 completionHandler 到 Coordinator 中

        init(parent: ImagePicker, completionHandler: @escaping (UIImage) -> Void) {
            self.parent = parent
            self.completionHandler = completionHandler
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.selectedImage = uiImage
                completionHandler(uiImage) // 在 Coordinator 内部调用 completionHandler
            }

            parent.presentationMode.wrappedValue.dismiss()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self, completionHandler: completionHandler) // 传递 completionHandler 给 Coordinator
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}



extension QRCodeReaderDetailView {
    
    
}

