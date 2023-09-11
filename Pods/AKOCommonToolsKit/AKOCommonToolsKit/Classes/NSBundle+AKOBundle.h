//
//  NSBundle+AKOBundle.h
//  Pods
//
//  Created by Leon on 03/30/2021.
//  Copyright (c) 2021 Leon. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSBundle (AKOBundle)

+ (instancetype __nullable)ako_bundleWithPodName:(NSString * __nullable)podName;

@end

#define AKOPodBundle [NSBundle ako_bundleWithPodName:NE_MODULE_NAME]

NS_ASSUME_NONNULL_END
