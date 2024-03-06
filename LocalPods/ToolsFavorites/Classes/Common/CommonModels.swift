//
//  QRCodeReaderDetailView.swift
//  ToolsFavorites
//
//  Created by zitao0206 on 2024/2/15.
//

import SwiftUI

extension Notification.Name {
    public static let moveItemToFirstNotification = Notification.Name("MoveItemToFirstNotification")
}

public struct ToolItem {
    public let title: String
    public let imageType: String
    
    public init(title: String, imageType: String) {
        self.title = title
        self.imageType = imageType
    }
}

public struct DarkMode {
    public static var isDarkMode: Bool {
        let dark = UIApplication.shared.windows.first?.rootViewController?.traitCollection.userInterfaceStyle == .dark
        return dark
    }
}

public struct GeneralDevice {
    public static var isPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
}


 

