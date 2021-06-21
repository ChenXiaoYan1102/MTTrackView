//
//  MTAnnotationView.h
//  Demo
//
//  Created by APPLE on 2021/6/3.
//

#import <MapKit/MapKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MTAnnotationView : MKAnnotationView

+ (instancetype)dequeueAnnotationViewWithMap:(MKMapView *)mapView annotation:(id <MKAnnotation>)annotation;

@end

NS_ASSUME_NONNULL_END
