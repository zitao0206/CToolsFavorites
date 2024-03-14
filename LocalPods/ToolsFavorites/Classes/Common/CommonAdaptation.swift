//
//  CommonAdaptation.swift
//  ToolsFavorites
//
//  Created by lizitao on 2024-03-14.
//

import SwiftUI

extension View {
    func applyAdaptativeScrollIndicators() -> some View {
        #if !os(macOS) // Check if the target platform is not macOS
        if #available(iOS 16.0, *) {
            return self.scrollIndicators(.hidden) // Apply vertical scroll indicators
        }
        #endif
        return self
    }
    
    func applyAdaptativeBold() -> some View {
        #if !os(macOS) // Check if the target platform is not macOS
        if #available(iOS 16.0, *) {
            return self.bold()
        }
        #endif
        return self
    }
}
