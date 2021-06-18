//
//  XJAnnotationView.m
//  Demo
//
//  Created by APPLE on 2021/6/3.
//

#import "XJAnnotationView.h"
#import "XJAnnotationModel.h"

@implementation XJAnnotationView

- (instancetype)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier]) {
        // 设置显示标题
        self.canShowCallout = YES;
        // 设置辅助视图
        self.leftCalloutAccessoryView = [[UISwitch alloc] init];
        self.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeContactAdd];
    }

    return self;
}

+ (instancetype)annotationViewWithMap:(MKMapView *)mapView {

    static NSString *ID = @"XJMKAnnotationViewIdentifier";

    // 1. 从缓存中取

    // [注意] 默认情况下, MKAnnotationView 是无法显示的, 如果想自定义大头针, 需要使用MKAnnotationView的子类 MKPinAnnotationView

    // [注意] 如果是自定义的大头针, 默认情况点击大头针不会显示标题和副标题, 需要手动设置显示

    XJAnnotationView *annoView = (XJAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:ID];

    // 2. 如果缓存中没有, 创建一个新的大头针
    if (annoView == nil) {

        annoView = [[XJAnnotationView alloc] initWithAnnotation:nil reuseIdentifier:ID];
    }

    return annoView;
}

- (void)setAnnotation:(XJAnnotationModel *)annotation {

    [super setAnnotation:annotation];

    //设置图片
    self.image = annotation.icon;
}

@end
