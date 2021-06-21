# 
传入两点坐标，在地图上显示这两点的轨迹，
如果只传入目的地坐标，则起点为当前位置《苹果原生地图》

## 调用
```
    MTTrackModel *destModel = [[MTTrackModel alloc] init];
    CGFloat longitude = self.model.longitude.floatValue;
    CGFloat latitude = self.model.latitude.floatValue;
    //目的地经纬度需要进行坐标转换
    destModel.coordinate = [MTCoreLocationTransform transformFromBaiduToGCJ:CLLocationCoordinate2DMake(latitude, longitude)];
    self.trackView = [[MTTrackView alloc] initWithDestinationTrackModel:destModel];
    
    [self.view addSubview:self.trackView];
    
    [self.trackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.leading.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.mas_equalTo(500);
    }];

```