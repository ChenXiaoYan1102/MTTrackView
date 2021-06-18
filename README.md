# 
传入两点坐标，在地图上显示这两点的轨迹，《苹果原生地图》

## 调用
```
    XJTrackModel *originModel = [[XJTrackModel alloc] init];
    XJTrackModel *destModel = [[XJTrackModel alloc] init];
    self.coordinate = CLLocationCoordinate2DMake(26.10083, 119.288162);
    self.coordinate2 = CLLocationCoordinate2DMake(26.435790794674897, 119.65610907446289);

    originModel.coordinate = self.coordinate;
    destModel.coordinate = self.coordinate2;
    
    self.trackView = [[XJTrackView alloc] initWithOriginTrackModel:originModel destinationTrackModel:destModel];
    
    [self.view addSubview:self.trackView];
    
    [self.trackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.leading.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.mas_equalTo(500);
    }];

```