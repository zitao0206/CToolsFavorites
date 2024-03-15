//
//  CommonDarkModeAdaptation.swift
//  ToolsFavorites
//
//  Created by lizitao on 2024-03-14.
//

import SwiftUI

public struct DarkMode {
    public static var isDarkMode: Bool {
        let dark = UIApplication.shared.windows.first?.rootViewController?.traitCollection.userInterfaceStyle == .dark
        return dark
    }
    
    public static var adaptiveAddDisableColor : Color {
        return DarkMode.isDarkMode ? Color.white.opacity(0.3) : Color.black.opacity(0.3)
    }
    
    public static var adaptiveAddEnableColor : Color {
        return Color.blue
    }
}
