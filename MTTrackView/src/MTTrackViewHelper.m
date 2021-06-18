//
//  MTTrackViewHelper.m
//  MTTrackView
//
//  Created by APPLE on 2021/6/10.
//  Copyright © 2021 MT. All rights reserved.
//

#import "MTTrackViewHelper.h"

NSBundle *mttrackview_resourceBundle(Class class) {
    static NSBundle *MTTrackViewBundle = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        MTTrackViewBundle = [NSBundle bundleForClass:class];
        if (MTTrackViewBundle) {
            NSString *resourceBundlePath = [MTTrackViewBundle pathForResource:@"MTTrackViewBundle" ofType:@"bundle"];
            if (resourceBundlePath && [[NSFileManager defaultManager] fileExistsAtPath:resourceBundlePath]) {
                MTTrackViewBundle = [NSBundle bundleWithPath:resourceBundlePath];
            }
        }
    });
    return MTTrackViewBundle;
}

@implementation MTTrackViewHelper

+ (NSString *)localizedStringForKey:(NSString *)key {
    
    return [mttrackview_resourceBundle([self class]) localizedStringForKey:(key) value:@"" table:nil];
}

+ (UIImage *)imageNamed:(NSString *)name {
    
    return [UIImage imageNamed:name inBundle:mttrackview_resourceBundle([self class]) compatibleWithTraitCollection:nil];
}

@end
