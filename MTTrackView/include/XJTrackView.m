//
//  XJTrackView.m
//  Demo
//
//  Created by APPLE on 2021/6/3.
//

#import <MTTrackView/XJTrackView.h>
#import <MTTrackView/XJTrackModel.h>
#import "XJAnnotationModel.h"
#import "XJAnnotationView.h"

@interface XJTrackView () <MKMapViewDelegate>

@property (nonatomic, strong) XJTrackModel *originTrackModel;

@property (nonatomic, strong) XJTrackModel *destinationTrackModel;

@end

@implementation XJTrackView

- (instancetype)initWithOriginTrackModel:(XJTrackModel *)originTrackModel destinationTrackModel:(XJTrackModel *)destinationTrackModel {
    if (self = [super init]) {
        if ([originTrackModel isKindOfClass:[XJTrackModel class]]) {
            self.originTrackModel = [originTrackModel copy];
        } else {
            self.originTrackModel = [[XJTrackModel alloc] init];
        }
        if ([destinationTrackModel isKindOfClass:[XJTrackModel class]]) {
            self.destinationTrackModel = [destinationTrackModel copy];
        } else {
            self.destinationTrackModel = [[XJTrackModel alloc] init];
        }
        
        
        self.delegate = self;
        
        [self customView];
    }
    
    return self;
}

- (void)customView {
    //添加标注
    XJAnnotationModel *originAnno = [[XJAnnotationModel alloc] init];
    originAnno.coordinate = self.originTrackModel.coordinate;
    originAnno.title = self.originTrackModel.title;
    originAnno.subtitle = self.originTrackModel.subtitle;
    originAnno.icon = self.originTrackModel.icon;
    [self addAnnotation:originAnno];
    
    XJAnnotationModel *destAnno = [[XJAnnotationModel alloc] init];
    destAnno.coordinate = self.destinationTrackModel.coordinate;
    destAnno.title = self.destinationTrackModel.title;
    destAnno.subtitle = self.destinationTrackModel.subtitle;
    destAnno.icon = self.destinationTrackModel.icon;

    [self addAnnotation:destAnno];
    
    MKMapItem *originItem = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:self.originTrackModel.coordinate addressDictionary:nil]];
    
    MKMapItem *destinationItem = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:self.destinationTrackModel.coordinate addressDictionary:nil]];
    
    //1创建路线请求
    MKDirectionsRequest*request = [[MKDirectionsRequest alloc] init];

    //设置起点终点
    request.source = originItem;
    request.destination = destinationItem;

    //创建路线管理器
    MKDirections *direction = [[MKDirections alloc] initWithRequest:request];

    //划线
    [direction calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        for (MKRoute*route in response.routes) {
            //将折现添加到地图
            [self addOverlay:route.polyline];
            
            [self calculateVisibleRegion];
            
            break;
        }
    }];
}

#pragma mark - Custom Method
//计算显示区域
- (void)calculateVisibleRegion {
    //声明解析时对坐标数据的位置区域的筛选，包括经度和纬度的最小值和最大值
    CLLocationDegrees minLat = self.originTrackModel.coordinate.latitude >= self.destinationTrackModel.coordinate.latitude ? self.destinationTrackModel.coordinate.latitude : self.originTrackModel.coordinate.latitude;
    CLLocationDegrees maxLat = self.originTrackModel.coordinate.latitude >= self.destinationTrackModel.coordinate.latitude ? self.originTrackModel.coordinate.latitude : self.destinationTrackModel.coordinate.latitude;
    CLLocationDegrees minLon = self.originTrackModel.coordinate.longitude >= self.destinationTrackModel.coordinate.longitude ? self.destinationTrackModel.coordinate.longitude : self.originTrackModel.coordinate.longitude;
    CLLocationDegrees maxLon = self.originTrackModel.coordinate.longitude >= self.destinationTrackModel.coordinate.longitude ? self.originTrackModel.coordinate.longitude : self.destinationTrackModel.coordinate.longitude;
    
    //计算中心点
    CLLocationCoordinate2D centCoor;
    centCoor.latitude = (CLLocationDegrees)((maxLat+minLat) * 0.5f);
    centCoor.longitude = (CLLocationDegrees)((maxLon+minLon) * 0.5f);
    
    //计算地理位置的跨度 0.08为误差值
    MKCoordinateSpan span;
    span.latitudeDelta = maxLat - minLat + 0.08;
    span.longitudeDelta = maxLon - minLon + 0.08;
    
    //得出数据的坐标区域
    MKCoordinateRegion region = MKCoordinateRegionMake(centCoor, span);
    [self setRegion:region];
}

#pragma mark - MKMapViewDelegate
- (MKOverlayRenderer*)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    //创建渲染器
    MKPolylineRenderer *render = [[MKPolylineRenderer alloc] initWithOverlay:overlay];

    //设置线段的颜色
    render.strokeColor = [UIColor systemBlueColor];

    //设置线宽
    render.lineWidth = 5;

    return render;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if (![annotation isKindOfClass:[XJAnnotationModel class]]) {
        return nil;
    }
    
    XJAnnotationView *pin = [XJAnnotationView annotationViewWithMap:mapView];
    pin.annotation = annotation;
    
    return pin;
}

@end
