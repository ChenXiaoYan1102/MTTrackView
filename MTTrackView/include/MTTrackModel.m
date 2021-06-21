//
//  MTTrackModel.m
//  Demo
//
//  Created by APPLE on 2021/6/3.
//

#import <MTTrackView/MTTrackModel.h>
#import "MTTrackViewHelper.h"

@implementation MTTrackModel

- (instancetype)init {
    if (self = [super init]) {
        self.title = @"";
        self.subtitle = @"";
        
        self.coordinate = CLLocationCoordinate2DMake(0.0, 0.0);
    }
    
    return self;
}

- (instancetype)copyWithZone:(NSZone *)zone {

    MTTrackModel *model =  [[[self class] allocWithZone:zone] init];
    
    model.coordinate = self.coordinate;
    
    model.title = [self.title copy];
    
    model.subtitle = [self.subtitle copy];
    
    model.icon = [self.icon copy];
    
    return model;
}

@end
