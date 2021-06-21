//
//  MTAnnotationView.m
//  Demo
//
//  Created by APPLE on 2021/6/3.
//

#import "MTAnnotationView.h"
#import "MTAnnotationModel.h"

@implementation MTAnnotationView

+ (instancetype)dequeueAnnotationViewWithMap:(MKMapView *)mapView annotation:(id <MKAnnotation>)annotation {

    static NSString *ID = @"MTMKAnnotationViewIdentifier";
    if ([annotation isKindOfClass:[MTAnnotationModel class]]) {
        MTAnnotationModel *model = (MTAnnotationModel *)annotation;

        MTAnnotationView *annoView = (MTAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:ID];

        if (annoView == nil) {

            annoView = [[MTAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:ID];
        }
        
        annoView.annotation = annotation;
        annoView.image = model.icon;

        return annoView;
    }

    return nil;
}

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

@end
