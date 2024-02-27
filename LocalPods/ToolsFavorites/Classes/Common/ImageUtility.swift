//
//  QRCodeReaderDetailView.swift
//  ToolsFavorites
//
//  Created by zitao0206 on 2024/2/15.
//

import Foundation
import UIKit
import Photos

class ImageUtility {
    static func saveImageToAlbum(_ image: UIImage) {
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: image)
        }) { (success, error) in
            if success {
                print("The image has been saved to the album.")
            } else {
                print("Save failed：\(error?.localizedDescription ?? "")")
            }
        }
    }
    
    static func loadImage(named imageName: String) -> UIImage? {
        guard let imageBundlePath = Bundle.main.path(forResource: "CToolsFavorites-Images", ofType: "bundle"),
              let imageBundle = Bundle(path: imageBundlePath),
              let imageURL = imageBundle.url(forResource: imageName, withExtension: "png"),
              let imageData = try? Data(contentsOf: imageURL),
              let uiImage = UIImage(data: imageData) else {
            return nil
        }
        return uiImage
    }
}







 

