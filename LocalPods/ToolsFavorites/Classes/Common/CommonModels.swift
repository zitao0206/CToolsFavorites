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


 

