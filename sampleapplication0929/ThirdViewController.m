//
//  ThirdViewController.m
//  sampleapplication0929
//
//  Created by 脇田竜馬 on 2015/09/29.
//  Copyright (c) 2015年 Ryoma Wakita. All rights reserved.
//

#import "ThirdViewController.h"
#import "AppDelegate.h"

@interface ThirdViewController (){
    AppDelegate *_appDelegate;
//    MKMapView *_mapView;

}

@end

@implementation ThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //デリゲートを設定
    self.myMapView.delegate = self;
    
    /*
     location設定
     */
    //ユーザーによる位置情報サービスの許可状態をチェック
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted ||
        [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
    {
        //ユーザーはこのアプリによる位置情報サービスの利用を許可していない、または「設定」で無効にしている
        NSLog(@"Location services is unauthorized.");
    }
    else {
        //位置情報サービスを利用できる、またはまだ利用許可要求を行っていない
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        
        //利用許可要求をまだ行っていない状態であれば要求
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
            //許可の要求
            //アプリがフォアグラウンドにある間のみ位置情報サービスを使用する許可を要求
            [self.locationManager requestWhenInUseAuthorization];
        }
        //精度要求
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        //最小移動間隔
        self.locationManager.distanceFilter = 100.0;                    //100m 移動ごとに通知
        //        self.locationManager.distanceFilter = kCLDistanceFilterNone;    //全ての動きを通知(デフォルト)
        
        //測位開始
        [self.locationManager startUpdatingLocation];
    }
    
    
    //表示位置を設定
    CLLocationCoordinate2D fromLocation = CLLocationCoordinate2DMake(10.317347, 123.905759);
    
    [self.myMapView setCenterCoordinate:fromLocation];
    
    //縮尺を指定
    MKCoordinateRegion cr = self.myMapView.region;
    
    //地図の範囲を指定（緯度）
    cr.span.latitudeDelta = 0.02;
    
    //地図の範囲を指定（経度)
    cr.span.longitudeDelta = 0.02;
    
    cr.center = fromLocation;
    
    [self.myMapView setRegion:cr];
    
    //地図の表示種類設定
    self.myMapView.mapType = MKMapTypeStandard;
    
    
    //ピンを立てる
    //アヤラ
//    MKPointAnnotation *pin =[[MKPointAnnotation alloc] init];
//    pin.coordinate = CLLocationCoordinate2DMake(10.317347, 123.905759);
//    
//    pin.title = @"Ayala";
//    pin.subtitle = @"セブで一番大きい";
//    
//    [self.myMapView addAnnotation:pin];

    
    _appDelegate = [[UIApplication sharedApplication] delegate];
    
    self.myTextView.text = _appDelegate.infoText;
    self.title = _appDelegate.infoTitle;
    
    // = _appDelegate.infoLocation;
 
//    MKPointAnnotation *pin_2 =[[MKPointAnnotation alloc] init];
//    pin_2.coordinate = CLLocationCoordinate2DMake(_appDelegate.infoLati, _appDelegate.infoLongi);
//    
//    pin_2.title = _appDelegate.infoTitle;
//    
//    [self.myMapView addAnnotation:pin_2];

    
    // ここから実装している10/05
    CLLocationCoordinate2D toLocation = CLLocationCoordinate2DMake(_appDelegate.infoLati, _appDelegate.infoLongi);

    // CLLocationCoordinate2D から MKPlacemark を生成
    MKPlacemark *fromPlacemark = [[MKPlacemark alloc] initWithCoordinate:fromLocation
                                                       addressDictionary:nil];
    MKPlacemark *toPlacemark   = [[MKPlacemark alloc] initWithCoordinate:toLocation
                                                       addressDictionary:nil];
    // MKPlacemark から MKMapItem を生成
    MKMapItem *fromItem = [[MKMapItem alloc] initWithPlacemark:fromPlacemark];
    MKMapItem *toItem   = [[MKMapItem alloc] initWithPlacemark:toPlacemark];
    
    // MKMapItem をセットして MKDirectionsRequest を生成
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    request.source = fromItem;
    request.destination = toItem;
    request.requestsAlternateRoutes = YES;
    
    // MKDirectionsRequest から MKDirections を生成
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    
    // 経路検索を実行
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error)
     {
         if (error) return;
         
         if ([response.routes count] > 0)
         {
             MKRoute *route = [response.routes objectAtIndex:0];
             NSLog(@"アヤラからの距離は: %.f mです", route.distance);
               self.myDistanceLabel.text =[NSString stringWithFormat:@"アヤラからの距離は: %.f mです",route.distance];
             // 地図上にルートを描画
             [self.myMapView addOverlay:route.polyline];
         }
     }];
    
    
    //現在位置を表示する
    self.myMapView.showsUserLocation = YES;
    
    
    //表示するためにViewに追加
    [self.view addSubview:self.myMapView];
    
}


// 地図上に描画するルートの色などを指定(これを実装しないと何も表示されない)
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView
            rendererForOverlay:(id<MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKPolyline class]])
    {
        MKPolyline *route = overlay;
        MKPolylineRenderer *routeRenderer = [[MKPolylineRenderer alloc] initWithPolyline:route];
        routeRenderer.lineWidth = 5.0;
        routeRenderer.strokeColor = [UIColor redColor];
        return routeRenderer;
    }
    else {
        return nil;
    }
}

//ピンを表示する際に発動されるデリゲートメソッド
//ピンが降ってくるアニメーションの設定
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    
    // 現在地表示なら nil を返す
    if (annotation == mapView.userLocation) {
        return nil;
    }
    static NSString *pinIdentifier = @"PinAnnotationID";
    
    //ピン情報の再利用
    MKPinAnnotationView *pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pinIdentifier];
    
    if (pinView == nil) {
        //初期化
        pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pinIdentifier];
        
        if ([annotation.title isEqualToString:@"Ayala"]) {
            //落ちるアニメーションの設定
            pinView.animatesDrop = YES;
            
        }else{
            //落ちない設定
            pinView.animatesDrop = NO;
            
        }
        
        //吹き出しの設定
        pinView.canShowCallout = YES;
    }
    
    return pinView;
}


//位置情報更新時に呼ばれる
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    //ユーザの位置を表示するかどうか
    self.myMapView.showsUserLocation = YES;
//
////    //最新の位置情報を取得し、そこからマップの中心座標を決定
////    CLLocation *currentLocation = locations.lastObject;
////    CLLocationCoordinate2D centerCoordinate = currentLocation.coordinate;
////    //縮尺度を指定
////    MKCoordinateSpan coordinateSpan = MKCoordinateSpanMake(0.03, 0.03); //数が小さいほど拡大率アップ
////
////    //設定した縮尺で現在地を中心としたマップをセット（初回1回のみ）
////    if (_alreadyStartingCoordinateSet == NO) {
////        MKCoordinateRegion newRegion = MKCoordinateRegionMake(centerCoordinate, coordinateSpan);
////        [_mapView setRegion:newRegion animated:YES];
////        _alreadyStartingCoordinateSet = YES;
////    }
//
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

@end
