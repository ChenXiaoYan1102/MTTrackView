//
//  MTTrackView.m
//  Demo
//
//  Created by APPLE on 2021/6/3.
//

#import <MTTrackView/MTTrackView.h>
#import <MTTrackView/MTTrackModel.h>
#import <MTTrackView/MTTrackViewHelper.h>

#import <CoreLocation/CoreLocation.h>

#import "MTAnnotationModel.h"
#import "MTAnnotationView.h"

@interface MTTrackView () <MKMapViewDelegate, CLLocationManagerDelegate>

@property (nonatomic, strong) MTTrackModel *originTrackModel;

@property (nonatomic, strong) MTTrackModel *destinationTrackModel;
 
@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation MTTrackView

- (instancetype)initWithDestinationTrackModel:(MTTrackModel *)destinationTrackModel {
    
    return [self initWithOriginTrackModel:nil destinationTrackModel:destinationTrackModel];
}

- (instancetype)initWithOriginTrackModel:(MTTrackModel *)originTrackModel destinationTrackModel:(MTTrackModel *)destinationTrackModel {
    if (self = [super init]) {
        if (self.originTrackModel &&
            [originTrackModel isKindOfClass:[MTTrackModel class]]) {
            self.originTrackModel = [originTrackModel copy];
        }
        if ([destinationTrackModel isKindOfClass:[MTTrackModel class]]) {
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
    if (!self.originTrackModel) {
        [self.locationManager startUpdatingLocation];
        return;
    }

    MKMapItem *originItem = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:self.originTrackModel.coordinate addressDictionary:nil]];
    
    MKMapItem *destinationItem = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:self.destinationTrackModel.coordinate addressDictionary:nil]];
    
    [self removeAnnotations:[self annotations]];
    
    //添加标注
    MTAnnotationModel *originAnno = [[MTAnnotationModel alloc] init];
    originAnno.coordinate = self.originTrackModel.coordinate;
    originAnno.title = self.originTrackModel.title;
    originAnno.subtitle = self.originTrackModel.subtitle;
    originAnno.icon = self.originTrackModel.icon ? self.originTrackModel.icon : [MTTrackViewHelper imageNamed:@"mt_location_begin_icon"];
    [self addAnnotation:originAnno];
    
    MTAnnotationModel *destAnno = [[MTAnnotationModel alloc] init];
    destAnno.coordinate = self.destinationTrackModel.coordinate;
    destAnno.title = self.destinationTrackModel.title;
    destAnno.subtitle = self.destinationTrackModel.subtitle;
    destAnno.icon = self.destinationTrackModel.icon ? self.destinationTrackModel.icon : [MTTrackViewHelper imageNamed:@"mt_location_end_icon"];

    [self addAnnotation:destAnno];
    
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

#pragma mark - CLLocationManagerDelegate
/**
*  更新到位置之后调用
*
*  @param manager   位置管理者
*  @param locations 位置数组
*/
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:( NSArray *)locations {
    //停止位置更新
    [manager stopUpdatingLocation];
    
    CLLocation *location = [locations firstObject];
    
    __weak typeof(self) weakSelf = self;
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (!error) {
            for (CLPlacemark *place in placemarks) {
                NSLog(@" 定位经纬度 %f,%f",place.location.coordinate.latitude, place.location.coordinate.longitude);
                weakSelf.originTrackModel = [[MTTrackModel alloc] init];
                weakSelf.originTrackModel.coordinate = place.location.coordinate;
                [weakSelf setupData];
                break;
            }
        } else {
            NSLog(@"%@",error);
        }
    }];
}

#pragma mark - Lazy load
//获取当前位置
- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        CLLocationManager * locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self ;
        //kCLLocationAccuracyBest:设备使用电池供电时候最高的精度
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        locationManager.distanceFilter = 50.0f;
        if (([[[ UIDevice currentDevice] systemVersion] doubleValue] >= 8.0))
        {
            [locationManager requestAlwaysAuthorization];
        }
       _locationManager = locationManager;
    }
    return _locationManager;
}

@end
