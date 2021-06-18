//
//  XJAnnotationView.h
//  Demo
//
//  Created by APPLE on 2021/6/3.
//

#import <MapKit/MapKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XJAnnotationView : MKAnnotationView

+ (instancetype)annotationViewWithMap:(MKMapView *)mapView;

@end

NS_ASSUME_NONNULL_END
