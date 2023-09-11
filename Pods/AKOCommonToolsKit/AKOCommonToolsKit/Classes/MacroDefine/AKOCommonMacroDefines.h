//
//  AKOCommonMacroDefines.h
//  AKOCommonToolsKit
//
//  Created by Leon0206 on 2019/9/16.
//

#ifndef AKOCommonMacroDefines_h
#define AKOCommonMacroDefines_h

#define kScreenScale  [UIScreen mainScreen].scale
#define kOnePixelPointValue (1.0f / kScreenScale)
#define kScreenWidth  [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height
#define kApplicationWidth  MIN([[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)
#define kApplicationHeight MAX([[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)
#define kScreenCenterX kScreenWidth / 2.0
#define kScreenCenterY kScreenHeight / 2.0

#define isIPhoneXSeries ({  \
    BOOL iPhoneXSeries = NO;  \
    if ([UIDevice currentDevice].userInterfaceIdiom != UIUserInterfaceIdiomPhone) { \
        return iPhoneXSeries; \
    } \
    if (@available(iOS 11.0, *)) { \
        UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window]; \
        if (mainWindow.safeAreaInsets.bottom > 0.0) { \
            iPhoneXSeries = YES; \
        } \
    } \
    iPhoneXSeries; \
})

static inline CGFloat AKOScreenScale()
{
    return [UIScreen mainScreen].scale;
}

static inline CGFloat AKOOnePixelPointValue()
{
    return kScreenScale;
}

static inline CGFloat AKOScreenWidth()
{
    return kScreenWidth;
}

static inline CGFloat AKOScreenHeight()
{
    return kScreenHeight;
}

static inline CGFloat AKOApplicationWidth()
{
    return kApplicationWidth;
}

static inline CGFloat AKOApplicationHeight()
{
    return kApplicationHeight;
}

static inline BOOL AKOISIPhoneXSeries()
{
    BOOL iPhoneXSeries = NO;
    if ([UIDevice currentDevice].userInterfaceIdiom != UIUserInterfaceIdiomPhone) {
        return iPhoneXSeries;
    }
    if (@available(iOS 11.0, *)) {
        UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
        if (mainWindow.safeAreaInsets.bottom > 0.0) {
            iPhoneXSeries = YES;
        }
    }
    return iPhoneXSeries;
}

#endif /* AKOCommonMacroDefines_h */
