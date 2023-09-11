//
//  NSBundle+AKOBundle.m
//  Pods
//
//  Created by Leon on 03/30/2021.
//  Copyright (c) 2021 Leon. All rights reserved.
//

#import "NSBundle+AKOBundle.h"

@implementation NSBundle (AKOBundle)

+ (instancetype)ako_bundleWithPodName:(NSString *)podName
{
    if (!podName) {
        return [NSBundle mainBundle];
    }
    NSString *identifier = [NSString stringWithFormat:@"org.cocoapods.%@", [podName stringByReplacingOccurrencesOfString:@"_" withString:@"-"]];
    NSBundle *bundle = [NSBundle bundleWithIdentifier:identifier];
    if (bundle) {
        return bundle;
    }
    NSURL *url = [[NSBundle mainBundle] URLForResource:podName withExtension:@"bundle"];
    if (url) {
        bundle = [NSBundle bundleWithURL:url];
    }
 
    return bundle ?: [NSBundle mainBundle];
}

@end
