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

- (instancetype)initWithOriginTrackModel:(MTTrackModel * _Nullable)originTrackModel
                   destinationTrackModel:(MTTrackModel * _Nonnull)destinationTrackModel;

- (instancetype)initWithDestinationTrackModel:(MTTrackModel *)destinationTrackModel;

@end

NS_ASSUME_NONNULL_END
