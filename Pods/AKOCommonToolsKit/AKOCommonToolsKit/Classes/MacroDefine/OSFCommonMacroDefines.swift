//
//  OSFCommonMacroDefines.swift
//  AKOCommonToolsKit
//
//  Created by zitao on 2022/12/16.
//

import Foundation

public struct SizeDefault {
    public static let screenWidth = UIScreen.main.bounds.size.width
    public static let screenHeight = UIScreen.main.bounds.size.height
    public static let screenScale = UIScreen.main.scale
    public static let screenCenterX = screenWidth / 2.0
    public static let screenCenterY = screenHeight / 2.0
    public static let onePixelPointValue = (1.0 / screenScale)
    public static let applicationWidth = min(screenWidth, screenHeight)
    public static let applicationHeight = max(screenWidth, screenHeight)
    public static let isIPhoneXSeries = AKOISIPhoneXSeries()
    public static let navigationBarHeight: CGFloat = 44
    public static let statusBarHeight: CGFloat = AKOISIPhoneXSeries() ? 44 : 20
    public static let tabBarBottomMargin: CGFloat = (AKOISIPhoneXSeries() ? 34 : 0)

}

extension UIDevice {
    public static let ako = SizeDefault.self
}

public struct ColorDefine {
    @available(iOS 11.0, *)
    public static let violet = UIColor(named: "violet")!
    @available(iOS 11.0, *)
    public static let cyan = UIColor(named: "cyan")!
    @available(iOS 11.0, *)
    public static let windowLightPurple = UIColor(named: "windowLightPurple")!
    @available(iOS 11.0, *)
    public static let windowDarkPurple = UIColor(named: "windowDarkPurple")!
    @available(iOS 11.0, *)
    public static let pink = UIColor(named: "pink")!
    @available(iOS 11.0, *)
    public static let panelPurple = UIColor(named: "panelPurple")!
}


extension UIColor {
   public static let ako = ColorDefine.self
}



