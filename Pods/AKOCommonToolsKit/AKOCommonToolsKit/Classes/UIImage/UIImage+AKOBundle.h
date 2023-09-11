//
//  UIImage+AKOBundle.h
//  Pods
//
//  Created by Leon on 03/30/2021.
//  Copyright (c) 2021 Leon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (AKOBundle)

+ (UIImage *)ako_imageNamed:(NSString *)name withBundleName:(NSString *)bundleName;

@end

#define AKOImageNamed(...) [UIImage ako_imageNamed:(__VA_ARGS__) withBundleName:MODULE_NAME]

NS_ASSUME_NONNULL_END
