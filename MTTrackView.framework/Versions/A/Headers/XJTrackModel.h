//
//  XJTrackModel.h
//  Demo
//
//  Created by APPLE on 2021/6/3.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XJTrackModel : NSObject <NSCopying>
//坐标
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
//正标题
@property (nonatomic, copy, nullable) NSString *title;
//副标题
@property (nonatomic, copy, nullable) NSString *subtitle;
//图标对象
@property (nonatomic, strong, nullable) UIImage *icon;

@end

NS_ASSUME_NONNULL_END
