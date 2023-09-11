//
//  UIImage+AKOBundle.m
//  Pods
//
//  Created by Leon on 03/30/2021.
//  Copyright (c) 2021 Leon. All rights reserved.
//

#import "UIImage+AKOBundle.h"
#import "NSBundle+AKOBundle.h"

@implementation UIImage (AKOBundle)

+ (UIImage *)ako_imageNamed:(NSString *)name withBundleName:(NSString *)bundleName
{
        
    if (!name) {
        return nil;
    }
    return [UIImage imageNamed:name inBundle:[NSBundle ako_bundleWithPodName:bundleName] compatibleWithTraitCollection:nil];
}

+ (nullable UIImage *)ako_animatedImageNamed:(NSString *)name
                                duration:(NSTimeInterval)duration
                           withBundleName:(NSString *)bundleName
{
    if (!name) return nil;
    NSMutableArray <UIImage *> *images = [NSMutableArray array];
    NSInteger i = 0;
    UIImage *image = nil;
    do {
        image = [self ako_imageNamed:[NSString stringWithFormat:@"%@%zd", name, i++]
                           withBundleName:bundleName];
        if (image) {
            [images addObject:image];
        }
    } while (image != nil || i < 2);
    return [self animatedImageWithImages:images duration:duration];
}

@end
