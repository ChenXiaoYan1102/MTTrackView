//
//  MTTrackView.m
//  Demo
//
//  Created by APPLE on 2021/6/3.
//

#import <MTTrackView/MTTrackView.h>
#import <MTTrackView/MTTrackModel.h>
#import <MTTrackView/MTTrackViewHelper.h>

#import "MTAnnotationModel.h"
#import "MTAnnotationView.h"

@interface MTTrackView () <MKMapViewDelegate>

@property (nonatomic, strong) MTTrackModel *originTrackModel;

@property (nonatomic, strong) MTTrackModel *destinationTrackModel;

@end

@implementation MTTrackView

- (instancetype)initWithOriginTrackModel:(MTTrackModel *)originTrackModel destinationTrackModel:(MTTrackModel *)destinationTrackModel {
    if (self = [super init]) {
        if (originTrackModel &&
            [originTrackModel isKindOfClass:[MTTrackModel class]]) {
            self.originTrackModel = [originTrackModel copy];
        } else {
            self.originTrackModel = [[MTTrackModel alloc] init];
        }
        if (destinationTrackModel &&
            [destinationTrackModel isKindOfClass:[MTTrackModel class]]) {
            self.destinationTrackModel = [destinationTrackModel copy];
        } else {
            self.destinationTrackModel = [[MTTrackModel alloc] init];
        }
        
        self.delegate = self;
        
        [self setupData];
    }
    
    return self;
}

- (void)setupData {

    MKMapItem *originItem = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:self.originTrackModel.coordinate addressDictionary:nil]];
    
    MKMapItem *destinationItem = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:self.destinationTrackModel.coordinate addressDictionary:nil]];
    
    [self removeAnnotations:[self annotations]];
    
    if (self.originTrackModel.coordinate.longitude != 0 &&
        self.originTrackModel.coordinate.latitude != 0) {
        //添加标注
        MTAnnotationModel *originAnno = [[MTAnnotationModel alloc] init];
        originAnno.coordinate = self.originTrackModel.coordinate;
        originAnno.title = self.originTrackModel.title;
        originAnno.subtitle = self.originTrackModel.subtitle;
        originAnno.icon = self.originTrackModel.icon ? self.originTrackModel.icon : [MTTrackViewHelper imageNamed:@"mt_location_begin_icon"];
        [self addAnnotation:originAnno];
    }
    
    MTAnnotationModel *destAnno = [[MTAnnotationModel alloc] init];
    destAnno.coordinate = self.destinationTrackModel.coordinate;
    destAnno.title = self.destinationTrackModel.title;
    destAnno.subtitle = self.destinationTrackModel.subtitle;
    destAnno.icon = self.destinationTrackModel.icon ? self.destinationTrackModel.icon : [MTTrackViewHelper imageNamed:@"mt_location_end_icon"];

    [self addAnnotation:destAnno];
    
    //如果只有终点，则不进行路径规划
    if (self.annotations.count <= 1) {
        [self showVisibleRegion];
        return;
    }
    
    //创建路线请求
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];

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

#pragma mark - Public
- (void)updateOriginTrackModel:(MTTrackModel * _Nonnull)originTrackModel {
    if (originTrackModel &&
        [originTrackModel isKindOfClass:[MTTrackModel class]]) {
        self.originTrackModel = [originTrackModel copy];
    } else {
        self.originTrackModel = [[MTTrackModel alloc] init];
    }
    
    [self setupData];
}

#pragma mark - Custom Method
//显示终点区域
- (void)showVisibleRegion {
    //计算中心点
    CLLocationCoordinate2D centCoor = self.destinationTrackModel.coordinate;
    
    //计算地理位置的跨度 0.03为误差值
    MKCoordinateSpan span;
    span.latitudeDelta = 0.03;
    span.longitudeDelta = 0.03;
    
    //得出数据的坐标区域
    MKCoordinateRegion region = MKCoordinateRegionMake(centCoor, span);
    [self setRegion:region];
}

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
    
    //计算地理位置的跨度 0.03为误差值
    MKCoordinateSpan span;
    span.latitudeDelta = maxLat - minLat + 0.03;
    span.longitudeDelta = maxLon - minLon + 0.03;
    
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
    render.lineWidth = 3;

    return render;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if (![annotation isKindOfClass:[MTAnnotationModel class]]) {
        return nil;
    }
    
    MTAnnotationView *pin = [MTAnnotationView dequeueAnnotationViewWithMap:mapView annotation:annotation];
    
    return pin;
}

@end
