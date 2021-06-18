//
//  XJTrackModel.m
//  Demo
//
//  Created by APPLE on 2021/6/3.
//

#import "XJTrackModel.h"
#import "MTTrackViewHelper.h"

@implementation XJTrackModel

- (instancetype)init {
    if (self = [super init]) {
        self.title = @"";
        self.subtitle = @"";
        self.icon = [MTTrackViewHelper imageNamed:@"mt_location_icon"];
        
        self.coordinate = CLLocationCoordinate2DMake(0.0, 0.0);
    }
    
    return self;
}

- (instancetype)copyWithZone:(NSZone *)zone {

    XJTrackModel *model =  [[[self class] allocWithZone:zone] init];
    
    model.coordinate = self.coordinate;
    
    model.title = [self.title copy];
    
    model.subtitle = [self.subtitle copy];
    
    model.icon = [self.icon copy];
    
    return model;
}

@end
