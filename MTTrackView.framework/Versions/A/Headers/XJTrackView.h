//
//  XJTrackView.h
//  Demo
//
//  Created by APPLE on 2021/6/3.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XJTrackModel;

@interface XJTrackView : MKMapView

- (instancetype)initWithOriginTrackModel:(XJTrackModel *)originTrackModel
                   destinationTrackModel:(XJTrackModel *)destinationTrackModel;

@end

NS_ASSUME_NONNULL_END
