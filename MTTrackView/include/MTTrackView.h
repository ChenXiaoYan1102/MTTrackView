//
//  MTTrackView.h
//  Demo
//
//  Created by APPLE on 2021/6/3.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MTTrackModel;

@interface MTTrackView : MKMapView

- (instancetype)initWithOriginTrackModel:(MTTrackModel * _Nonnull)originTrackModel
                   destinationTrackModel:(MTTrackModel * _Nonnull)destinationTrackModel;

- (void)updateOriginTrackModel:(MTTrackModel * _Nonnull)originTrackModel;

@end

NS_ASSUME_NONNULL_END
