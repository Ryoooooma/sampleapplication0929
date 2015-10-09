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
    
    double _startLati;
    double _startLongi;
    
}

@end

@implementation ThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    
    //地図の表示種類設定
    self.myMapView.mapType = MKMapTypeStandard;
    
    _appDelegate = [[UIApplication sharedApplication] delegate];
    
    self.myTextView.text = _appDelegate.infoText;
    self.title = _appDelegate.infoTitle;
    
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

//位置情報更新時に呼ばれる
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    //ユーザの位置を表示するかどうか
    self.myMapView.showsUserLocation = YES;

    //最新の位置情報を取得し、そこからマップの中心座標を決定
    CLLocation *currentLocation = locations.lastObject;
//    CLLocationCoordinate2D centerCoordinate = currentLocation.coordinate;
    //縮尺度を指定
//    MKCoordinateSpan coordinateSpan = MKCoordinateSpanMake(0.03, 0.03); //数が小さいほど拡大率アップ

//    //設定した縮尺で現在地を中心としたマップをセット（初回1回のみ）
//    if (_alreadyStartingCoordinateSet == NO) {
//        MKCoordinateRegion newRegion = MKCoordinateRegionMake(centerCoordinate, coordinateSpan);
//        [_mapView setRegion:newRegion animated:YES];
//        _alreadyStartingCoordinateSet = YES;
//    }
    //ビュー上のラベルを更新
    
//    広告の時、アニメーションの時にやったフラグのオンオフをつけてあげる（処理後に）そのあと恐らく条件分岐
//    infolatiとinfolongiの時のようなappdelegateで表現する
    
    _startLati =  currentLocation.coordinate.latitude;
    _startLongi  = currentLocation.coordinate.longitude;
    
    NSLog(@"緯度：%f", _startLati);
    NSLog(@"経度：%f", _startLongi);
    
    //表示位置を設定
    CLLocationCoordinate2D fromLocation = CLLocationCoordinate2DMake(_startLati, _startLongi);
    
    [self.myMapView setCenterCoordinate:fromLocation];
    
    //縮尺を指定
    MKCoordinateRegion cr = self.myMapView.region;
    
    //地図の範囲を指定（緯度）
    cr.span.latitudeDelta = 0.02;
    
    //地図の範囲を指定（経度)
    cr.span.longitudeDelta = 0.02;
    
    cr.center = fromLocation;
    
    [self.myMapView setRegion:cr];

    // ここから実装している10/05
    CLLocationCoordinate2D toLocation = CLLocationCoordinate2DMake(_appDelegate.endLati, _appDelegate.endLongi);
    
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
             NSLog(@"現在地からの距離は: %.f mです", route.distance);
             self.myDistanceLabel.text =[NSString stringWithFormat:@"現在地からの距離は: %.f mです",route.distance];
             // 地図上にルートを描画
             [self.myMapView addOverlay:route.polyline];
         }
     }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

@end
