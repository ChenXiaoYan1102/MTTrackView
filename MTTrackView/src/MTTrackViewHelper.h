//
//  MTTrackViewHelper.h
//  MTTrackView
//
//  Created by APPLE on 2021/6/10.
//  Copyright © 2021 MT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXTERN NSBundle *mttrackview_resourceBundle(Class class);

//#define MTLocalizedString(key) \
//[MTTrackViewHelper localizedStringForKey:key]

//#define MTTrackViewLocalizedImage(key) \
//[MTTrackViewHelper imageNamed:key]

@interface MTTrackViewHelper : NSObject

//+ (NSString *)localizedStringForKey:(NSString *)key;

+ (UIImage *)imageNamed:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
